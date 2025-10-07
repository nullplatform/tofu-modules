# Fetch service specification template
data "http" "service_spec_template" {
  url = "${local.full_git_repo_url}/${var.git_scope_path}/specs/service-spec.json${var.use_tpl_files ? ".tpl" : ""}"
}
# Fetch action specification templates
data "http" "action_templates" {
  for_each = toset(local.available_actions)
  url      = "${local.full_git_repo_url}/${var.git_scope_path}/specs/actions/${each.key}.json${var.use_tpl_files ? ".tpl" : ""}"
}