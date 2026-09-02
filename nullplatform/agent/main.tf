################################################################################
# Nullplatform agent Helm release
################################################################################

resource "terraform_data" "api_key_trigger" {
  input = var.api_key
}

resource "terraform_data" "cross_variable_validation" {
  lifecycle {
    precondition {
      condition     = var.cloud_provider != "aws" || var.aws_iam_role_arn != ""
      error_message = "aws_iam_role_arn is required when cloud_provider is 'aws'."
    }
    precondition {
      condition     = var.cloud_provider != "azure" || var.azure_client_id != null
      error_message = "azure_client_id is required when cloud_provider is 'azure'."
    }
    precondition {
      condition     = var.cloud_provider != "azure" || var.azure_client_secret != null
      error_message = "azure_client_secret is required when cloud_provider is 'azure'."
    }
    precondition {
      condition     = var.cloud_provider != "azure" || var.azure_subscription_id != null
      error_message = "azure_subscription_id is required when cloud_provider is 'azure'."
    }
    precondition {
      condition     = var.cloud_provider != "azure" || var.azure_resource_group != null
      error_message = "azure_resource_group is required when cloud_provider is 'azure'."
    }
    precondition {
      condition     = var.cloud_provider != "azure" || var.private_hosted_zone_rg != null
      error_message = "private_hosted_zone_rg is required when cloud_provider is 'azure'."
    }
    precondition {
      condition     = var.cloud_provider != "azure" || var.azure_tenant_id != null
      error_message = "azure_tenant_id is required when cloud_provider is 'azure'."
    }

    # Checked on the resolved values, so ingress_type's autofill counts as set.
    # A half-override switches template flavour mid-deploy: finalize renders
    # INITIAL_INGRESS_PATH and switch-traffic renders BLUE_GREEN_INGRESS_PATH.
    precondition {
      condition = (
        (local.resolved_ingress_templates.service_template == "" && local.resolved_ingress_templates.initial_ingress_path == "" && local.resolved_ingress_templates.blue_green_ingress_path == "") ||
        (local.resolved_ingress_templates.service_template != "" && local.resolved_ingress_templates.initial_ingress_path != "" && local.resolved_ingress_templates.blue_green_ingress_path != "")
      )
      error_message = "service_template, initial_ingress_path and blue_green_ingress_path must be set together or left entirely empty: a half-override renders one template flavour on the initial deploy and another on the traffic switch. Leave all three empty to use the scope type's defaults, or set ingress_type = \"istio\" to have them filled in."
    }

    # extra_envs is merged last, so an INGRESS_TYPE there silently outranks
    # ingress_type. Under ingress_type = "alb" extra_envs stays the sole authority.
    precondition {
      condition     = var.ingress_type != "istio" || lookup(var.extra_envs, "INGRESS_TYPE", "istio") == "istio"
      error_message = "ingress_type is 'istio' but extra_envs.INGRESS_TYPE sets a different value, and extra_envs is merged last so it would win silently. Drop the extra_envs entry, or set ingress_type = \"alb\" if the scope really uses the ALB templates."
    }
  }
}

# Deploy nullplatform agent to Kubernetes cluster via Helm chart
resource "helm_release" "agent" {
  name       = var.release_name
  chart      = "nullplatform-agent"
  repository = "https://nullplatform.github.io/helm-charts"
  namespace  = var.namespace
  version    = var.nullplatform_agent_helm_version

  # The provider defaults these three to false. Without create_namespace a fresh
  # install dies with `namespaces "nullplatform-tools" not found`; without
  # atomic/cleanup_on_fail a failed upgrade sticks in `failed` with orphaned
  # resources instead of rolling back.
  create_namespace = var.create_namespace
  atomic           = true
  cleanup_on_fail  = true

  wait_for_jobs     = true
  timeout           = 600
  reset_values      = true
  dependency_update = true
  max_history       = 10

  values = concat(
    [local.nullplatform_agent_values],
    var.worker != null ? [local.worker_values] : [],
  )

  lifecycle {
    replace_triggered_by = [terraform_data.api_key_trigger]
  }
}
