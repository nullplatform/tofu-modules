mock_provider "aws" {}
mock_provider "helm" {}

variables {
  cluster_name                         = "test-cluster"
  vpc_id                               = "vpc-12345678"
  service_account_name                 = "aws-load-balancer-controller"
  aws_load_balancer_controller_version = "3.6.2"
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

# No default: the version a caller pins is the one deployed (CLIEN-1176)
run "chart_version_reaches_the_release" {
  command = plan

  assert {
    condition     = helm_release.aws_load_balancer_controller.version == "3.6.2"
    error_message = "aws_load_balancer_controller_version must be wired to the helm_release"
  }
}

run "rejects_moving_chart_version" {
  command = plan

  variables {
    aws_load_balancer_controller_version = "latest"
  }

  expect_failures = [var.aws_load_balancer_controller_version]
}
