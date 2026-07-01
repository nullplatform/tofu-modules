mock_provider "helm" {}
mock_provider "kubernetes" {}

variables {
  dns_provider_name      = "aws"
  domain_filters         = "myorg.example.com"
  external_dns_namespace = "external-dns"
  aws_region             = "us-east-1"
  aws_iam_role_arn       = "arn:aws:iam::123456789012:role/external-dns"
  zone_id_filter         = "Z1234567890ABC"
  zone_type              = "public"
}

run "aws_full_config" {
  command = plan

  assert {
    condition     = helm_release.external_dns.name == "external-dns-public"
    error_message = "Helm release name should include type suffix"
  }
}

run "aws_irsa_annotation" {
  command = plan

  assert {
    condition     = local.route53_config.serviceAccount.annotations["eks.amazonaws.com/role-arn"] == "arn:aws:iam::123456789012:role/external-dns"
    error_message = "AWS IRSA annotation should match aws_iam_role_arn"
  }
}

run "aws_zone_filtering_args" {
  command = plan

  assert {
    condition     = contains(local.route53_config.extraArgs, "--aws-zone-type=public")
    error_message = "Extra args should include --aws-zone-type"
  }

  assert {
    condition     = contains(local.route53_config.extraArgs, "--zone-id-filter=Z1234567890ABC")
    error_message = "Extra args should include --zone-id-filter"
  }
}

run "default_sources_is_crd_only" {
  command = plan

  assert {
    condition     = length(local.base_config.sources) == 1 && local.base_config.sources[0] == "crd"
    error_message = "Default sources should be crd-only (no gateway-httproute)"
  }
}

run "rbac_has_no_gateway_permissions" {
  command = plan

  assert {
    condition     = length(local.route53_config.rbac.additionalPermissions) == 1
    error_message = "RBAC should only grant the crd (dnsendpoints) permission"
  }

  assert {
    condition     = local.route53_config.rbac.additionalPermissions[0].apiGroups == ["externaldns.k8s.io"]
    error_message = "The only additional RBAC permission should be for externaldns.k8s.io/dnsendpoints"
  }

  assert {
    condition = !contains(
      [for p in local.route53_config.rbac.additionalPermissions : p.apiGroups[0]],
      "gateway.networking.k8s.io"
    )
    error_message = "RBAC must not include gateway.networking.k8s.io permissions after removing the gateway-httproute source"
  }
}

run "no_cloudflare_secret_for_aws" {
  command = plan

  assert {
    condition     = length(kubernetes_secret_v1.external_dns_cloudflare) == 0
    error_message = "Cloudflare secret should not be created for AWS provider"
  }
}

run "aws_requires_region" {
  command = plan

  variables {
    aws_region = ""
  }

  expect_failures = [terraform_data.provider_validation]
}

run "aws_requires_iam_role" {
  command = plan

  variables {
    aws_iam_role_arn = ""
  }

  expect_failures = [terraform_data.provider_validation]
}

run "aws_requires_zone_id_filter" {
  command = plan

  variables {
    zone_id_filter = ""
  }

  expect_failures = [terraform_data.provider_validation]
}

run "aws_rejects_invalid_zone_type" {
  command = plan

  variables {
    zone_type = "internal"
  }

  expect_failures = [terraform_data.provider_validation]
}

run "aws_pod_identity_omits_role_annotation" {
  command = plan

  variables {
    aws_identity_mode = "pod_identity"
  }

  assert {
    condition     = !contains(keys(local.route53_config.serviceAccount.annotations), "eks.amazonaws.com/role-arn")
    error_message = "Pod Identity mode must omit the IRSA role-arn annotation"
  }
}
