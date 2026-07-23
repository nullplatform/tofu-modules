locals {
  # GitHub: raw content URL base (includes service_path)
  raw_base_url = "https://raw.githubusercontent.com/${var.repository_org}/${var.repository_name}/refs/heads/${var.repository_branch}/${var.service_path}"

  # GitLab: API v4 file endpoint avoids Cloudflare bot-protection on /-/raw/ URLs.
  # Both the project path and service_path must be URL-encoded (/ → %2F).
  _gitlab_project_encoded      = replace("${var.repository_org}/${var.repository_name}", "/", "%2F")
  _gitlab_service_path_encoded = replace(var.service_path, "/", "%2F")
  gitlab_api_file_prefix       = "https://${var.gitlab_host}/api/v4/projects/${local._gitlab_project_encoded}/repository/files/${local._gitlab_service_path_encoded}"
  # Separator between service_path and the specs/ segment: omitted when service_path is empty
  # to avoid a leading %2F that causes GitLab API to return a 404.
  gitlab_path_sep = var.service_path != "" ? "%2F" : ""

  # Bitbucket Cloud: the canonical repository URL (Contract A: no .git, no trailing slash),
  # then the raw file endpoint underneath it. The service_path segment is appended only when
  # set, to avoid a double slash that Bitbucket's raw endpoint rejects.
  bitbucket_repo_url   = "https://bitbucket.org/${var.repository_org}/${var.repository_name}"
  bitbucket_raw_prefix = "${local.bitbucket_repo_url}/raw/${var.repository_branch}${var.service_path != "" ? "/${var.service_path}" : ""}"

  # Auth header per provider, enumerated explicitly rather than relying on a positional
  # fallback:
  #   - GitLab: PRIVATE-TOKEN header.
  #   - Bitbucket: HTTP Basic "email:api_token" when bitbucket_email is set. Atlassian API
  #     tokens (the program's standard bot-user credential) authenticate ONLY via Basic and
  #     return 401 on Bearer. When bitbucket_email is null the token is treated as a Bitbucket
  #     workspace/repository access token and sent as Bearer.
  #   - GitHub (and any other): Bearer token header.
  auth_headers = (
    var.repository_token == null ? {} :
    var.git_provider == "gitlab" ? { PRIVATE-TOKEN = var.repository_token } :
    var.git_provider == "bitbucket" ? (
      var.bitbucket_email != null
      ? { Authorization = "Basic ${base64encode("${var.bitbucket_email}:${var.repository_token}")}" }
      : { Authorization = "Bearer ${var.repository_token}" }
    ) :
    { Authorization = "Bearer ${var.repository_token}" }
  )
}

locals {
  # Parse specs from local filesystem or HTTP depending on git_provider
  service_spec_parsed = var.git_provider == "local" ? (
    jsondecode(file("${var.local_specs_path}/specs/service-spec.json.tpl"))
    ) : (
    jsondecode(data.http.service_spec_template[0].response_body)
  )

  available_actions = var.available_actions
  available_links   = var.available_links
  visible_to_nrns   = concat([var.nrn], var.extra_visibile_to_nrns)
}

locals {
  link_specs_parsed = {
    for name in local.available_links :
    name => var.git_provider == "local" ? (
      jsondecode(file("${var.local_specs_path}/specs/links/${name}.json.tpl"))
      ) : (
      jsondecode(data.http.link_templates[name].response_body)
    )
  }
}

locals {
  action_specs_parsed = {
    for name in local.available_actions :
    name => var.git_provider == "local" ? (
      jsondecode(file("${var.local_specs_path}/specs/actions/${name}.json.tpl"))
      ) : (
      jsondecode(data.http.action_templates[name].response_body)
    )
  }
}

locals {
  service_specification_id = nullplatform_service_specification.from_template.id
  service_slug             = nullplatform_service_specification.from_template.slug
}
