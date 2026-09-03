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
    precondition {
      condition     = lookup(var.extra_envs, "INGRESS_TYPE", "") != "istio" || var.service_template != ""
      error_message = "service_template is required when extra_envs.INGRESS_TYPE is 'istio' — the k8s scope's default template is AWS ALB Ingress and won't route traffic correctly through Istio."
    }
    precondition {
      condition     = lookup(var.extra_envs, "INGRESS_TYPE", "") != "istio" || var.initial_ingress_path != ""
      error_message = "initial_ingress_path is required when extra_envs.INGRESS_TYPE is 'istio' — the k8s scope's default template is AWS ALB Ingress and won't route traffic correctly through Istio."
    }
    precondition {
      condition     = lookup(var.extra_envs, "INGRESS_TYPE", "") != "istio" || var.blue_green_ingress_path != ""
      error_message = "blue_green_ingress_path is required when extra_envs.INGRESS_TYPE is 'istio' — the k8s scope's default template is AWS ALB Ingress and won't route traffic correctly through Istio."
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
  # install dies with `namespaces "<namespace>" not found`; without
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

  values = [local.nullplatform_agent_values]

  lifecycle {
    replace_triggered_by = [terraform_data.api_key_trigger]
  }
}
