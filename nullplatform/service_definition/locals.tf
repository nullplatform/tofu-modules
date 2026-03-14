locals {
  raw_base_url = var.git_provider == "github" ? (
    "https://raw.githubusercontent.com/${var.repository_org}/${var.repository_name}/refs/heads/${var.repository_branch}/${var.service_path}"
  ) : (
    "https://${var.gitlab_host}/${var.repository_org}/${var.repository_name}/-/raw/${var.repository_branch}/${var.service_path}"
  )

  auth_headers = var.repository_token == null ? {} : (
    var.git_provider == "github" ? (
      { Authorization = "Bearer ${var.repository_token}" }
    ) : (
      { PRIVATE-TOKEN = var.repository_token }
    )
  )
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
