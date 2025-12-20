locals {
  base_config = {
    sources       = ["crd", "service", "ingress", "gateway-httproute", "gateway-grpcroute"]
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
    extraArgs = var.hosted_zone_id != "" ? ["--aws-zone-type=public", "--zone-id-filter=${var.hosted_zone_id}"] : []
  }

  provider_configs = {
    cloudflare = local.cloudflare_config
    aws        = local.route53_config
  }

  external_dns_values = merge(local.base_config, local.provider_configs[var.dns_provider_name])
}