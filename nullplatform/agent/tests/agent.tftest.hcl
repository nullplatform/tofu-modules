mock_provider "nullplatform" {}
mock_provider "helm" {}

variables {
  api_key        = "test-api-key"
  cluster_name   = "test-cluster"
  tags_selectors = { environment = "test" }
  image_tag      = "latest"
  cloud_provider = "gcp"
}

###############################################################################
# Deprecated-but-accepted inputs
###############################################################################

run "deprecated_inputs_are_accepted_and_not_rendered" {
  command = plan

  variables {
    nrn            = "organization=1:account=2"
    private_domain = "internal.example.com"
  }

  assert {
    condition     = local.deprecated_inputs_accepted[0] == "organization=1:account=2"
    error_message = "nrn must stay declared: OpenTofu errors on an argument for an undeclared variable"
  }

  assert {
    condition     = local.deprecated_inputs_accepted[1] == "internal.example.com"
    error_message = "private_domain must stay declared on the 6.x line"
  }

  assert {
    condition     = !contains(keys(local.all_config), "NRN") && !contains(keys(local.all_config), "PRIVATE_DOMAIN")
    error_message = "Both are accepted for compatibility only and must not reach the agent config"
  }
}

###############################################################################
# Helm release lifecycle
###############################################################################

run "release_flags_are_not_left_at_the_provider_defaults" {
  command = plan

  assert {
    condition     = helm_release.agent.create_namespace == true
    error_message = "create_namespace defaults to false in the provider, and the release then fails with 'namespaces not found' on a fresh cluster"
  }

  assert {
    condition     = helm_release.agent.atomic == true && helm_release.agent.cleanup_on_fail == true
    error_message = "Without atomic and cleanup_on_fail a failed upgrade sticks in `failed` with orphaned resources"
  }
}

run "namespace_creation_can_be_handed_to_another_module" {
  command = plan

  variables {
    create_namespace = false
  }

  assert {
    condition     = helm_release.agent.create_namespace == false
    error_message = "Stacks where nullplatform/base owns the namespace must be able to opt out"
  }
}

###############################################################################
# Env-var surface per cloud provider
###############################################################################

run "gateway_names_are_rendered" {
  command = plan

  assert {
    condition     = local.all_config["PRIVATE_GATEWAY_NAME"] == "gateway-private"
    error_message = "The private gateway default must match the Gateway nullplatform/base creates"
  }

  assert {
    condition     = local.all_config["PUBLIC_GATEWAY_NAME"] == "gateway-public"
    error_message = "The public gateway default must match nullplatform/base's default"
  }
}

run "gateway_names_are_rendered_for_aws_too" {
  command = plan

  variables {
    cloud_provider   = "aws"
    aws_iam_role_arn = "arn:aws:iam::123456789012:role/test-role"
  }

  assert {
    condition     = local.all_config["PRIVATE_GATEWAY_NAME"] == "gateway-private"
    error_message = "AWS needs them too: base creates gateway-private while the k8s scope falls back to gateway-internal, a confirmed internal-traffic outage"
  }
}

run "caller_overrides_and_extra_envs_win" {
  command = plan

  variables {
    public_gateway_name = "internet-facing"
    extra_envs          = { PRIVATE_GATEWAY_NAME = "gateway-custom" }
  }

  assert {
    condition     = local.all_config["PUBLIC_GATEWAY_NAME"] == "internet-facing"
    error_message = "An overridden gateway name must reach the agent: AKS installs commonly use internet-facing"
  }

  assert {
    condition     = local.all_config["PRIVATE_GATEWAY_NAME"] == "gateway-custom"
    error_message = "extra_envs is merged last and must override the typed variables"
  }
}

run "aws_config_carries_the_role_arn_and_no_azure_keys" {
  command = plan

  variables {
    cloud_provider   = "aws"
    aws_iam_role_arn = "arn:aws:iam::123456789012:role/test-role"
  }

  assert {
    condition     = local.all_config["AWS_IAM_ROLE_ARN"] == "arn:aws:iam::123456789012:role/test-role"
    error_message = "The AWS role ARN must be rendered for cloud_provider aws"
  }

  assert {
    condition     = !contains(keys(local.all_config), "AZURE_TENANT_ID")
    error_message = "Azure-only keys must not leak into an AWS agent config"
  }
}

run "azure_config_carries_the_azure_keys" {
  command = plan

  variables {
    cloud_provider         = "azure"
    azure_client_id        = "client-id"
    azure_client_secret    = "client-secret"
    azure_subscription_id  = "sub-id"
    azure_resource_group   = "rg"
    private_hosted_zone_rg = "rg-dns"
    azure_tenant_id        = "tenant-id"
  }

  assert {
    condition     = local.all_config["AZURE_TENANT_ID"] == "tenant-id" && local.all_config["RESOURCE_GROUP"] == "rg"
    error_message = "Azure keys must be rendered for cloud_provider azure"
  }

  assert {
    condition     = !contains(keys(local.all_config), "AWS_IAM_ROLE_ARN")
    error_message = "AWS-only keys must not leak into an Azure agent config"
  }
}

run "oci_gets_the_shared_config_only" {
  command = plan

  variables {
    cloud_provider = "oci"
  }

  assert {
    condition     = contains(keys(local.all_config), "PRIVATE_GATEWAY_NAME") && !contains(keys(local.all_config), "AWS_IAM_ROLE_ARN")
    error_message = "oci has no cloud-specific keys and must still receive the shared config"
  }
}

###############################################################################
# Ingress templates
###############################################################################

