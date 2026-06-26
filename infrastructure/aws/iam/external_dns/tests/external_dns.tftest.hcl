mock_provider "aws" {
  override_data {
    target = module.nullplatform_external_dns_role.data.aws_iam_policy_document.assume
    values = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Federated\":\"test\"},\"Action\":\"sts:AssumeRoleWithWebIdentity\"}]}"
    }
  }
  override_resource {
    target = aws_iam_policy.nullplatform_external_dns_policy
    values = {
      arn = "arn:aws:iam::123456789012:policy/nullplatform-test-cluster-external-dns-policy"
    }
  }
}

variables {
  cluster_name                        = "test-cluster"
  hosted_zone_public_id               = "Z1234567890ABC"
  hosted_zone_private_id              = "Z0987654321DEF"
  aws_iam_openid_connect_provider_arn = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/EXAMPLE"
}

run "policy_naming_convention" {
  command = plan

  assert {
    condition     = aws_iam_policy.nullplatform_external_dns_policy.name == "nullplatform-test-cluster-external-dns-policy"
    error_message = "Policy name should follow nullplatform-{cluster}-external-dns-policy convention"
  }
}

run "policy_includes_route53_actions" {
  command = plan

  assert {
    condition     = can(jsondecode(aws_iam_policy.nullplatform_external_dns_policy.policy))
    error_message = "Policy document should be valid JSON"
  }
}

run "policy_references_both_hosted_zones" {
  command = plan

  assert {
    condition     = strcontains(aws_iam_policy.nullplatform_external_dns_policy.policy, "Z1234567890ABC")
    error_message = "Policy should reference public hosted zone ID"
  }

  assert {
    condition     = strcontains(aws_iam_policy.nullplatform_external_dns_policy.policy, "Z0987654321DEF")
    error_message = "Policy should reference private hosted zone ID"
  }
}

run "policy_omits_public_when_only_private_set" {
  command = plan

  variables {
    hosted_zone_public_id  = null
    hosted_zone_private_id = "Z0987654321DEF"
  }

  assert {
    condition     = strcontains(aws_iam_policy.nullplatform_external_dns_policy.policy, "Z0987654321DEF")
    error_message = "Policy should still reference the private hosted zone"
  }

  assert {
    condition     = !strcontains(aws_iam_policy.nullplatform_external_dns_policy.policy, "hostedzone/\"")
    error_message = "Policy must not contain a hostedzone/ entry with an empty ID"
  }
}

run "policy_omits_private_when_only_public_set" {
  command = plan

  variables {
    hosted_zone_public_id  = "Z1234567890ABC"
    hosted_zone_private_id = null
  }

  assert {
    condition     = strcontains(aws_iam_policy.nullplatform_external_dns_policy.policy, "Z1234567890ABC")
    error_message = "Policy should still reference the public hosted zone"
  }

  assert {
    condition     = !strcontains(aws_iam_policy.nullplatform_external_dns_policy.policy, "hostedzone/\"")
    error_message = "Policy must not contain a hostedzone/ entry with an empty ID"
  }
}

run "policy_omits_empty_string_zones" {
  command = plan

  variables {
    hosted_zone_public_id  = ""
    hosted_zone_private_id = "Z0987654321DEF"
  }

  assert {
    condition     = !strcontains(aws_iam_policy.nullplatform_external_dns_policy.policy, "hostedzone/\"")
    error_message = "Empty-string zone IDs must not produce a hostedzone/ entry"
  }
}

run "rejects_when_both_zones_missing" {
  command = plan

  variables {
    hosted_zone_public_id  = null
    hosted_zone_private_id = null
  }

  expect_failures = [var.hosted_zone_public_id]
}

run "rejects_when_both_zones_empty_strings" {
  command = plan

  variables {
    hosted_zone_public_id  = ""
    hosted_zone_private_id = ""
  }

  expect_failures = [var.hosted_zone_public_id]
}

run "irsa_mode_creates_module_and_no_pod_identity_resources" {
  command = plan

  assert {
    condition     = length(module.nullplatform_external_dns_role) == 1
    error_message = "IRSA mode must create exactly one module instance"
  }
  assert {
    condition     = length(aws_iam_role.pod_identity) == 0
    error_message = "IRSA mode must not create a pod_identity IAM role"
  }
  assert {
    condition     = length(aws_eks_pod_identity_association.this) == 0
    error_message = "IRSA mode must not create any Pod Identity associations"
  }
  assert {
    condition     = length(aws_iam_role_policy_attachment.pod_identity) == 0
    error_message = "IRSA mode must not create a pod_identity policy attachment"
  }
  assert {
    condition     = output.nullplatform_external_dns_role_arn != null
    error_message = "IRSA mode must produce a non-null role ARN output"
  }
}
