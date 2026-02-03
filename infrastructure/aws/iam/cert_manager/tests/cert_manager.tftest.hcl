mock_provider "aws" {
  override_data {
    target = module.nullplatform_cert_manager_role.data.aws_iam_policy_document.assume
    values = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Federated\":\"test\"},\"Action\":\"sts:AssumeRoleWithWebIdentity\"}]}"
    }
  }
  override_resource {
    target = aws_iam_policy.nullplatform_cert_manager_policy
    values = {
      arn = "arn:aws:iam::123456789012:policy/nullplatform-test-cluster-cert-manager-policy"
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
    condition     = aws_iam_policy.nullplatform_cert_manager_policy.name == "nullplatform-test-cluster-cert-manager-policy"
    error_message = "Policy name should follow nullplatform-{cluster}-cert-manager-policy convention"
  }
}

run "policy_includes_route53_actions" {
  command = plan

  assert {
    condition     = can(jsondecode(aws_iam_policy.nullplatform_cert_manager_policy.policy))
    error_message = "Policy document should be valid JSON"
  }
}

run "policy_references_both_hosted_zones" {
  command = plan

  assert {
    condition     = strcontains(aws_iam_policy.nullplatform_cert_manager_policy.policy, "Z1234567890ABC")
    error_message = "Policy should reference public hosted zone ID"
  }

  assert {
    condition     = strcontains(aws_iam_policy.nullplatform_cert_manager_policy.policy, "Z0987654321DEF")
    error_message = "Policy should reference private hosted zone ID"
  }
}
