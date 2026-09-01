mock_provider "nullplatform" {}
mock_provider "helm" {}

variables {
  api_key                         = "test-api-key"
  tags_selectors                  = { environment = "test" }
  image_tag                       = "latest"
  cloud_provider                  = "gcp"
  nullplatform_agent_helm_version = "2.37.0"
  agent_traffic_manager_tag       = "1.8.0"
  agent_repos_scope_tag           = "v1.15.1"
}

run "no_extra_envs_does_not_require_ingress_templates" {
  command = plan
}

run "ingress_type_not_istio_does_not_require_ingress_templates" {
  command = plan

  variables {
    extra_envs = { INGRESS_TYPE = "nginx" }
  }
}

run "ingress_type_istio_requires_service_template" {
  command = plan

  variables {
    extra_envs              = { INGRESS_TYPE = "istio" }
    initial_ingress_path    = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/initial-httproute.yaml.tpl"
    blue_green_ingress_path = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/blue-green-httproute.yaml.tpl"
  }

  expect_failures = [
    terraform_data.cross_variable_validation,
  ]
}

run "ingress_type_istio_requires_initial_ingress_path" {
  command = plan

  variables {
    extra_envs              = { INGRESS_TYPE = "istio" }
    service_template        = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/service.yaml.tpl"
    blue_green_ingress_path = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/blue-green-httproute.yaml.tpl"
  }

  expect_failures = [
    terraform_data.cross_variable_validation,
  ]
}

run "ingress_type_istio_requires_blue_green_ingress_path" {
  command = plan

  variables {
    extra_envs           = { INGRESS_TYPE = "istio" }
    service_template     = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/service.yaml.tpl"
    initial_ingress_path = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/initial-httproute.yaml.tpl"
  }

  expect_failures = [
    terraform_data.cross_variable_validation,
  ]
}

run "ingress_type_istio_with_all_ingress_templates_succeeds" {
  command = plan

  variables {
    extra_envs              = { INGRESS_TYPE = "istio" }
    service_template        = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/service.yaml.tpl"
    initial_ingress_path    = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/initial-httproute.yaml.tpl"
    blue_green_ingress_path = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/blue-green-httproute.yaml.tpl"
  }
}

run "aws_with_ingress_type_istio_still_requires_ingress_templates" {
  command = plan

  variables {
    cloud_provider   = "aws"
    aws_iam_role_arn = "arn:aws:iam::123456789012:role/test-role"
    extra_envs       = { INGRESS_TYPE = "istio" }
  }

  expect_failures = [
    terraform_data.cross_variable_validation,
  ]
}

run "oci_succeeds_with_default_gateway_names" {
  command = plan

  variables {
    cloud_provider = "oci"
  }
}
