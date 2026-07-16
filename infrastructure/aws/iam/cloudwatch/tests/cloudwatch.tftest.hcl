mock_provider "aws" {
  override_data {
    target = module.nullplatform_cloudwatch_role.data.aws_iam_policy_document.assume
    values = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Federated\":\"test\"},\"Action\":\"sts:AssumeRoleWithWebIdentity\"}]}"
    }
  }
  override_resource {
    target = aws_iam_policy.nullplatform_cloudwatch_policy
    values = {
      arn = "arn:aws:iam::123456789012:policy/nullplatform-test-cluster-cloudwatch-policy"
    }
  }
}

variables {
  cluster_name                        = "test-cluster"
  aws_iam_openid_connect_provider_arn = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/EXAMPLE"
}

run "policy_naming_convention" {
  command = plan

  assert {
    condition     = aws_iam_policy.nullplatform_cloudwatch_policy.name == "nullplatform-test-cluster-cloudwatch-policy"
    error_message = "Policy name should follow nullplatform-{cluster}-cloudwatch-policy convention"
  }
}

run "policy_is_valid_json" {
  command = plan

  assert {
    condition     = can(jsondecode(aws_iam_policy.nullplatform_cloudwatch_policy.policy))
    error_message = "Policy document should be valid JSON"
  }
}

run "policy_includes_cloudwatch_actions" {
  command = plan

  assert {
    condition     = strcontains(aws_iam_policy.nullplatform_cloudwatch_policy.policy, "logs:PutLogEvents")
    error_message = "Policy should allow logs:PutLogEvents"
  }
  assert {
    condition     = strcontains(aws_iam_policy.nullplatform_cloudwatch_policy.policy, "cloudwatch:PutMetricData")
    error_message = "Policy should allow cloudwatch:PutMetricData"
  }
}

run "policy_respects_log_group_scope" {
  command = plan

  variables {
    log_group_arn_patterns = ["arn:aws:logs:us-east-1:123456789012:log-group:/nullplatform/*"]
  }

  assert {
    condition     = strcontains(aws_iam_policy.nullplatform_cloudwatch_policy.policy, "log-group:/nullplatform/*")
    error_message = "Policy should scope log actions to the provided log group ARN patterns"
  }
}

run "irsa_mode_creates_module_and_no_pod_identity_resources" {
  command = plan

  assert {
    condition     = length(module.nullplatform_cloudwatch_role) == 1
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
    condition     = output.nullplatform_cloudwatch_role_arn != null
    error_message = "IRSA mode must produce a non-null role ARN output"
  }
}

run "rejects_irsa_without_oidc_arn" {
  command = plan

  variables {
    aws_iam_openid_connect_provider_arn = null
  }

  expect_failures = [var.aws_iam_openid_connect_provider_arn]
}

run "rejects_invalid_identity_mode" {
  command = plan

  variables {
    identity_mode = "wireguard"
  }

  expect_failures = [var.identity_mode]
}
