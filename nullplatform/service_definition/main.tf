
################################################################################
# Locals: Git provider selection
################################################################################

locals {
  is_github = var.git_provider == "github"
  is_gitlab = var.git_provider == "gitlab"

  service_spec_file = "${var.git_service_path}/specs/service-spec.json${var.use_tpl_files ? ".tpl" : ""}"
}

################################################################################
# Step 1: Fetch Templates
################################################################################

# GitHub: Fetch service specification template
data "github_repository_file" "service_spec_template" {
  count      = local.is_github ? 1 : 0
  repository = var.git_repo
  branch     = var.git_ref
  file       = local.service_spec_file
}

# GitLab: Fetch service specification template
data "gitlab_repository_file" "service_spec_template" {
  count     = local.is_gitlab ? 1 : 0
  project   = var.git_repo
  ref       = var.git_ref
  file_path = local.service_spec_file
}

################################################################################
# Step 2: Process Service Specification First (to determine available actions/links)
################################################################################

locals {
  # Unify content from either provider (GitLab returns base64-encoded content)
  service_spec_raw = (
    local.is_github
    ? data.github_repository_file.service_spec_template[0].content
    : base64decode(data.gitlab_repository_file.service_spec_template[0].content)
  )

  # Process the service spec template first to know what actions/links are available
  # replace is done because some old templates contain gomplate placeholders
  service_spec_rendered = var.use_tpl_files ? replace(
    local.service_spec_raw,
    "/\"{{\\s+env.Getenv\\s+\".*\"\\s+}}\"/",
    "\"${var.nrn}\""
  ) : local.service_spec_raw
  service_spec_parsed = jsondecode(local.service_spec_rendered)
  available_actions   = try(local.service_spec_parsed.available_actions, [])
  available_links     = try(local.service_spec_parsed.available_links, [])
  visible_to_nrns     = concat([var.nrn], var.extra_visibile_to_nrns)
}

# GitHub: Fetch action specification templates
data "github_repository_file" "action_templates" {
  for_each   = local.is_github ? toset(local.available_actions) : toset([])
  repository = var.git_repo
  branch     = var.git_ref
  file       = "${var.git_service_path}/specs/actions/${each.key}.json${var.use_tpl_files ? ".tpl" : ""}"
}

# GitLab: Fetch action specification templates
data "gitlab_repository_file" "action_templates" {
  for_each  = local.is_gitlab ? toset(local.available_actions) : toset([])
  project   = var.git_repo
  ref       = var.git_ref
  file_path = "${var.git_service_path}/specs/actions/${each.key}.json${var.use_tpl_files ? ".tpl" : ""}"
}

# GitHub: Fetch link specification templates
data "github_repository_file" "link_templates" {
  for_each   = local.is_github ? toset(local.available_links) : toset([])
  repository = var.git_repo
  branch     = var.git_ref
  file       = "${var.git_service_path}/specs/links/${each.key}.json${var.use_tpl_files ? ".tpl" : ""}"
}

# GitLab: Fetch link specification templates
data "gitlab_repository_file" "link_templates" {
  for_each  = local.is_gitlab ? toset(local.available_links) : toset([])
  project   = var.git_repo
  ref       = var.git_ref
  file_path = "${var.git_service_path}/specs/links/${each.key}.json${var.use_tpl_files ? ".tpl" : ""}"
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
  # Unify action template content from either provider
  action_template_contents = {
    for name in local.available_actions :
    name => (
      local.is_github
      ? data.github_repository_file.action_templates[name].content
      : base64decode(data.gitlab_repository_file.action_templates[name].content)
    )
  }

  action_specs_parsed = {
    for name in local.available_actions :
    name => jsondecode(var.use_tpl_files ? replace(
      local.action_template_contents[name],
      "/\"{{\\s+env.Getenv\\s+\".*\"\\s+}}\"/",
      "\"\""
    ) : local.action_template_contents[name])
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
  # Unify link template content from either provider
  link_template_contents = {
    for name in local.available_links :
    name => (
      local.is_github
      ? data.github_repository_file.link_templates[name].content
      : base64decode(data.gitlab_repository_file.link_templates[name].content)
    )
  }

  link_specs_parsed = {
    for name in local.available_links :
    name => jsondecode(var.use_tpl_files ? replace(
      local.link_template_contents[name],
      "/\"{{\\s+env.Getenv\\s+\".*\"\\s+}}\"/",
      "\"\""
    ) : local.link_template_contents[name])
  }
}

# Create link specifications from links/ directory (based on available_links in service-spec)
resource "nullplatform_link_specification" "from_templates" {
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
