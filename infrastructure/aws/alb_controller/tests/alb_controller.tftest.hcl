mock_provider "aws" {}
mock_provider "helm" {}

variables {
  cluster_name         = "test-cluster"
  vpc_id               = "vpc-12345678"
  service_account_name = "aws-load-balancer-controller"
}

run "helm_release_config" {
  command = plan

  assert {
    condition     = helm_release.aws_load_balancer_controller.name == "aws-load-balancer-controller"
    error_message = "Helm release name should be aws-load-balancer-controller"
  }

  assert {
    condition     = helm_release.aws_load_balancer_controller.namespace == "kube-system"
    error_message = "Should deploy to kube-system namespace"
  }

  assert {
    condition     = helm_release.aws_load_balancer_controller.chart == "aws-load-balancer-controller"
    error_message = "Should use the aws-load-balancer-controller chart"
  }

  assert {
    condition     = helm_release.aws_load_balancer_controller.atomic == true
    error_message = "Helm release should be atomic"
  }
}

run "default_chart_version" {
  command = plan

  assert {
    condition     = helm_release.aws_load_balancer_controller.version == "1.13.4"
    error_message = "Default chart version should be 1.13.4"
  }
}
