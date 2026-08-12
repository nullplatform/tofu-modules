mock_provider "nullplatform" {}
mock_provider "helm" {}

variables {
  api_key        = "test-api-key"
  cluster_name   = "test-cluster"
  nrn            = "organization=1:account=2:namespace=3"
  tags_selectors = { environment = "test" }
  image_tag      = "latest"
  # Required by the gcp branch of local.cloud_config regardless of the
  # ingress-template preconditions under test here.
  private_gateway_name = "gateway-private"
}

run "aws_does_not_require_ingress_templates" {
  command = plan

  variables {
    cloud_provider   = "aws"
    aws_iam_role_arn = "arn:aws:iam::123456789012:role/test-role"
  }
}

run "gcp_requires_service_template" {
  command = plan

  variables {
    cloud_provider          = "gcp"
    initial_ingress_path    = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/initial-httproute.yaml.tpl"
    blue_green_ingress_path = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/blue-green-httproute.yaml.tpl"
  }

  expect_failures = [
    terraform_data.cross_variable_validation,
  ]
}

run "gcp_requires_initial_ingress_path" {
  command = plan

  variables {
    cloud_provider          = "gcp"
    service_template        = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/service.yaml.tpl"
    blue_green_ingress_path = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/blue-green-httproute.yaml.tpl"
  }

  expect_failures = [
    terraform_data.cross_variable_validation,
  ]
}

run "gcp_requires_blue_green_ingress_path" {
  command = plan

  variables {
    cloud_provider       = "gcp"
    service_template     = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/service.yaml.tpl"
    initial_ingress_path = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/initial-httproute.yaml.tpl"
  }

  expect_failures = [
    terraform_data.cross_variable_validation,
  ]
}

run "gcp_with_all_ingress_templates_succeeds" {
  command = plan

  variables {
    cloud_provider          = "gcp"
    service_template        = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/service.yaml.tpl"
    initial_ingress_path    = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/initial-httproute.yaml.tpl"
    blue_green_ingress_path = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/blue-green-httproute.yaml.tpl"
  }
}
