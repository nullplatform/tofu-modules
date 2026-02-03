mock_provider "nullplatform" {}

variables {
  nrn          = "organization=myorg:account=myaccount"
  np_api_key   = "test-api-key"
  login_server = "myregistry.azurecr.io"
  path         = "myregistry.azurecr.io/myrepo"
  password     = "test-password"
}

run "docker_server_provider_type" {
  command = plan

  assert {
    condition     = nullplatform_provider_config.docker_server.type == "docker-server"
    error_message = "Provider config type should be 'docker-server'"
  }

  assert {
    condition     = nullplatform_provider_config.docker_server.nrn == "organization=myorg:account=myaccount"
    error_message = "NRN should match input"
  }
}

run "attributes_contain_server" {
  command = plan

  assert {
    condition     = strcontains(nullplatform_provider_config.docker_server.attributes, "myregistry.azurecr.io")
    error_message = "Attributes should contain the login server"
  }
}

run "attributes_contain_path" {
  command = plan

  assert {
    condition     = strcontains(nullplatform_provider_config.docker_server.attributes, "myregistry.azurecr.io/myrepo")
    error_message = "Attributes should contain the path"
  }
}

run "default_username" {
  command = plan

  assert {
    condition     = strcontains(nullplatform_provider_config.docker_server.attributes, "_json_key_base64")
    error_message = "Default username should be '_json_key_base64'"
  }
}

run "custom_username" {
  command = plan

  variables {
    username = "custom-user"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.docker_server.attributes, "custom-user")
    error_message = "Should use custom username"
  }
}
