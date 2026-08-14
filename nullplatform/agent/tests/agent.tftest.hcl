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
#
# Removing a declared input breaks every consumer that passes it, since OpenTofu
# rejects an argument for a variable that does not exist. These runs fail if the
# variables are deleted again.
###############################################################################

run "nrn_is_still_accepted" {
  command = plan

  variables {
    nrn = "organization=1:account=2"
  }

  assert {
    condition     = local.deprecated_inputs_accepted[0] == "organization=1:account=2"
    error_message = "nrn must remain a declared input on the 6.x line: consumers pass it and OpenTofu errors on an argument for an undeclared variable"
  }
}

run "private_domain_is_still_accepted" {
  command = plan

  variables {
    private_domain = "internal.example.com"
  }

  assert {
    condition     = local.deprecated_inputs_accepted[1] == "internal.example.com"
    error_message = "private_domain must remain a declared input on the 6.x line"
  }
}

run "deprecated_inputs_are_not_rendered_into_the_agent_config" {
  command = plan

  variables {
    nrn            = "organization=1:account=2"
    private_domain = "internal.example.com"
  }

  assert {
    condition     = !contains(keys(local.all_config), "NRN")
    error_message = "nrn is accepted for compatibility only and must not reach the agent config"
  }

  assert {
    condition     = !contains(keys(local.all_config), "PRIVATE_DOMAIN")
    error_message = "PRIVATE_DOMAIN is dead in nullplatform/scopes and must not be rendered"
  }
}

###############################################################################
# Helm release lifecycle
###############################################################################

run "namespace_is_created" {
  command = plan

  assert {
    condition     = helm_release.agent.create_namespace == true
    error_message = "create_namespace must stay true: the provider defaults it to false, and the release fails with 'namespaces not found' on any cluster where nullplatform/base has not already created it"
  }
}

run "failed_upgrades_roll_back" {
  command = plan

  assert {
    condition     = helm_release.agent.atomic == true && helm_release.agent.cleanup_on_fail == true
    error_message = "atomic and cleanup_on_fail must stay true, or a failed upgrade leaves the release in `failed` with orphaned resources instead of rolling back"
  }
}

###############################################################################
# Env-var surface per cloud provider
#
# The whole point of the module is what it renders into the agent's config, and
# nothing covered it. A key silently gained or lost per cloud is a routing outage.
###############################################################################

run "gateway_names_are_rendered_for_gcp" {
  command = plan

  assert {
    condition     = local.all_config["PRIVATE_GATEWAY_NAME"] == "gateway-private"
    error_message = "The private gateway default must match the Gateway nullplatform/base actually creates"
  }

  assert {
    condition     = local.all_config["PUBLIC_GATEWAY_NAME"] == "gateway-public"
    error_message = "The public gateway default must match nullplatform/base's gateway_public_name default"
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
    error_message = "AWS must receive the gateway names too: base creates gateway-private while the k8s scope falls back to gateway-internal, and that mismatch is a confirmed internal-traffic outage"
  }
}

run "caller_can_override_gateway_names" {
  command = plan

  variables {
    public_gateway_name = "internet-facing"
  }

  assert {
    condition     = local.all_config["PUBLIC_GATEWAY_NAME"] == "internet-facing"
    error_message = "An overridden gateway name must reach the agent: AKS installs commonly name the public Gateway internet-facing"
  }
}

run "extra_envs_win_over_defaults" {
  command = plan

  variables {
    extra_envs = { PRIVATE_GATEWAY_NAME = "gateway-custom" }
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
#
# No precondition gates these: the scope type's own values.yaml supplies defaults
# (scopes/azure and scopes/azure-aro already point at Istio templates), so the
# agent cannot tell whether an override is needed. These runs pin that the values
# pass through untouched and that leaving them empty is allowed.
###############################################################################

run "empty_ingress_templates_are_allowed_on_any_cloud" {
  command = plan

  variables {
    cloud_provider = "gcp"
  }

  assert {
    condition     = local.all_config["SERVICE_TEMPLATE"] == ""
    error_message = "An empty template must pass through so the scope type's own default applies"
  }
}

run "ingress_templates_pass_through_when_set" {
  command = plan

  variables {
    service_template        = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/service.yaml.tpl"
    initial_ingress_path    = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/initial-httproute.yaml.tpl"
    blue_green_ingress_path = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/blue-green-httproute.yaml.tpl"
  }

  assert {
    condition     = local.all_config["INITIAL_INGRESS_PATH"] == "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/initial-httproute.yaml.tpl"
    error_message = "Overridden ingress templates must reach the agent config"
  }
}

run "setting_ingress_type_does_not_block_aws" {
  command = plan

  variables {
    cloud_provider   = "aws"
    aws_iam_role_arn = "arn:aws:iam::123456789012:role/test-role"
    # A real pattern: INGRESS_TYPE is consumed by services-endpoint-exposer to pick
    # a workflow directory. v6.14.0 turned it into a hard plan failure that demanded
    # Istio templates an EKS/ALB scope does not want.
    extra_envs = { INGRESS_TYPE = "istio" }
  }

  assert {
    condition     = local.all_config["INGRESS_TYPE"] == "istio"
    error_message = "INGRESS_TYPE must pass through as an ordinary env var without forcing the ingress templates"
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

  expect_failures = [
    terraform_data.cross_variable_validation,
  ]
}

run "azure_requires_its_credentials" {
  command = plan

  variables {
    cloud_provider = "azure"
  }

  expect_failures = [
    terraform_data.cross_variable_validation,
  ]
}

run "invalid_cloud_provider_is_rejected" {
  command = plan

  variables {
    cloud_provider = "digitalocean"
  }

  expect_failures = [var.cloud_provider]
}
