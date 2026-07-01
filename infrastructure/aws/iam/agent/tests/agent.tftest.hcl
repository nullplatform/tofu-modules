mock_provider "aws" {
  override_data {
    target = data.aws_caller_identity.current
    values = {
      account_id = "123456789012"
    }
  }
  override_data {
    target = module.nullplatform_agent_role.data.aws_iam_policy_document.assume
    values = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Federated\":\"test\"},\"Action\":\"sts:AssumeRoleWithWebIdentity\"}]}"
    }
  }
  override_resource {
    target = aws_iam_policy.nullplatform_assume_role_policy
    values = {
      arn = "arn:aws:iam::123456789012:policy/nullplatform_test-cluster_assume_role_policy"
    }
  }
}

variables {
  cluster_name                        = "test-cluster"
  agent_namespace                     = "nullplatform"
  aws_iam_openid_connect_provider_arn = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/EXAMPLE"
}

run "assume_role_policy_targets_only_provided_arns" {
  command = plan

  variables {
    assume_role_arns = ["arn:aws:iam::123456789012:role/some-role"]
  }

  assert {
    condition     = aws_iam_policy.nullplatform_assume_role_policy.name == "nullplatform_test-cluster_assume_role_policy"
    error_message = "assume_role policy name should follow naming convention"
  }

  assert {
    condition = contains(
      jsondecode(aws_iam_policy.nullplatform_assume_role_policy.policy).Statement[0].Resource,
      "arn:aws:iam::123456789012:role/some-role"
    )
    error_message = "assume_role policy should include the provided assume_role_arns"
  }

  assert {
    condition = !contains(
      jsondecode(aws_iam_policy.nullplatform_assume_role_policy.policy).Statement[0].Resource,
      "arn:aws:iam::123456789012:role/nullplatform-test-cluster-agent-permissions-role"
    )
    error_message = "assume_role policy must NOT inject the permissions role by convention anymore"
  }
}

run "assume_role_policy_fails_without_any_role" {
  command = plan

  expect_failures = [
    aws_iam_policy.nullplatform_assume_role_policy,
  ]
}

run "extra_permissions_roles_not_created_by_default" {
  command = plan

  variables {
    assume_role_arns = ["arn:aws:iam::123456789012:role/some-role"]
  }

  assert {
    condition     = length(aws_iam_role.extra_permissions) == 0
    error_message = "No extra permissions roles should be created when permissions_roles is empty"
  }
}

run "extra_permissions_roles_created_and_assumable" {
  command = plan

  variables {
    permissions_roles = {
      data = {
        policy_arns = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
      }
      ops = {
        name        = "custom-ops-role"
        policy_arns = ["arn:aws:iam::123456789012:policy/ops-policy"]
      }
    }
  }

  assert {
    condition     = aws_iam_role.extra_permissions["data"].name == "nullplatform-test-cluster-data"
    error_message = "Extra role should default its name to nullplatform-{cluster}-{key}"
  }

  assert {
    condition     = aws_iam_role.extra_permissions["ops"].name == "custom-ops-role"
    error_message = "Extra role should honor the name override"
  }

  assert {
    condition     = jsondecode(aws_iam_role.extra_permissions["data"].assume_role_policy).Statement[0].Principal.AWS == "arn:aws:iam::123456789012:role/nullplatform-test-cluster-agent-role"
    error_message = "Extra role trust policy should allow the agent role to assume it"
  }

  assert {
    condition     = length(aws_iam_role_policy_attachment.extra_permissions) == 2
    error_message = "Each extra role policy_arn should produce one attachment"
  }

  assert {
    condition = contains(
      jsondecode(aws_iam_policy.nullplatform_assume_role_policy.policy).Statement[0].Resource,
      "arn:aws:iam::123456789012:role/nullplatform-test-cluster-data"
    )
    error_message = "agent assume_role policy should include the data extra role"
  }

  assert {
    condition = contains(
      jsondecode(aws_iam_policy.nullplatform_assume_role_policy.policy).Statement[0].Resource,
      "arn:aws:iam::123456789012:role/custom-ops-role"
    )
    error_message = "agent assume_role policy should include the ops extra role"
  }

  assert {
    condition = !contains(
      jsondecode(aws_iam_policy.nullplatform_assume_role_policy.policy).Statement[0].Resource,
      "arn:aws:iam::123456789012:role/nullplatform-test-cluster-agent-permissions-role"
    )
    error_message = "permissions_roles alone must not re-introduce the convention permissions role ARN"
  }
}
