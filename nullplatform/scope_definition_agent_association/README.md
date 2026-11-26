# Module: scope_definition_agent_association

## Description

Creates a nullplatform notification channel from a JSON template fetched from a remote repository or local disk, configured for either legacy git-clone exec or worker-orchestrator package-exec delivery modes

## Architecture

The module fetches a notification channel template via the `http` data source (or reads it from disk when `local_specs_path` is set), then processes it through a `data.external` shell script using `gomplate` and `jq` to interpolate NRN, API key, and scope identifiers. The rendered JSON definition drives a single `nullplatform_notification_channel` resource whose `agent` dynamic block is conditionally populated based on the channel type, wiring in `tags_selectors`, command type (`package-exec` vs template-driven), and merged environment variables. Filter expressions from the template are optionally combined with `extra_filters` via a MongoDB-style `$and` expression before being passed to the resource.

## Features

- Creates a nullplatform_notification_channel resource from a gomplate-processed JSON template with NRN and scope context injection
- Supports remote template fetching via HTTP data source or local disk reads for offline/CI use cases
- Configures worker-orchestrator package-exec command mode for agent channels, routing to a named package slug and baked entrypoint
- Configures legacy git-clone exec command mode with optional --overrides-path flag appended to the cmdline
- Merges extra environment variables on top of the module defaults (NP_ACTION_CONTEXT, NP_PLUGIN) for agent command configuration
- Combines base template filters with additional MongoDB-style filter expressions using a $and logical operator
- Enforces mutual-exclusion lifecycle preconditions between worker_orchestrator and enabled_override modes

## Basic Usage

