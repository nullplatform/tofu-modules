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
      condition     = var.cloud_provider != "azure" || var.azure_use_workload_identity || var.azure_client_secret != null
      error_message = "azure_client_secret is required when cloud_provider is 'azure' and azure_use_workload_identity is false."
    }
    precondition {
      condition     = !(var.cloud_provider == "azure" && var.azure_use_workload_identity) || try(trimspace(var.azure_client_id), "") != ""
      error_message = "azure_client_id must be a non-empty client ID when azure_use_workload_identity is true (it becomes the ServiceAccount's azure.workload.identity/client-id annotation)."
    }
    precondition {
      condition     = !(var.cloud_provider == "azure" && var.azure_use_workload_identity) || length(var.azure_federated_credential_id) > 0
      error_message = "azure_federated_credential_id is required when cloud_provider is 'azure' and azure_use_workload_identity is true. Pass the federated identity credential's id to enforce dependency ordering."
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
      condition     = var.cloud_provider != "azure" || var.private_gateway_name != null
      error_message = "private_gateway_name is required when cloud_provider is 'azure'."
    }
    precondition {
      condition     = var.cloud_provider != "azure" || var.private_hosted_zone_rg != null
      error_message = "private_hosted_zone_rg is required when cloud_provider is 'azure'."
    }
    precondition {
      condition     = var.cloud_provider != "azure" || var.public_gateway_name != null
      error_message = "public_gateway_name is required when cloud_provider is 'azure'."
    }
    precondition {
      condition     = var.cloud_provider != "azure" || var.azure_tenant_id != null
      error_message = "azure_tenant_id is required when cloud_provider is 'azure'."
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

  create_namespace  = true
  disable_webhooks  = false
  force_update      = true
  wait              = true
  wait_for_jobs     = true
  timeout           = 600
  atomic            = true
  cleanup_on_fail   = true
  replace           = true
  recreate_pods     = true
  reset_values      = true
  reuse_values      = false
  dependency_update = true
  max_history       = 10

  values = [local.nullplatform_agent_values]

  # Gate the release on the cross-variable validation. Because that resource
  # references var.azure_federated_credential_id, wiring the caller's federated
  # credential id into it makes the Helm release wait until the credential
  # exists before the pod attempts its workload-identity token exchange.
  depends_on = [terraform_data.cross_variable_validation]

  lifecycle {
    replace_triggered_by = [terraform_data.api_key_trigger]
  }
}
