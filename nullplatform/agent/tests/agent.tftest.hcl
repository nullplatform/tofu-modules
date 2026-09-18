mock_provider "nullplatform" {}
mock_provider "helm" {}

variables {
  api_key                         = "test-api-key"
  tags_selectors                  = { environment = "test" }
  image_tag                       = "latest"
  cloud_provider                  = "gcp"
  nullplatform_agent_helm_version = "2.37.0"
  agent_traffic_manager_tag       = "1.8.0"
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

# The three precondition checks that used to require service_template /
# initial_ingress_path / blue_green_ingress_path whenever
# extra_envs.INGRESS_TYPE == "istio" were removed: that key was never read by
# the k8s scope (see variable "ingress_stack" doc), and ingress_stack now
# derives all three paths on its own — nothing to enforce here anymore.
run "ingress_type_istio_with_all_ingress_templates_succeeds" {
  command = plan

  variables {
    extra_envs              = { INGRESS_TYPE = "istio" }
    service_template        = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/service.yaml.tpl"
    initial_ingress_path    = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/initial-httproute.yaml.tpl"
    blue_green_ingress_path = "/root/.np/nullplatform/scopes/k8s/deployment/templates/istio/blue-green-httproute.yaml.tpl"
  }
}

run "oci_succeeds_with_default_gateway_names" {
  command = plan

  variables {
    cloud_provider = "oci"
  }
}

run "onprem_succeeds_with_no_cloud_specific_config" {
  command = plan

  variables {
    cloud_provider = "onprem"
  }
}

run "worker_orchestrator_defaults_to_off" {
  command = plan

  # No variable set: the module default must leave the chart's worker values
  # alone, which is what installs running scopes inside the agent rely on.
  assert {
    condition     = try(yamldecode(helm_release.agent.values[0]).worker, null) == null
    error_message = "worker orchestration must be off unless worker_orchestrator is set"
  }
}

run "worker_orchestrator_true_still_plans" {
  command = plan

  variables {
    worker_orchestrator = true
  }
}