run "defaults_leave_the_templates_to_the_scope_type" {
  command = plan

  assert {
    condition     = local.all_config["SERVICE_TEMPLATE"] == "" && local.all_config["INITIAL_INGRESS_PATH"] == ""
    error_message = "Empty templates must pass through so the scope type's own values.yaml decides"
  }

  assert {
    condition     = !contains(keys(local.all_config), "INGRESS_TYPE")
    error_message = "The default must not render INGRESS_TYPE: services-endpoint-exposer ships only workflows/istio, so injecting 'alb' breaks installs that work today"
  }
}

run "ingress_templates_pass_through_when_all_three_are_set" {
  command = plan

  variables {
    service_template        = "/custom/service.yaml.tpl"
    initial_ingress_path    = "/custom/initial-httproute.yaml.tpl"
    blue_green_ingress_path = "/custom/blue-green-httproute.yaml.tpl"
  }

  assert {
    condition     = local.all_config["INITIAL_INGRESS_PATH"] == "/custom/initial-httproute.yaml.tpl"
    error_message = "Overridden ingress templates must reach the agent config"
  }
}

run "partial_ingress_override_is_rejected_without_blue_green" {
  command = plan

  variables {
    service_template     = "/custom/service.yaml.tpl"
    initial_ingress_path = "/custom/initial-httproute.yaml.tpl"
  }

  expect_failures = [terraform_data.cross_variable_validation]
}

run "partial_ingress_override_is_rejected_without_service" {
  command = plan

  variables {
    initial_ingress_path    = "/custom/initial-httproute.yaml.tpl"
    blue_green_ingress_path = "/custom/blue-green-httproute.yaml.tpl"
  }

  expect_failures = [terraform_data.cross_variable_validation]
}

run "extra_envs_ingress_type_does_not_block_an_alb_scope" {
  command = plan

  variables {
    cloud_provider   = "aws"
    aws_iam_role_arn = "arn:aws:iam::123456789012:role/test-role"
    # v6.14.0 turned this into a hard plan failure that demanded Istio templates an
    # EKS/ALB scope does not want.
    extra_envs = { INGRESS_TYPE = "istio" }
  }

  assert {
    condition     = local.all_config["INGRESS_TYPE"] == "istio"
    error_message = "INGRESS_TYPE must pass through as an ordinary env var without forcing the ingress templates"
  }
}

###############################################################################
# ingress_type
###############################################################################

run "invalid_ingress_type_is_rejected" {
  command = plan

  variables {
    ingress_type = "nginx"
  }

  expect_failures = [var.ingress_type]
}

run "istio_autofills_the_three_templates_and_the_env_var" {
  command = plan

  variables {
    ingress_type = "istio"
  }

  assert {
    condition = (local.all_config["SERVICE_TEMPLATE"] == "$SERVICE_PATH/deployment/templates/istio/service.yaml.tpl" &&
      local.all_config["INITIAL_INGRESS_PATH"] == "$SERVICE_PATH/deployment/templates/istio/initial-httproute.yaml.tpl" &&
    local.all_config["BLUE_GREEN_INGRESS_PATH"] == "$SERVICE_PATH/deployment/templates/istio/blue-green-httproute.yaml.tpl")
    error_message = "ingress_type istio must supply the same three Istio templates scopes/azure hardcodes, or the deploy renders an ALB Ingress"
  }

  assert {
    condition     = local.all_config["INGRESS_TYPE"] == "istio"
    error_message = "services-endpoint-exposer's link entrypoint defaults to 'alb', so an Istio install needs the value stated"
  }
}

run "explicit_templates_win_over_the_istio_autofill" {
  command = plan

  variables {
    ingress_type            = "istio"
    service_template        = "/custom/service.yaml.tpl"
    initial_ingress_path    = "/custom/initial.yaml.tpl"
    blue_green_ingress_path = "/custom/blue-green.yaml.tpl"
  }

  assert {
    condition     = local.all_config["SERVICE_TEMPLATE"] == "/custom/service.yaml.tpl"
    error_message = "Stacks pinned to their own template copies were passing all three before ingress_type existed"
  }
}

run "istio_autofill_completes_a_partial_override" {
  command = plan

  variables {
    ingress_type     = "istio"
    service_template = "/custom/service.yaml.tpl"
  }

  assert {
    condition = (local.all_config["SERVICE_TEMPLATE"] == "/custom/service.yaml.tpl" &&
    local.all_config["BLUE_GREEN_INGRESS_PATH"] == "$SERVICE_PATH/deployment/templates/istio/blue-green-httproute.yaml.tpl")
    error_message = "Under istio the unset paths are filled in rather than rejected, keeping the deploy on one flavour"
  }
}

run "istio_with_conflicting_extra_envs_is_rejected" {
  command = plan

  variables {
    ingress_type = "istio"
    extra_envs   = { INGRESS_TYPE = "alb" }
  }

  expect_failures = [terraform_data.cross_variable_validation]
}

run "istio_with_matching_extra_envs_is_allowed" {
  command = plan

  variables {
    ingress_type = "istio"
    extra_envs   = { INGRESS_TYPE = "istio" }
  }

  assert {
    condition     = local.all_config["INGRESS_TYPE"] == "istio"
    error_message = "Restating the same value is redundant but harmless and must keep planning"
  }
}

###############################################################################
# Existing cross-variable validations still hold
###############################################################################

run "aws_requires_the_role_arn" {
  command = plan

  variables {
    cloud_provider = "aws"
  }

  expect_failures = [terraform_data.cross_variable_validation]
}

run "azure_requires_its_credentials" {
  command = plan

  variables {
    cloud_provider = "azure"
  }

  expect_failures = [terraform_data.cross_variable_validation]
}

run "invalid_cloud_provider_is_rejected" {
  command = plan

  variables {
    cloud_provider = "digitalocean"
  }

  expect_failures = [var.cloud_provider]
}
