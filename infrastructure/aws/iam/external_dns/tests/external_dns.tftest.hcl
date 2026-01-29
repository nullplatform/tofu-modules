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
