data "http" "service_spec_template" {
  url = "${local.raw_base_url}/specs/service-spec.json.tpl"
}

data "http" "action_templates" {
  for_each = toset(local.available_actions)
  url      = "${local.raw_base_url}/specs/actions/${each.key}.json.tpl"
}

data "http" "link_templates" {
  for_each = toset(local.available_links)
  url      = "${local.raw_base_url}/specs/links/${each.key}.json.tpl"
}
