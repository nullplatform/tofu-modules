################################################################################
# Agent repository configuration
################################################################################

locals {

  scope_list = compact([trimspace(coalesce(var.agent_repos_scope, ""))])
  # Parse comma-separated extra repositories and clean whitespace
  repos_extra = compact([for s in var.agent_repos_extra : trimspace(s)])

  # Merge scope and extra repositories, removing duplicates
  final_repo_list = distinct(concat(local.scope_list, local.repos_extra))

  agent_repos = join(",", local.final_repo_list)
  tags        = join(",", [for k in sort(keys(var.tags_selectors)) : "${k}:${var.tags_selectors[k]}"])

  api_key = var.api_key

  default_args = [
    "--tags=$(TAGS)",
    "--apikey=$(NP_API_KEY)",
    "--runtime=host",
    "--command-executor-env=NP_API_KEY=$(NP_API_KEY)",
    "--command-executor-debug",
    "--webserver-enabled",
    "--command-executor-git-command-repos $(AGENT_REPOS)"
  ]

  cloud_args = {
    aws   = []
    gcp   = []
    azure = []
    oci   = []
  }

  all_args = concat(local.default_args, lookup(local.cloud_args, var.cloud_provider, []))

  # Template paths for the Istio flavour of the k8s scope type. These are the exact
  # values scopes/azure and scopes/azure-aro already hardcode in their own values.yaml,
  # against the same $SERVICE_PATH the agent expands — not new paths invented here.
  # scopes/k8s instead defaults to an AWS ALB Ingress (deployment/templates/
  # initial-ingress.yaml.tpl sets ingressClassName: alb), which is why a GKE or AKS
  # cluster running the k8s scope type needs the override at all.
  istio_ingress_templates = {
    service_template        = "$SERVICE_PATH/deployment/templates/istio/service.yaml.tpl"
    initial_ingress_path    = "$SERVICE_PATH/deployment/templates/istio/initial-httproute.yaml.tpl"
    blue_green_ingress_path = "$SERVICE_PATH/deployment/templates/istio/blue-green-httproute.yaml.tpl"
  }

  # An explicit path always wins: stacks were passing all three long before
  # ingress_type existed, sometimes at their own template copies. ingress_type only
  # fills the gaps, and only for istio — 'alb' resolves to empty so the scope type's
  # own values.yaml keeps deciding, exactly as before this variable existed.
  ingress_template_defaults = var.ingress_type == "istio" ? local.istio_ingress_templates : {
    service_template        = ""
    initial_ingress_path    = ""
    blue_green_ingress_path = ""
  }

  resolved_ingress_templates = {
    for k, explicit in {
      service_template        = var.service_template
      initial_ingress_path    = var.initial_ingress_path
      blue_green_ingress_path = var.blue_green_ingress_path
    } : k => explicit != "" ? explicit : local.ingress_template_defaults[k]
  }

  # INGRESS_TYPE is rendered only for istio, on purpose. It is read nowhere in
  # nullplatform/scopes; its only consumer is services-endpoint-exposer, as a directory
  # name ($SERVICE_PATH/workflows/$INGRESS_TYPE/$ACTION.yaml). That repo ships only
  # workflows/istio, and its service entrypoint already defaults to istio — so
  # rendering 'alb' would point it at a directory that does not exist and break
  # installs that work today. Its link entrypoint defaults to 'alb' instead, which is
  # why an Istio install does want the value stated explicitly.
  ingress_type_config = var.ingress_type == "istio" ? { INGRESS_TYPE = "istio" } : {}

  default_config = merge({
    NP_API_KEY              = local.api_key
    TAGS                    = local.tags
    AGENT_REPOS             = local.agent_repos
    CLUSTER_NAME            = var.cluster_name
    NAMESPACE               = var.namespace
    IMAGE_TAG               = var.image_tag
    DOMAIN                  = var.domain
    DNS_TYPE                = var.dns_type
    USE_ACCOUNT_SLUG        = var.use_account_slug
    IMAGE_PULL_SECRETS      = var.image_pull_secrets
    SERVICE_TEMPLATE        = local.resolved_ingress_templates.service_template
    INITIAL_INGRESS_PATH    = local.resolved_ingress_templates.initial_ingress_path
    BLUE_GREEN_INGRESS_PATH = local.resolved_ingress_templates.blue_green_ingress_path
    PRIVATE_GATEWAY_NAME    = var.private_gateway_name
    PUBLIC_GATEWAY_NAME     = var.public_gateway_name
  }, local.ingress_type_config)

  cloud_config = {
    aws = {
      AWS_IAM_ROLE_ARN = var.aws_iam_role_arn
    }

    azure = {
      PRIVATE_HOSTED_ZONE_RG = var.private_hosted_zone_rg
      RESOURCE_GROUP         = var.azure_resource_group
      AZURE_SUBSCRIPTION_ID  = var.azure_subscription_id
      AZURE_CLIENT_SECRET    = var.azure_client_secret
      AZURE_CLIENT_ID        = var.azure_client_id
      AZURE_TENANT_ID        = var.azure_tenant_id
    }

    oci = {}
  }

  # Keeps the deprecated compatibility inputs referenced from the configuration, so
  # deleting either variable fails `tofu validate` in CI rather than passing review
  # and breaking consumers at init. Deliberately not rendered into the agent config.
  # `tofu test` is not sufficient on its own here: it silently tolerates both a
  # `variables` block for an undeclared variable and a `var.x` that no longer exists,
  # so an assertion alone would not catch the removal.
  # tflint-ignore: terraform_unused_declarations
  deprecated_inputs_accepted = [var.nrn, var.private_domain]

  # Drop null values. The azure and gcp inputs default to null, and a null reaching
  # templatefile fails with "Invalid template interpolation value; The expression
  # result is null" pointing at a line in the values template — an error that names
  # no variable, and which fires before the preconditions below can report the
  # actual missing input. Filtering here means an unset optional value simply is not
  # rendered as an env var, and the precondition gets to speak.
  all_config = {
    for k, v in merge(
      local.default_config,
      lookup(local.cloud_config, var.cloud_provider, {}),
      var.extra_envs,
    ) : k => v if v != null
  }

  # Template único y simple
  nullplatform_agent_values = templatefile("${path.module}/templates/nullplatform_agent_values.tmpl.yaml", {
    args                 = local.all_args
    config_values        = local.all_config
    image_tag            = var.image_tag
    image_repository     = var.image_repository
    aws_iam_role_arn     = var.cloud_provider == "aws" ? var.aws_iam_role_arn : ""
    init_scripts         = var.init_scripts
    service_account_name = var.service_account_name
  })

  # Worker-orchestration config as a second Helm values layer, so the nested
  # shape (allowedRegistries/patches/rules/pins) passes through verbatim.
  worker_values = var.worker != null ? yamlencode({ worker = var.worker }) : null
}
