mock_provider "aws" {
  override_data {
    target = module.aws_load_balancer_controller_role.data.aws_iam_policy_document.assume
    values = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Federated\":\"test\"},\"Action\":\"sts:AssumeRoleWithWebIdentity\"}]}"
    }
  }
  override_resource {
    target = aws_iam_policy.lb_controller
    values = {
      arn = "arn:aws:iam::123456789012:policy/AWSLoadBalancerControllerPolicy-test-cluster"
    }
  }
}
mock_provider "kubernetes" {}

variables {
  cluster_name                        = "test-cluster"
  aws_iam_openid_connect_provider_arn = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/EXAMPLE"
}

run "iam_policy_naming" {
  command = plan

  assert {
    condition     = aws_iam_policy.lb_controller.name == "AWSLoadBalancerControllerPolicy-test-cluster"
    error_message = "IAM policy name should include cluster name"
  }
}

run "service_account_config" {
  command = plan

  assert {
    condition     = kubernetes_service_account_v1.aws_load_balancer_controller_sa.metadata[0].name == "aws-load-balancer-controller"
    error_message = "Service account name should be aws-load-balancer-controller"
  }

  assert {
    condition     = kubernetes_service_account_v1.aws_load_balancer_controller_sa.metadata[0].namespace == "kube-system"
    error_message = "Service account should be in kube-system namespace"
  }
}
