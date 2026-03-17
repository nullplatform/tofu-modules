data "http" "service_spec_template" {
  url = var.git_provider == "github" ? (
    "${local.raw_base_url}/specs/service-spec.json.tpl"
  ) : (
    "${local.gitlab_api_file_prefix}%2Fspecs%2Fservice-spec.json.tpl/raw?ref=${var.repository_branch}"
  )
  request_headers = local.auth_headers
}

data "http" "action_templates" {
  for_each = toset(local.available_actions)
  url = var.git_provider == "github" ? (
    "${local.raw_base_url}/specs/actions/${each.key}.json.tpl"
  ) : (
    "${local.gitlab_api_file_prefix}%2Fspecs%2Factions%2F${each.key}.json.tpl/raw?ref=${var.repository_branch}"
  )
  request_headers = local.auth_headers
}

data "http" "link_templates" {
  for_each = toset(local.available_links)
  url = var.git_provider == "github" ? (
    "${local.raw_base_url}/specs/links/${each.key}.json.tpl"
  ) : (
    "${local.gitlab_api_file_prefix}%2Fspecs%2Flinks%2F${each.key}.json.tpl/raw?ref=${var.repository_branch}"
  )
  request_headers = local.auth_headers
}
