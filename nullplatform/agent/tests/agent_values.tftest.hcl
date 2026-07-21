mock_provider "helm" {}

variables {
  api_key              = "test-api-key"
  cluster_name         = "test-cluster"
  nrn                  = "organization=1:account=2:namespace=3"
  tags_selectors       = { environment = "test" }
  image_tag            = "latest"
  cloud_provider       = "gcp"
  private_gateway_name = ""
  private_domain       = ""
}

############################################
# initContainers
############################################

run "init_containers_omitted_by_default" {
  command = plan

  assert {
    condition     = !strcontains(output.rendered_values, "initContainers:")
    error_message = "initContainers block should be omitted when init_containers is empty"
  }
}

run "init_containers_rendered" {
  command = plan

  variables {
    init_containers = [
      {
        name  = "kubelogin-install"
        image = "busybox:1.36"
        volumeMounts = [
          { name = "kubelogin-bin", mountPath = "/shared" }
        ]
      }
    ]
  }

  assert {
    condition     = strcontains(output.rendered_values, "initContainers:")
    error_message = "initContainers block should be present when init_containers is non-empty"
  }

  assert {
    condition     = strcontains(output.rendered_values, "\"name\": \"kubelogin-install\"")
    error_message = "init container name should be rendered"
  }
}

############################################
# volumes / volumeMounts
############################################

run "volumes_and_volume_mounts_omitted_by_default" {
  command = plan

  assert {
    condition     = !strcontains(output.rendered_values, "\nvolumes:")
    error_message = "volumes block should be omitted when volumes is empty"
  }

  assert {
    condition     = !strcontains(output.rendered_values, "volumeMounts:")
    error_message = "volumeMounts block should be omitted when volume_mounts is empty"
  }
}

run "volumes_and_volume_mounts_rendered" {
  command = plan

  variables {
    volumes = [
      { name = "kubelogin-bin", emptyDir = {} }
    ]
    volume_mounts = [
      { name = "kubelogin-bin", mountPath = "/usr/local/bin/kubelogin", subPath = "kubelogin" }
    ]
  }

  assert {
    condition     = strcontains(output.rendered_values, "\nvolumes:")
    error_message = "volumes block should be present when volumes is non-empty"
  }

  assert {
    condition     = strcontains(output.rendered_values, "volumeMounts:")
    error_message = "volumeMounts block should be present when volume_mounts is non-empty"
  }

  assert {
    condition     = strcontains(output.rendered_values, "\"mountPath\": \"/usr/local/bin/kubelogin\"")
    error_message = "volume mount path should be rendered"
  }
}
