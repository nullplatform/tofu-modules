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
      "--zone-id-filter=${var.zone_id_filter}"
    ])
  }

  provider_configs = {
    cloudflare = local.cloudflare_config
    aws        = local.route53_config
  }

  external_dns_values = merge(local.base_config, local.provider_configs[var.dns_provider_name])
}