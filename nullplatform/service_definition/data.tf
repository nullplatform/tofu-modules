data "http" "service_spec_template" {
  count = var.git_provider != "local" ? 1 : 0
  url = (
    var.git_provider == "github" ? "${local.raw_base_url}/specs/service-spec.json.tpl" :
    var.git_provider == "bitbucket" ? "${local.bitbucket_raw_prefix}/specs/service-spec.json.tpl" :
    "${local.gitlab_api_file_prefix}${local.gitlab_path_sep}specs%2Fservice-spec.json.tpl/raw?ref=${var.repository_branch}"
  )
  request_headers = local.auth_headers
}

data "http" "action_templates" {
  for_each = var.git_provider != "local" ? toset(local.available_actions) : toset([])
  url = (
    var.git_provider == "github" ? "${local.raw_base_url}/specs/actions/${each.key}.json.tpl" :
    var.git_provider == "bitbucket" ? "${local.bitbucket_raw_prefix}/specs/actions/${each.key}.json.tpl" :
    "${local.gitlab_api_file_prefix}${local.gitlab_path_sep}specs%2Factions%2F${each.key}.json.tpl/raw?ref=${var.repository_branch}"
  )
  request_headers = local.auth_headers
}

data "http" "link_templates" {
  for_each = var.git_provider != "local" ? toset(local.available_links) : toset([])
  url = (
    var.git_provider == "github" ? "${local.raw_base_url}/specs/links/${each.key}.json.tpl" :
    var.git_provider == "bitbucket" ? "${local.bitbucket_raw_prefix}/specs/links/${each.key}.json.tpl" :
    "${local.gitlab_api_file_prefix}${local.gitlab_path_sep}specs%2Flinks%2F${each.key}.json.tpl/raw?ref=${var.repository_branch}"
  )
  request_headers = local.auth_headers
}
