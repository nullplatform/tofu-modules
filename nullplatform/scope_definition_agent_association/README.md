# Module: scope_definition_agent_association

## Description

Creates a nullplatform notification channel by fetching and processing a JSON template from a remote repository and registering it with the nullplatform API

## Architecture

The module fetches a notification channel template via the `http` data source from a configurable GitHub raw URL, then processes it through an `external` data source using `gomplate` for variable substitution and `jq` for JSON normalization. The processed template drives a `nullplatform_notification_channel` resource, which is wired with a `terraform_data` trigger resource to force replacement when the API key changes. Conditional logic in locals merges optional extra filters using a MongoDB-style `$and` expression, and a dynamic `agent` block in the configuration is populated only when the template type is `agent`.

## Features

- Fetches and processes notification channel templates from a remote GitHub repository using gomplate templating
- Creates a nullplatform_notification_channel resource with dynamic agent configuration driven by template content
- Supports optional command-line override flags injected into the agent command data when enabled_override is true
- Merges additional MongoDB-style filter expressions with base template filters using a $and logical operator
- Forces resource replacement via terraform_data trigger when the API key changes
- Configures tag-based agent selectors for filtering notification channels and agents
- Supports configurable repository branch, path, and Git reference for template versioning

## Basic Usage

```hcl
module "scope_definition_agent_association" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_definition_agent_association?ref=v3.5.2"

  api_key                  = "your-api-key"
  nrn                      = "your-nrn"
  scope_specification_id   = "your-scope-specification-id"
  scope_specification_slug = "your-scope-specification-slug"
  tags_selectors           = "your-tags-selectors"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.scope_definition_agent_association.notification_channel_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.5 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.5.0 |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.86 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Resources

| Name | Type |
|------|------|
| [nullplatform_notification_channel.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/notification_channel) | resource |
| [terraform_data.api_key_trigger](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | API key for authenticating with the nullplatform API | `string` | n/a | yes |
| <a name="input_enabled_override"></a> [enabled\_override](#input\_enabled\_override) | Enable custom overrides for scope configurations via command line | `bool` | `false` | no |
| <a name="input_extra_filters"></a> [extra\_filters](#input\_extra\_filters) | Additional filter expression to merge with the base template filters using $and.<br/>Accepts any valid MongoDB-style filter expression, including logical operators<br/>($and, $or, $nor, $not) and comparison operators ($eq, $ne, $in, $nin, $gt,<br/>$gte, $lt, $lte, $regex). If null, only the base template filters are applied.<br/><br/>Examples:<br/>  Simple equality:    { "dimensions.environment" = "production" }<br/>  Comparison:         { "action" = { "$in" = ["deployment:create", "deployment:update"] } }<br/>  Logical OR:         { "$or" = [{ "details.namespace.slug" = "prod" }, { "details.namespace.slug" = "staging" }] }<br/>  Negation:           { "$not" = { "entity\_data.status" = "failed" } }<br/>  Combined:           { "$and" = [{ "action" = { "$regex" = "^deployment" } }, { "$or" = [...] }] } | `any` | `null` | no |
| <a name="input_github_ref"></a> [github\_ref](#input\_github\_ref) | Git reference to use (branch name, tag, or commit SHA) | `string` | `"beta"` | no |
| <a name="input_github_repo_url"></a> [github\_repo\_url](#input\_github\_repo\_url) | GitHub repository URL containing scope and action templates | `string` | `"https://github.com/nullplatform/scopes"` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | n/a | `string` | n/a | yes |
| <a name="input_override_repo_path"></a> [override\_repo\_path](#input\_override\_repo\_path) | Local filesystem path where the scope repository will be cloned | `string` | `null` | no |
| <a name="input_overrides_service_path"></a> [overrides\_service\_path](#input\_overrides\_service\_path) | Local filesystem path to the directory containing override configurations | `string` | `null` | no |
| <a name="input_repo_path"></a> [repo\_path](#input\_repo\_path) | Local filesystem path where the scope repository will be cloned | `string` | `"/root/.np/nullplatform/scopes"` | no |
| <a name="input_repository_notification_channel"></a> [repository\_notification\_channel](#input\_repository\_notification\_channel) | repository of notification channel template | `string` | `"https://raw.githubusercontent.com/nullplatform/scopes/refs/heads"` | no |
| <a name="input_repository_notification_channel_branch"></a> [repository\_notification\_channel\_branch](#input\_repository\_notification\_channel\_branch) | branch reference of notification channel template | `string` | `"main"` | no |
| <a name="input_scope_specification_id"></a> [scope\_specification\_id](#input\_scope\_specification\_id) | ID of the scope (service) specification to associate with the agent notification channel | `string` | n/a | yes |
| <a name="input_scope_specification_slug"></a> [scope\_specification\_slug](#input\_scope\_specification\_slug) | Slug of the scope (service) specification, used as a filter in the notification channel | `string` | n/a | yes |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path to the service directory within the repository structure | `string` | `"k8s"` | no |
| <a name="input_tags_selectors"></a> [tags\_selectors](#input\_tags\_selectors) | Map of tags used to select and filter channels and agents | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_notification_channel_id"></a> [notification\_channel\_id](#output\_notification\_channel\_id) | ID of the created notification channel. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "scope_definition_agent_association",
  "description": "Creates a nullplatform notification channel by fetching and processing a JSON template from a remote repository and registering it with the nullplatform API",
  "architecture": "The module fetches a notification channel template via the `http` data source from a configurable GitHub raw URL, then processes it through an `external` data source using `gomplate` for variable substitution and `jq` for JSON normalization. The processed template drives a `nullplatform_notification_channel` resource, which is wired with a `terraform_data` trigger resource to force replacement when the API key changes. Conditional logic in locals merges optional extra filters using a MongoDB-style `$and` expression, and a dynamic `agent` block in the configuration is populated only when the template type is `agent`.",
  "features": [
    "Fetches and processes notification channel templates from a remote GitHub repository using gomplate templating",
    "Creates a nullplatform_notification_channel resource with dynamic agent configuration driven by template content",
    "Supports optional command-line override flags injected into the agent command data when enabled_override is true",
    "Merges additional MongoDB-style filter expressions with base template filters using a $and logical operator",
    "Forces resource replacement via terraform_data trigger when the API key changes",
    "Configures tag-based agent selectors for filtering notification channels and agents",
    "Supports configurable repository branch, path, and Git reference for template versioning"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "",
      "required": true
    },
    {
      "name": "api_key",
      "description": "API key for authenticating with the nullplatform API",
      "required": true
    },
    {
      "name": "scope_specification_id",
      "description": "ID of the scope (service) specification to associate with the agent notification channel",
      "required": true
    },
    {
      "name": "scope_specification_slug",
      "description": "Slug of the scope (service) specification, used as a filter in the notification channel",
      "required": true
    },
    {
      "name": "tags_selectors",
      "description": "Map of tags used to select and filter channels and agents",
      "required": true
    },
    {
      "name": "enabled_override",
      "description": "Enable custom overrides for scope configurations via command line",
      "required": false
    },
    {
      "name": "overrides_service_path",
      "description": "Local filesystem path to the directory containing override configurations",
      "required": false
    },
    {
      "name": "override_repo_path",
      "description": "Local filesystem path where the scope repository will be cloned",
      "required": false
    },
    {
      "name": "github_repo_url",
      "description": "GitHub repository URL containing scope and action templates",
      "required": false
    },
    {
      "name": "github_ref",
      "description": "Git reference to use (branch name, tag, or commit SHA)",
      "required": false
    },
    {
      "name": "repository_notification_channel",
      "description": "repository of notification channel template",
      "required": false
    },
    {
      "name": "repository_notification_channel_branch",
      "description": "branch reference of notification channel template",
      "required": false
    },
    {
      "name": "service_path",
      "description": "Path to the service directory within the repository structure",
      "required": false
    },
    {
      "name": "repo_path",
      "description": "Local filesystem path where the scope repository will be cloned",
      "required": false
    },
    {
      "name": "extra_filters",
      "description": "",
      "required": false
    }
  ],
  "outputs": [
    "notification_channel_id"
  ],
  "hash": "56e4330dddab5eef6b306255c7a20494"
}
END_AI_METADATA -->
