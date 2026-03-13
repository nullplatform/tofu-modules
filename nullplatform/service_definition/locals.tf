locals {
  raw_base_url = "https://raw.githubusercontent.com/${var.repository_service_spec_org}/${var.repository_service_spec_repo}/refs/heads/${var.repository_service_spec_branch}/${var.service_path}"
  auth_headers = var.github_token != null ? { Authorization = "Bearer ${var.github_token}" } : {}
}

locals {
  link_specs_parsed = {
    for name in local.available_links :
    name => jsondecode(data.http.link_templates[name].response_body)
  }
}

locals {
  action_specs_parsed = {
    for name in local.available_actions :
    name => jsondecode(data.http.action_templates[name].response_body)
  }
}

locals {
  service_specification_id = nullplatform_service_specification.from_template.id
  service_slug             = nullplatform_service_specification.from_template.slug
}

locals {
  service_spec_parsed = jsondecode(data.http.service_spec_template.response_body)
  available_actions   = var.available_actions
  available_links     = var.available_links
  visible_to_nrns     = concat([var.nrn], var.extra_visibile_to_nrns)
}
