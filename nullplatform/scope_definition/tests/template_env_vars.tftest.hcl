mock_provider "nullplatform" {}

# Templates are rendered by the real gomplate through data.external; only the
# HTTP fetches are replaced.
override_data {
  target = data.http.service_spec_template
  values = {
    status_code   = 200
    response_body = <<-EOT
      {
        "visible_to": [],
        "assignable_to": "any",
        "type": "scope",
        "attributes": {
          "nrn": "{{ env.Getenv "NRN" }}",
          "custom": "{{ env.Getenv "CUSTOM_FLAG" "unset" }}",
          "other": "{{ env.Getenv "OTHER_FLAG" "unset" }}"
        },
        "use_default_actions": false,
        "selectors": {"category": "Scope", "imported": false, "provider": "Agent", "sub_category": "Custom"},
        "available_actions": ["create-scope"]
      }
    EOT
  }
}

override_data {
  target = data.http.scope_type_template
  values = {
    status_code   = 200
    response_body = <<-EOT
      {"provider_type": "service", "flag": "{{ env.Getenv "CUSTOM_FLAG" "unset" }}"}
    EOT
  }
}

override_data {
  target = data.http.action_templates
  values = {
    status_code   = 200
    response_body = <<-EOT
      {"name": "{{ env.Getenv "CUSTOM_FLAG" "unset" }}", "type": "custom", "parameters": {}, "results": {}}
    EOT
  }
}

variables {
  nrn        = "organization=1:account=2"
  np_api_key = "test"
}

# Semantic check only: with {} the assignments string is empty, so the shell
# command is the same as without the variable.
run "default_render_is_unchanged" {
  command = plan

  assert {
    condition     = local.service_spec_parsed.attributes.nrn == "organization=1:account=2"
    error_message = "NRN must still be exported to the template"
  }

  assert {
    condition     = local.service_spec_parsed.attributes.custom == "unset"
    error_message = "Without template_env_vars no extra variable may reach the template"
  }
}

run "extra_var_reaches_service_spec" {
  command = plan

  variables {
    template_env_vars = { CUSTOM_FLAG = "zip,docker-image" }
  }

  assert {
    condition     = local.service_spec_parsed.attributes.custom == "zip,docker-image"
    error_message = "template_env_vars must reach the service spec render"
  }

  assert {
    condition     = local.service_spec_parsed.attributes.nrn == "organization=1:account=2"
    error_message = "NRN must still be exported alongside template_env_vars"
  }
}

run "extra_var_reaches_scope_type_and_actions" {
  command = plan

  variables {
    template_env_vars = { CUSTOM_FLAG = "zip" }
  }

  assert {
    condition     = jsondecode(data.external.scope_type[0].result.json).flag == "zip"
    error_message = "template_env_vars must reach the scope type render"
  }

  assert {
    condition     = jsondecode(base64decode(data.external.action_specs["create-scope"].result.json_b64)).name == "zip"
    error_message = "template_env_vars must reach the action spec renders"
  }
}

run "multiple_keys_with_shell_characters_render_verbatim" {
  command = plan

  variables {
    template_env_vars = {
      CUSTOM_FLAG = "a b $HOME `id` $(id) ; |"
      OTHER_FLAG  = "second"
    }
  }

  assert {
    condition     = local.service_spec_parsed.attributes.custom == "a b $HOME `id` $(id) ; |"
    error_message = "Values must reach the template verbatim, without shell expansion"
  }

  assert {
    condition     = local.service_spec_parsed.attributes.other == "second"
    error_message = "Every key of template_env_vars must reach the template"
  }
}

run "rejects_invalid_key" {
  command = plan

  variables {
    template_env_vars = { "bad-key" = "x" }
  }

  expect_failures = [var.template_env_vars]
}

run "rejects_lowercase_key" {
  command = plan

  variables {
    template_env_vars = { custom_flag = "x" }
  }

  expect_failures = [var.template_env_vars]
}

run "rejects_nrn_override" {
  command = plan

  variables {
    template_env_vars = { NRN = "organization=9" }
  }

  expect_failures = [var.template_env_vars]
}

run "rejects_value_with_single_quote" {
  command = plan

  variables {
    template_env_vars = { CUSTOM_FLAG = "it's" }
  }

  expect_failures = [var.template_env_vars]
}

run "rejects_module_builtin_key" {
  command = plan

  variables {
    template_env_vars = { SERVICE_SLUG = "x" }
  }

  expect_failures = [var.template_env_vars]
}

run "rejects_process_env_key" {
  command = plan

  variables {
    template_env_vars = { GOMPLATE_LEFT_DELIM = "<<" }
  }

  expect_failures = [var.template_env_vars]
}
