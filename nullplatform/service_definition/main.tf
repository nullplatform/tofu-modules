
################################################################################
# Step 1: Fetch Templates
################################################################################

# Fetch service specification template
data "github_repository_file" "service_spec_template" {
  repository = var.git_repo
  branch     = var.git_ref
  file       = "${var.git_service_path}/specs/service-spec.json${var.use_tpl_files ? ".tpl" : ""}"
}

################################################################################
# Step 2: Process Service Specification First (to determine available actions/links)
################################################################################

locals {
  # Process the service spec template first to know what actions/links are available
  # replace is done because some old templates contain gomplate placeholders
  service_spec_rendered = var.use_tpl_files ? replace(
    data.github_repository_file.service_spec_template.content,
    "/\"{{\\s+env.Getenv\\s+\".*\"\\s+}}\"/",
    "\"${var.nrn}\""
  ) : data.github_repository_file.service_spec_template.content
  service_spec_parsed = jsondecode(local.service_spec_rendered)
  available_actions   = try(local.service_spec_parsed.available_actions, [])
  available_links     = try(local.service_spec_parsed.available_links, [])
  has_links           = length(local.available_links) > 0
  visible_to_nrns     = concat([var.nrn], var.extra_visibile_to_nrns)
}

# Fetch link specification template (only if service has links)
data "github_repository_file" "link_spec_template" {
  count      = local.has_links ? 1 : 0
  repository = var.git_repo
  branch     = var.git_ref
  file       = "${var.git_service_path}/specs/link-spec.json${var.use_tpl_files ? ".tpl" : ""}"
}

# Fetch action specification templates
data "github_repository_file" "action_templates" {
  for_each   = toset(local.available_actions)
  repository = var.git_repo
  branch     = var.git_ref
  file       = "${var.git_service_path}/specs/actions/${each.key}.json${var.use_tpl_files ? ".tpl" : ""}"
}

# Fetch link specification templates (only if service has links)
data "github_repository_file" "link_templates" {
  for_each   = toset(local.available_links)
  repository = var.git_repo
  branch     = var.git_ref
  file       = "${var.git_service_path}/specs/links/${each.key}.json${var.use_tpl_files ? ".tpl" : ""}"
}

################################################################################
# Step 3: Process Link Specification (if applicable)
################################################################################

locals {
  # Process link spec template only if service has links
  link_spec_rendered = local.has_links ? (var.use_tpl_files ? replace(
    data.github_repository_file.link_spec_template[0].content,
    "/\"{{\\s+env.Getenv\\s+\".*\"\\s+}}\"/",
    "\"${var.nrn}\""
  ) : data.github_repository_file.link_spec_template[0].content) : "{}"
  link_spec_parsed = local.has_links ? jsondecode(local.link_spec_rendered) : {}
}

# Create service specification
resource "nullplatform_service_specification" "from_template" {
  name                = var.service_name
  visible_to          = local.visible_to_nrns
  type                = local.service_spec_parsed.type
  attributes          = jsonencode(local.service_spec_parsed.attributes)
  use_default_actions = local.service_spec_parsed.use_default_actions

  selectors {
    category     = local.service_spec_parsed.selectors.category
    imported     = local.service_spec_parsed.selectors.imported
    provider     = local.service_spec_parsed.selectors.provider
    sub_category = local.service_spec_parsed.selectors.sub_category
  }
  dimensions = jsonencode(var.dimensions)
}

locals {
  # Variables that depend on created service specification
  service_specification_id = nullplatform_service_specification.from_template.id
  service_slug             = nullplatform_service_specification.from_template.slug

  dependent_env_vars = {
    NRN                      = var.nrn
    SERVICE_SPECIFICATION_ID = local.service_specification_id
    SERVICE_SLUG             = local.service_slug
  }
}

################################################################################
# Process action templates - conditional processing based on file type
# replace is done because some old templates contain gomplate placeholders
locals {
  action_specs_parsed = {
    for name in local.available_actions :
    name => jsondecode(var.use_tpl_files ? replace(
      data.github_repository_file.action_templates[name].content,
      "/\"{{\\s+env.Getenv\\s+\".*\"\\s+}}\"/",
      "\"\""
    ) : data.github_repository_file.action_templates[name].content)
  }
}

# Create action specifications
resource "nullplatform_action_specification" "from_templates" {
  for_each   = toset(local.available_actions)
  depends_on = [nullplatform_service_specification.from_template]

  service_specification_id = local.service_specification_id
  name                     = local.action_specs_parsed[each.key].name
  type                     = local.action_specs_parsed[each.key].type
  parameters               = jsonencode(local.action_specs_parsed[each.key].parameters)
  results                  = jsonencode(local.action_specs_parsed[each.key].results)
  retryable                = try(local.action_specs_parsed[each.key].retryable, false)
  annotations              = try(jsonencode(local.action_specs_parsed[each.key].annotations), null)
}


locals {
  link_specs_parsed = {
    for name in local.available_links :
    name => jsondecode(var.use_tpl_files ? replace(
      data.github_repository_file.link_templates[name].content,
      "/\"{{\\s+env.Getenv\\s+\".*\"\\s+}}\"/",
      "\"\""
    ) : data.github_repository_file.link_templates[name].content)
  }
}

# Create link specification from link-spec template (only if service has links)
resource "nullplatform_link_specification" "service_link_from_template" {
  count      = local.has_links ? 1 : 0
  depends_on = [nullplatform_service_specification.from_template]

  name                = local.link_spec_parsed.name
  unique              = try(local.link_spec_parsed.unique, false)
  specification_id    = local.service_specification_id
  attributes          = jsonencode(local.link_spec_parsed.attributes)
  use_default_actions = try(local.link_spec_parsed.use_default_actions, true)
  selectors {
    category     = try(local.link_spec_parsed.selectors.category, local.service_spec_parsed.selectors.category)
    imported     = try(local.link_spec_parsed.selectors.imported, local.service_spec_parsed.selectors.imported)
    provider     = try(local.link_spec_parsed.selectors.provider, local.service_spec_parsed.selectors.provider)
    sub_category = try(local.link_spec_parsed.selectors.sub_category, local.service_spec_parsed.selectors.sub_category)
  }
}

resource "nullplatform_link_specification" "service_link_from_templates" {
  for_each   = toset(local.available_links)
  depends_on = [nullplatform_service_specification.from_template]

  name                = local.link_specs_parsed[each.key].name
  unique              = try(local.link_specs_parsed[each.key].unique, false)
  specification_id    = local.service_specification_id
  attributes          = jsonencode(local.link_specs_parsed[each.key].attributes)
  use_default_actions = try(local.link_specs_parsed[each.key].use_default_actions, true)
  selectors {
    category     = local.service_spec_parsed.selectors.category
    imported     = local.service_spec_parsed.selectors.imported
    provider     = local.service_spec_parsed.selectors.provider
    sub_category = local.service_spec_parsed.selectors.sub_category
  }
}