```hcl
module "scope_definition_agent_association" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_definition_agent_association?ref=v9.21.0"

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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.107 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.5 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.5.0 |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.107 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_notification_channel.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/notification_channel) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | Deprecated: omit it. When null (default) the platform creates and manages the channel credential (an API key holding only controlplane:agent-dispatcher on the channel NRN); the identity running the apply must be able to assign that role. Passing a key keeps using it; removing it later converts the channel in place (same id). Requires nullplatform provider >= 0.0.107. | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Description shown for the notification channel. | `string` | `"Routes Containers deployments agent"` | no |
| <a name="input_enabled_override"></a> [enabled\_override](#input\_enabled\_override) | Append --overrides-path to the legacy exec channel's cmdline. Not supported with worker\_orchestrator = true (the plan fails): set NP\_OVERRIDES\_PATH in the worker pod instead. | `bool` | `false` | no |
| <a name="input_entrypoint"></a> [entrypoint](#input\_entrypoint) | Override the worker's baked entrypoint path. Defaults to /app/packages/<package\_slug>/entrypoint. | `string` | `""` | no |
| <a name="input_extra_environment"></a> [extra\_environment](#input\_extra\_environment) | Additional environment variables to merge into the agent command's environment. Merged on top of the module's default environment (NP\_ACTION\_CONTEXT, and NP\_PLUGIN when worker\_orchestrator = true), so these values take precedence on key collision. | `map(string)` | `{}` | no |
| <a name="input_extra_filters"></a> [extra\_filters](#input\_extra\_filters) | Additional filter expression to merge with the base template filters using $and.<br/>Accepts any valid MongoDB-style filter expression, including logical operators<br/>($and, $or, $nor, $not) and comparison operators ($eq, $ne, $in, $nin, $gt,<br/>$gte, $lt, $lte, $regex). If null, only the base template filters are applied.<br/><br/>Examples:<br/>  Simple equality:    { "dimensions.environment" = "production" }<br/>  Comparison:         { "action" = { "$in" = ["deployment:create", "deployment:update"] } }<br/>  Logical OR:         { "$or" = [{ "details.namespace.slug" = "prod" }, { "details.namespace.slug" = "staging" }] }<br/>  Negation:           { "$not" = { "entity\_data.status" = "failed" } }<br/>  Combined:           { "$and" = [{ "action" = { "$regex" = "^deployment" } }, { "$or" = [...] }] } | `any` | `null` | no |
| <a name="input_github_ref"></a> [github\_ref](#input\_github\_ref) | Git reference to use (branch name, tag, or commit SHA) | `string` | `"beta"` | no |
| <a name="input_github_repo_url"></a> [github\_repo\_url](#input\_github\_repo\_url) | GitHub repository URL containing scope and action templates | `string` | `"https://github.com/nullplatform/scopes"` | no |
| <a name="input_local_specs_path"></a> [local\_specs\_path](#input\_local\_specs\_path) | Absolute path to a local directory holding the scope's `specs/` (the<br/>`service_path` directory of a checkout of the scope repository). When set,<br/>`specs/notification-channel.json.tpl` is read from disk and<br/>`repository_notification_channel(_branch)` are ignored. Null (the default)<br/>fetches the template over HTTP. | `string` | `null` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (NRN) — unique identifier for the target resource | `string` | n/a | yes |
| <a name="input_override_repo_path"></a> [override\_repo\_path](#input\_override\_repo\_path) | Local filesystem path where the scope repository will be cloned. Only used by the legacy exec channel. | `string` | `null` | no |
| <a name="input_overrides_service_path"></a> [overrides\_service\_path](#input\_overrides\_service\_path) | Local filesystem path to the directory containing override configurations. Only used by the legacy exec channel. | `string` | `null` | no |
| <a name="input_package_slug"></a> [package\_slug](#input\_package\_slug) | Package/scope slug — the package-exec NP\_PLUGIN and default entrypoint path. Required when worker\_orchestrator = true. | `string` | `""` | no |
| <a name="input_repo_path"></a> [repo\_path](#input\_repo\_path) | Local filesystem path where the scope repository will be cloned. Only used by the legacy exec channel. | `string` | `"/root/.np/nullplatform/scopes"` | no |
| <a name="input_repository_notification_channel"></a> [repository\_notification\_channel](#input\_repository\_notification\_channel) | repository of notification channel template | `string` | `"https://raw.githubusercontent.com/nullplatform/scopes/refs/heads"` | no |
| <a name="input_repository_notification_channel_branch"></a> [repository\_notification\_channel\_branch](#input\_repository\_notification\_channel\_branch) | branch reference of notification channel template | `string` | `"main"` | no |
| <a name="input_scope_specification_id"></a> [scope\_specification\_id](#input\_scope\_specification\_id) | ID of the scope (service) specification to associate with the agent notification channel | `string` | n/a | yes |
| <a name="input_scope_specification_slug"></a> [scope\_specification\_slug](#input\_scope\_specification\_slug) | Slug of the scope (service) specification, used as a filter in the notification channel | `string` | n/a | yes |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path to the service directory within the repository structure | `string` | `"k8s"` | no |
| <a name="input_tags_selectors"></a> [tags\_selectors](#input\_tags\_selectors) | Map of tags used to select and filter channels and agents | `map(string)` | n/a | yes |
| <a name="input_worker_orchestrator"></a> [worker\_orchestrator](#input\_worker\_orchestrator) | Emit a worker-orchestrator (package-exec) channel instead of the legacy<br/>git-clone exec channel. When true, the channel routes package-exec commands<br/>to an agent that spawns the package's worker image and runs its baked<br/>entrypoint — matching what `np package publish` registers. Requires<br/>package\_slug; set tags\_selectors to select the agent (e.g. {package = slug}). | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_notification_channel_id"></a> [notification\_channel\_id](#output\_notification\_channel\_id) | ID of the created notification channel. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "scope_definition_agent_association",
  "description": "Creates a nullplatform notification channel from a JSON template fetched from a remote repository or local disk, configured for either legacy git-clone exec or worker-orchestrator package-exec delivery modes",
  "architecture": "The module fetches a notification channel template via the `http` data source (or reads it from disk when `local_specs_path` is set), then processes it through a `data.external` shell script using `gomplate` and `jq` to interpolate NRN, API key, and scope identifiers. The rendered JSON definition drives a single `nullplatform_notification_channel` resource whose `agent` dynamic block is conditionally populated based on the channel type, wiring in `tags_selectors`, command type (`package-exec` vs template-driven), and merged environment variables. Filter expressions from the template are optionally combined with `extra_filters` via a MongoDB-style `$and` expression before being passed to the resource.",
  "features": [
    "Creates a nullplatform_notification_channel resource from a gomplate-processed JSON template with NRN and scope context injection",
    "Supports remote template fetching via HTTP data source or local disk reads for offline/CI use cases",
    "Configures worker-orchestrator package-exec command mode for agent channels, routing to a named package slug and baked entrypoint",
    "Configures legacy git-clone exec command mode with optional --overrides-path flag appended to the cmdline",
    "Merges extra environment variables on top of the module defaults (NP_ACTION_CONTEXT, NP_PLUGIN) for agent command configuration",
    "Combines base template filters with additional MongoDB-style filter expressions using a $and logical operator",
    "Enforces mutual-exclusion lifecycle preconditions between worker_orchestrator and enabled_override modes"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "Nullplatform Resource Name (NRN) — unique identifier for the target resource",
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
      "name": "github_repo_url",
      "description": "GitHub repository URL containing scope and action templates",
      "required": false
    },
    {
      "name": "enabled_override",
      "description": "Append --overrides-path to the legacy exec channel's cmdline. Not supported with worker_orchestrator = true (the plan fails): set NP_OVERRIDES_PATH in the worker pod instead.",
      "required": false
    },
    {
      "name": "worker_orchestrator",
      "description": "",
      "required": false
    },
    {
      "name": "package_slug",
      "description": "Package/scope slug — the package-exec NP_PLUGIN and default entrypoint path. Required when worker_orchestrator = true.",
      "required": false
    },
    {
      "name": "entrypoint",
      "description": "Override the worker's baked entrypoint path. Defaults to /app/packages/<package_slug>/entrypoint.",
      "required": false
    },
    {
      "name": "overrides_service_path",
      "description": "Local filesystem path to the directory containing override configurations. Only used by the legacy exec channel.",
      "required": false
    },
    {
      "name": "override_repo_path",
      "description": "Local filesystem path where the scope repository will be cloned. Only used by the legacy exec channel.",
      "required": false
    },
    {
      "name": "github_ref",
      "description": "Git reference to use (branch name, tag, or commit SHA)",
      "required": false
    },
    {
      "name": "local_specs_path",
      "description": "",
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
      "name": "api_key",
      "description": "Deprecated: omit it. When null (default) the platform creates and manages the channel credential (an API key holding only controlplane:agent-dispatcher on the channel NRN); the identity running the apply must be able to assign that role. Passing a key keeps using it; removing it later converts the channel in place (same id). Requires nullplatform provider >= 0.0.107.",
      "required": false
    },
    {
      "name": "repo_path",
      "description": "Local filesystem path where the scope repository will be cloned. Only used by the legacy exec channel.",
      "required": false
    },
    {
      "name": "description",
      "description": "Description shown for the notification channel.",
      "required": false
    },
    {
      "name": "extra_environment",
      "description": "Additional environment variables to merge into the agent command's environment. Merged on top of the module's default environment (NP_ACTION_CONTEXT, and NP_PLUGIN when worker_orchestrator = true), so these values take precedence on key collision.",
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
  "hash": "0836ba5734cd80b70e6c90581b2580ae"
}
END_AI_METADATA -->
