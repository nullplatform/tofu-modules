################################################################################
# Template Fetching
#
# A non-2xx response is NOT an error for the http provider, so without the
# postconditions below the response body (e.g. `404: Not Found`) flows on as if
# it were the template and fails much later while rendering, far from the file
# that is actually missing. On private repositories a 401/403/404 here usually
# means the token in `auth_headers` or `repository_branch` is wrong, not that
# the template is gone.
################################################################################
data "http" "service_spec_template" {
  count = var.git_provider != "local" ? 1 : 0
  url = (
    var.git_provider == "github" ? "${local.raw_base_url}/specs/service-spec.json.tpl" :
    var.git_provider == "bitbucket" ? "${local.bitbucket_raw_prefix}/specs/service-spec.json.tpl" :
    "${local.gitlab_api_file_prefix}${local.gitlab_path_sep}specs%2Fservice-spec.json.tpl/raw?ref=${var.repository_branch}"
  )
  request_headers = local.auth_headers

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Fetch of ${self.url} returned HTTP ${self.status_code}, expected 200."
    }
  }
}

data "http" "action_templates" {
  for_each = var.git_provider != "local" ? toset(local.available_actions) : toset([])
  url = (
    var.git_provider == "github" ? "${local.raw_base_url}/specs/actions/${each.key}.json.tpl" :
    var.git_provider == "bitbucket" ? "${local.bitbucket_raw_prefix}/specs/actions/${each.key}.json.tpl" :
    "${local.gitlab_api_file_prefix}${local.gitlab_path_sep}specs%2Factions%2F${each.key}.json.tpl/raw?ref=${var.repository_branch}"
  )
  request_headers = local.auth_headers

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Fetch of ${self.url} returned HTTP ${self.status_code}, expected 200. Check that the action name is spelled as the template file in the service repository."
    }
  }
}

data "http" "link_templates" {
  for_each = var.git_provider != "local" ? toset(local.available_links) : toset([])
  url = (
    var.git_provider == "github" ? "${local.raw_base_url}/specs/links/${each.key}.json.tpl" :
    var.git_provider == "bitbucket" ? "${local.bitbucket_raw_prefix}/specs/links/${each.key}.json.tpl" :
    "${local.gitlab_api_file_prefix}${local.gitlab_path_sep}specs%2Flinks%2F${each.key}.json.tpl/raw?ref=${var.repository_branch}"
  )
  request_headers = local.auth_headers

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Fetch of ${self.url} returned HTTP ${self.status_code}, expected 200. Check that the link name is spelled as the template file in the service repository."
    }
  }
}
