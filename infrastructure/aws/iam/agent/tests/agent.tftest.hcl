mock_provider "aws" {
  override_data {
    target = data.aws_region.current
    values = {
      region = "us-east-1"
    }
  }
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
    target = aws_iam_policy.nullplatform_route53_policy
    values = {
      arn = "arn:aws:iam::123456789012:policy/nullplatform_test-cluster_route53_policy"
    }
  }
  override_resource {
    target = aws_iam_policy.nullplatform_elb_policy
    values = {
      arn = "arn:aws:iam::123456789012:policy/nullplatform_test-cluster_elb_policy"
    }
  }
  override_resource {
    target = aws_iam_policy.nullplatform_eks_policy
    values = {
      arn = "arn:aws:iam::123456789012:policy/nullplatform_test-cluster_eks_policy"
    }
  }
  override_resource {
    target = aws_iam_policy.nullplatform_avp_policy
    values = {
      arn = "arn:aws:iam::123456789012:policy/nullplatform_test-cluster_avp_policy"
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

run "route53_policy_naming" {
  command = plan

  assert {
    condition     = aws_iam_policy.nullplatform_route53_policy.name == "nullplatform_test-cluster_route53_policy"
    error_message = "Route53 policy name should follow naming convention"
  }
}

run "elb_policy_naming" {
  command = plan

  assert {
    condition     = aws_iam_policy.nullplatform_elb_policy.name == "nullplatform_test-cluster_elb_policy"
    error_message = "ELB policy name should follow naming convention"
  }
}

run "eks_policy_naming" {
  command = plan

  assert {
    condition     = aws_iam_policy.nullplatform_eks_policy.name == "nullplatform_test-cluster_eks_policy"
    error_message = "EKS policy name should follow naming convention"
  }
}

run "avp_policy_naming" {
  command = plan

  assert {
    condition     = aws_iam_policy.nullplatform_avp_policy.name == "nullplatform_test-cluster_avp_policy"
    error_message = "AVP policy name should follow naming convention"
  }
}

run "all_policies_valid_json" {
  command = plan

  assert {
    condition     = can(jsondecode(aws_iam_policy.nullplatform_route53_policy.policy))
    error_message = "Route53 policy should be valid JSON"
  }

  assert {
    condition     = can(jsondecode(aws_iam_policy.nullplatform_elb_policy.policy))
    error_message = "ELB policy should be valid JSON"
  }

  assert {
    condition     = can(jsondecode(aws_iam_policy.nullplatform_eks_policy.policy))
    error_message = "EKS policy should be valid JSON"
  }

  assert {
    condition     = can(jsondecode(aws_iam_policy.nullplatform_avp_policy.policy))
    error_message = "AVP policy should be valid JSON"
  }
}

run "permissions_role_naming" {
  command = plan

  assert {
    condition     = aws_iam_role.nullplatform_agent_permissions.name == "nullplatform-test-cluster-agent-permissions-role"
    error_message = "Permissions role name should follow naming convention"
  }
}

run "permissions_role_trusts_agent_role" {
  command = plan

  assert {
    condition = jsondecode(aws_iam_role.nullplatform_agent_permissions.assume_role_policy).Statement[0].Principal.AWS == "arn:aws:iam::123456789012:role/nullplatform-test-cluster-agent-role"
    error_message = "Permissions role trust policy should allow the agent role to assume it"
  }
}

run "permissions_role_has_workload_policies_attached" {
  command = plan

  assert {
    condition     = aws_iam_role_policy_attachment.permissions_route53.policy_arn == aws_iam_policy.nullplatform_route53_policy.arn
    error_message = "Route53 policy should be attached to the permissions role"
  }

  assert {
    condition     = aws_iam_role_policy_attachment.permissions_eks.policy_arn == aws_iam_policy.nullplatform_eks_policy.arn
    error_message = "EKS policy should be attached to the permissions role"
  }

  assert {
    condition     = aws_iam_role_policy_attachment.permissions_elb.policy_arn == aws_iam_policy.nullplatform_elb_policy.arn
    error_message = "ELB policy should be attached to the permissions role"
  }

  assert {
    condition     = aws_iam_role_policy_attachment.permissions_avp.policy_arn == aws_iam_policy.nullplatform_avp_policy.arn
    error_message = "AVP policy should be attached to the permissions role"
  }

  assert {
    condition     = aws_iam_role_policy_attachment.permissions_route53.role == aws_iam_role.nullplatform_agent_permissions.name
    error_message = "Attachments should target the permissions role"
  }
}

run "assume_role_policy_always_created_and_targets_permissions_role" {
  command = plan

  assert {
    condition     = aws_iam_policy.nullplatform_assume_role_policy.name == "nullplatform_test-cluster_assume_role_policy"
    error_message = "assume_role policy name should follow naming convention"
  }

  assert {
    condition = contains(
      jsondecode(aws_iam_policy.nullplatform_assume_role_policy.policy).Statement[0].Resource,
      "arn:aws:iam::123456789012:role/nullplatform-test-cluster-agent-permissions-role"
    )
    error_message = "assume_role policy should allow assuming the permissions role by default"
  }
}

run "assume_role_policy_includes_additional_arns" {
  command = plan

  variables {
    assume_role_arns = ["arn:aws:iam::123456789012:role/some-role"]
  }

  assert {
    condition = contains(
      jsondecode(aws_iam_policy.nullplatform_assume_role_policy.policy).Statement[0].Resource,
      "arn:aws:iam::123456789012:role/nullplatform-test-cluster-agent-permissions-role"
    )
    error_message = "assume_role policy should still allow assuming the permissions role"
  }

  assert {
    condition = contains(
      jsondecode(aws_iam_policy.nullplatform_assume_role_policy.policy).Statement[0].Resource,
      "arn:aws:iam::123456789012:role/some-role"
    )
    error_message = "assume_role policy should include additional assume_role_arns"
  }
}

run "extra_permissions_roles_not_created_by_default" {
  command = plan

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
    condition = jsondecode(aws_iam_role.extra_permissions["data"].assume_role_policy).Statement[0].Principal.AWS == "arn:aws:iam::123456789012:role/nullplatform-test-cluster-agent-role"
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
}
