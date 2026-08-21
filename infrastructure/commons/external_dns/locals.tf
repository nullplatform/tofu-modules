locals {
  effective_label_filter = (
    var.label_filter != null ? var.label_filter :
    var.zone_type != "" ? "dns/zone-type=${var.zone_type}" :
    ""
  )

  base_config = {
    sources       = var.sources
    domainFilters = [var.domain_filters]
    policy        = var.policy
    txtOwnerId    = var.txt_owner_id
    registry      = "txt"
    logLevel      = "info"
  }

  cloudflare_config = {
    provider = { name = "cloudflare" }
    env = [{
      name = "CF_API_TOKEN"
      valueFrom = {
        secretKeyRef = {
          name = "external-dns-cloudflare"
          key  = "api-token"
        }
      }
    }]
  }

  route53_config = {
    provider = { name = "aws" }
    env = [{
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }]
    serviceAccount = {
      create = true
      annotations = var.aws_identity_mode == "irsa" ? {
        "eks.amazonaws.com/role-arn" = var.aws_iam_role_arn
      } : {}
    }
    rbac = {
      create = true
      additionalPermissions = [
        {
          apiGroups = ["externaldns.k8s.io"]
          resources = ["dnsendpoints"]
          verbs     = ["get", "list", "watch", "create", "update", "patch", "delete"]
        }
      ]
    }
    extraArgs = compact([
      "--aws-zone-type=${var.zone_type}",
      "--zone-id-filter=${var.zone_id_filter}",
      local.effective_label_filter != "" ? "--label-filter=${local.effective_label_filter}" : ""
    ])
  }

  oci_config = {
    provider = { name = "oci" }
    serviceAccount = {
      create = true
      name   = var.oci_service_account_name
    }
    env = [
      {
        name  = "OCI_GO_SDK_DEBUG"
        value = "info"
      }
    ]
    extraArgs = [
      "--oci-compartment-ocid=${var.oci_compartment_ocid}",
      "--oci-zone-scope=${var.oci_zone_scope}",
      "--oci-zones-cache-duration=${var.oci_zones_cache_duration}"
    ]
    extraVolumes = [
      {
        name = "oci-config"
        secret = {
          secretName = "external-dns-config"
        }
      }
    ]
    extraVolumeMounts = [
      {
        name      = "oci-config"
        mountPath = "/etc/kubernetes/"
        readOnly  = true
      }
    ]
  }

  # Both `azure` (Public DNS zones) and `azure-private-dns` (Private DNS zones)
  # share the same auth, secret mount, and ServiceAccount wiring — only the
  # external-dns `provider.name` differs.
  azure_family_active = contains(["azure", "azure-private-dns"], var.dns_provider_name)

  azure_config = {
    provider = { name = var.dns_provider_name }
    serviceAccount = {
      create = true
      annotations = var.azure_workload_identity_enabled ? {
        "azure.workload.identity/client-id" = var.azure_client_id
      } : {}
    }
    podLabels = var.azure_workload_identity_enabled ? {
      "azure.workload.identity/use" = "true"
    } : {}
    extraVolumes = [
      {
        name = "azure-config"
        secret = {
          secretName = "external-dns-azure-config"
        }
      }
    ]
    extraVolumeMounts = [
      {
        name      = "azure-config"
        mountPath = "/etc/kubernetes"
        readOnly  = true
      }
    ]
  }

  google_config = {
    provider = { name = "google" }
    google   = { project = var.gcp_project_id }
    serviceAccount = {
      create = true
      name   = var.gcp_service_account_name
      annotations = {
        "iam.gke.io/gcp-service-account" = var.gcp_service_account_email
      }
    }
    extraArgs = ["--google-zone-visibility=${var.zone_type}"]
  }

  provider_configs = {
    cloudflare          = local.cloudflare_config
    aws                 = local.route53_config
    oci                 = local.oci_config
    azure               = local.azure_config
    "azure-private-dns" = local.azure_config
    google              = local.google_config
  }

  external_dns_values = merge(local.base_config, local.provider_configs[var.dns_provider_name])
}
