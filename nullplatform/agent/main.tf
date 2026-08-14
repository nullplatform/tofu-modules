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
    # The three ingress-template preconditions that shipped in v6.14.0 were removed
    # here. They keyed off extra_envs.INGRESS_TYPE == "istio", and that signal does
    # not exist: INGRESS_TYPE appears nowhere in nullplatform/scopes. Its only
    # consumer in the org is services-endpoint-exposer, which uses it to pick a
    # service workflow directory.
    #
    # Re-keying on cloud_provider != "aws" does not work either. Each scope type
    # already sets these three values in its own values.yaml — scopes/azure and
    # scopes/azure-aro point at Istio and ARO HTTPRoute templates, scopes/k8s points
    # at Ingress — so the agent's env vars are overrides, not the source of truth.
    # An AKS install on the `azure` scope type needs no override and would be
    # wrongly blocked.
    #
    # The real gap is a GKE/AKS cluster running the `k8s` scope type, whose default
    # is the AWS ALB Ingress template. The agent module cannot detect that: it never
    # learns which scope type a deployment will use. Left to documentation on the
    # three variables until the scopes repo grows a cloud-agnostic default or a gcp
    # scope type.
  }
}

# Deploy nullplatform agent to Kubernetes cluster via Helm chart
resource "helm_release" "agent" {
  name       = var.release_name
  chart      = "nullplatform-agent"
  repository = "https://nullplatform.github.io/helm-charts"
  namespace  = var.namespace
  version    = var.nullplatform_agent_helm_version

  # create_namespace defaults to false in the helm provider, so without this the
  # release fails with `namespaces "nullplatform-tools" not found` on any cluster
  # where the namespace does not already exist. It only appeared to work because
  # nullplatform/base pre-creates that namespace, and consumers do not always
  # declare a dependency on it.
  create_namespace = true

  # atomic + cleanup_on_fail also default to false. Without them a failed upgrade —
  # including the destroy/create that replace_triggered_by fires on every API-key
  # rotation — leaves the release stuck in `failed` with orphaned resources, and the
  # next apply needs a manual `helm rollback`.
  atomic          = true
  cleanup_on_fail = true

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
