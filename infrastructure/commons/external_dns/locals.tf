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
    serviceAccount = {
      create = true
      name   = var.gcp_service_account_name
      annotations = {
        "iam.gke.io/gcp-service-account" = var.gcp_service_account_email
      }
    }
    extraArgs = [
      "--google-project=${var.gcp_project_id}",
      "--google-zone-visibility=${lower(var.zone_type)}",
    ]
  }

  # PowerDNS: API key travels as an env var, not extraArgs, so it never lands
  # in the pod's command line (kingpin auto-derives EXTERNAL_DNS_PDNS_API_KEY
  # from the --pdns-api-key flag).
  pdns_config = {
    provider = { name = "pdns" }
    extraArgs = compact([
      "--pdns-server=${var.pdns_server}",
      "--pdns-server-id=${var.pdns_server_id}",
      var.pdns_skip_tls_verify ? "--pdns-skip-tls-verify" : "",
    ])
    env = [{
      name = "EXTERNAL_DNS_PDNS_API_KEY"
      valueFrom = {
        secretKeyRef = {
          name = "external-dns-pdns"
          key  = "api-key"
        }
      }
    }]
  }

  # RFC2136 (BIND, Knot, etc. via dynamic updates). TSIG auth is the default;
  # rfc2136_insecure=true skips it for lab/dev servers with no TSIG configured.
  rfc2136_config = {
    provider = { name = "rfc2136" }
    extraArgs = concat(
      [
        "--rfc2136-host=${var.rfc2136_host}",
        "--rfc2136-port=${var.rfc2136_port}",
        "--rfc2136-zone=${var.rfc2136_zone}",
      ],
      var.rfc2136_insecure ? ["--rfc2136-insecure"] : [
        "--rfc2136-tsig-keyname=${var.rfc2136_tsig_keyname}",
        "--rfc2136-tsig-secret-alg=${var.rfc2136_tsig_secret_alg}",
      ]
    )
    env = var.rfc2136_insecure ? [] : [{
      name = "EXTERNAL_DNS_RFC2136_TSIG_SECRET"
      valueFrom = {
        secretKeyRef = {
          name = "external-dns-rfc2136"
          key  = "tsig-secret"
        }
      }
    }]
  }

  provider_configs = {
    cloudflare          = local.cloudflare_config
    aws                 = local.route53_config
    oci                 = local.oci_config
    azure               = local.azure_config
    "azure-private-dns" = local.azure_config
    google              = local.google_config
    pdns                = local.pdns_config
    rfc2136             = local.rfc2136_config
  }

  external_dns_values = merge(local.base_config, local.provider_configs[var.dns_provider_name])
}
