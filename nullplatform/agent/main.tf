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
    # The ingress templates are all-or-nothing.
    #
    # This replaces the three preconditions that shipped in v6.14.0. Their diagnosis
    # was right — scopes/k8s really does default to an AWS ALB Ingress
    # (deployment/templates/initial-ingress.yaml.tpl sets ingressClassName: alb plus
    # eight alb.ingress.kubernetes.io annotations) — but neither of the two available
    # signals can decide whether an override is NEEDED:
    #
    #   - extra_envs.INGRESS_TYPE, which they used, is not read anywhere in
    #     nullplatform/scopes (zero occurrences on main and beta). Its only consumer
    #     in the org is services-endpoint-exposer, for picking a workflow directory.
    #   - cloud_provider fails too: each scope type sets these three values in its own
    #     values.yaml, and scopes/azure and scopes/azure-aro already point at Istio and
    #     ARO HTTPRoute templates. An AKS install on the `azure` scope type needs no
    #     override, so keying on cloud_provider != "aws" would block a valid config.
    #
    # What IS checkable here is coherence, and a partial override is worse than none.
    # finalize.yaml feeds INITIAL_INGRESS_PATH and switch_traffic.yaml feeds
    # BLUE_GREEN_INGRESS_PATH into the same TEMPLATE slot of the same workflow, so
    # overriding one and not the other renders an HTTPRoute on the initial deploy and
    # an ALB Ingress on the traffic switch — the deploy gets partway through and then
    # breaks. All three scope types set all three values; a caller overriding for a
    # GKE or AKS cluster on the `k8s` scope type must do the same.
    precondition {
      condition = (
        (var.service_template == "" && var.initial_ingress_path == "" && var.blue_green_ingress_path == "") ||
        (var.service_template != "" && var.initial_ingress_path != "" && var.blue_green_ingress_path != "")
      )
      error_message = "service_template, initial_ingress_path and blue_green_ingress_path must be set together or left entirely empty. Setting only some of them mixes template flavours across a single deployment: finalize renders INITIAL_INGRESS_PATH and switch-traffic renders BLUE_GREEN_INGRESS_PATH, so a half-override breaks blue-green mid-deploy. Leave all three empty to use the scope type's own defaults (scopes/azure and scopes/azure-aro already point at HTTPRoute templates); set all three when running the k8s scope type on a cluster without an AWS ALB."
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
