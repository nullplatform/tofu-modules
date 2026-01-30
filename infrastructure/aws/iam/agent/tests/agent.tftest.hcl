mock_provider "aws" {
  override_data {
    target = data.aws_region.current
    values = {
      name = "us-east-1"
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
