locals {
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
      annotations = {
        "eks.amazonaws.com/role-arn" = var.aws_iam_role_arn
      }
    }
    extraArgs = compact([
      "--aws-zone-type=public",
      "--zone-id-filter=${var.public_hosted_zone_id}",
      "--domain-filter=${var.domain_filters}"
    ])
  }

  oci_config = {
    provider = { name = "oci" }
    env = [
      {
        name  = "OCI_RESOURCE_PRINCIPAL_VERSION"
        value = "2.2"
      }
    ]
    serviceAccount = {
      create = true
      name   = var.oci_service_account_name
      annotations = {
        "oci.oraclecloud.com/workload-identity" = "true"
      }
    }
    extraArgs = compact([
      "--oci-compartment-ocid=${var.oci_compartment_ocid}",
      "--oci-auth-instance-principal",
      "--domain-filter=${var.domain_filters}",
      "--txt-owner-id=${var.txt_owner_id}"
    ])
  }

  provider_configs = {
    cloudflare = local.cloudflare_config
    aws        = local.route53_config
    oci        = local.oci_config
  }

  external_dns_values = merge(local.base_config, local.provider_configs[var.dns_provider_name])
}