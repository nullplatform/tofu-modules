# Module: service_definition_agent_association

## Description

Creates a NullPlatform notification channel that routes service events to agents using either a worker-orchestrator (package-exec) or legacy git-clone exec command mode

## Architecture

The module creates a single nullplatform_notification_channel resource configured with an agent block that contains API credentials, a command block, and tag-based agent selectors. The command type is conditionally set to either 'package-exec' (worker_orchestrator=true) or 'exec' (worker_orchestrator=false), with the data payload built accordingly from package_slug/entrypoint or repository path variables. Lifecycle preconditions enforce that package_slug is provided for worker-orchestrator mode and repository_service_spec_repo is provided for legacy exec mode. The channel filters notifications using a JSON-encoded OR condition matching service specification slugs against incoming notification context.

## Features

- Creates a nullplatform_notification_channel with tag-based agent selector filtering
- Supports worker-orchestrator mode that spawns package worker images via package-exec commands
- Supports legacy git-clone exec mode that runs entrypoints from cloned repositories inside agent pods
- Configures dynamic JSON-encoded environment variables injecting NP_ACTION_CONTEXT and NP_PLUGIN into agent commands
- Enforces lifecycle preconditions to validate required variables per orchestration mode
- Filters notification routing by service specification slug using OR-based JSON filter expressions
- Allows optional API key override with platform-managed credential as the default

## Basic Usage

```hcl
module "service_definition_agent_association" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/service_definition_agent_association?ref=v9.6.0"

  tags_selectors = "your-tags-selectors"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.service_definition_agent_association.id
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
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.107 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_notification_channel.channel_from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/notification_channel) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_arguments"></a> [agent\_arguments](#input\_agent\_arguments) | Arguments to pass to the agent entrypoint command. Unused when worker\_orchestrator = true. | `list(string)` | `[]` | no |
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | Deprecated: omit it. When null (default) the platform creates and manages the channel credential (an API key holding only controlplane:agent-dispatcher on the channel NRN); the identity running the apply must be able to assign that role. Passing a key keeps using it; removing it later converts the channel in place (same id). Requires nullplatform provider >= 0.0.107. | `string` | `null` | no |
| <a name="input_base_clone_path"></a> [base\_clone\_path](#input\_base\_clone\_path) | Base path where the service repository is cloned inside the agent pod. Unused when worker\_orchestrator = true. | `string` | `"/home/agent/.np"` | no |
| <a name="input_channel_sources"></a> [channel\_sources](#input\_channel\_sources) | List of sources for the notification channel (e.g., ['service', 'telemetry']). Add 'telemetry' to receive metric:list and metric:data notifications for the service | `list(string)` | <pre>[<br/>  "service"<br/>]</pre> | no |
| <a name="input_channel_type"></a> [channel\_type](#input\_channel\_type) | Type of the notification channel (e.g., 'agent') | `string` | `"agent"` | no |
| <a name="input_description"></a> [description](#input\_description) | Description shown for the notification channel. | `string` | `""` | no |
| <a name="input_entrypoint"></a> [entrypoint](#input\_entrypoint) | Override the worker's baked entrypoint path. Defaults to /app/packages/<package\_slug>/entrypoint. | `string` | `""` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (organization:account format) | `string` | `null` | no |
| <a name="input_package_slug"></a> [package\_slug](#input\_package\_slug) | Package/service slug — the package-exec NP\_PLUGIN and default entrypoint path. Required when worker\_orchestrator = true. | `string` | `""` | no |
| <a name="input_repository_service_spec_repo"></a> [repository\_service\_spec\_repo](#input\_repository\_service\_spec\_repo) | GitHub repository name containing the service specs (used to build the agent cmdline path). Required when worker\_orchestrator = false; unused (the worker's baked entrypoint is used instead) when true. | `string` | `""` | no |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path to the service directory within the repository (e.g., databases/postgres/k8s). Only consulted when worker\_orchestrator = false — empty omits the path segment. | `string` | `""` | no |
| <a name="input_service_specification_slug"></a> [service\_specification\_slug](#input\_service\_specification\_slug) | The slug of the service definition | `string` | `null` | no |
| <a name="input_tags_selectors"></a> [tags\_selectors](#input\_tags\_selectors) | Map of tags used to select and filter agents | `map(string)` | n/a | yes |
| <a name="input_worker_orchestrator"></a> [worker\_orchestrator](#input\_worker\_orchestrator) | Emit a worker-orchestrator (package-exec) channel instead of the legacy<br/>git-clone exec channel. When true, the channel routes package-exec commands<br/>to an agent that spawns the package's worker image and runs its baked<br/>entrypoint — matching what `np package publish` registers. Requires<br/>package\_slug; set tags\_selectors to select the agent (e.g. {package = slug}). | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the created notification channel |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "service_definition_agent_association",
  "description": "Creates a NullPlatform notification channel that routes service events to agents using either a worker-orchestrator (package-exec) or legacy git-clone exec command mode",
  "architecture": "The module creates a single nullplatform_notification_channel resource configured with an agent block that contains API credentials, a command block, and tag-based agent selectors. The command type is conditionally set to either 'package-exec' (worker_orchestrator=true) or 'exec' (worker_orchestrator=false), with the data payload built accordingly from package_slug/entrypoint or repository path variables. Lifecycle preconditions enforce that package_slug is provided for worker-orchestrator mode and repository_service_spec_repo is provided for legacy exec mode. The channel filters notifications using a JSON-encoded OR condition matching service specification slugs against incoming notification context.",
  "features": [
    "Creates a nullplatform_notification_channel with tag-based agent selector filtering",
    "Supports worker-orchestrator mode that spawns package worker images via package-exec commands",
    "Supports legacy git-clone exec mode that runs entrypoints from cloned repositories inside agent pods",
    "Configures dynamic JSON-encoded environment variables injecting NP_ACTION_CONTEXT and NP_PLUGIN into agent commands",
    "Enforces lifecycle preconditions to validate required variables per orchestration mode",
    "Filters notification routing by service specification slug using OR-based JSON filter expressions",
    "Allows optional API key override with platform-managed credential as the default"
  ],
  "inputs": [
    {
      "name": "tags_selectors",
      "description": "Map of tags used to select and filter agents",
      "required": true
    },
    {
      "name": "nrn",
      "description": "Nullplatform Resource Name (organization:account format)",
      "required": false
    },
    {
      "name": "api_key",
      "description": "Deprecated: omit it. When null (default) the platform creates and manages the channel credential (an API key holding only controlplane:agent-dispatcher on the channel NRN); the identity running the apply must be able to assign that role. Passing a key keeps using it; removing it later converts the channel in place (same id). Requires nullplatform provider >= 0.0.107.",
      "required": false
    },
    {
      "name": "channel_sources",
      "description": "List of sources for the notification channel (e.g., ['service', 'telemetry']). Add 'telemetry' to receive metric:list and metric:data notifications for the service",
      "required": false
    },
    {
      "name": "channel_type",
      "description": "Type of the notification channel (e.g., 'agent')",
      "required": false
    },
    {
      "name": "service_specification_slug",
      "description": "The slug of the service definition",
      "required": false
    },
    {
      "name": "repository_service_spec_repo",
      "description": "GitHub repository name containing the service specs (used to build the agent cmdline path). Required when worker_orchestrator = false; unused (the worker's baked entrypoint is used instead) when true.",
      "required": false
    },
    {
      "name": "base_clone_path",
      "description": "Base path where the service repository is cloned inside the agent pod. Unused when worker_orchestrator = true.",
      "required": false
    },
    {
      "name": "service_path",
      "description": "Path to the service directory within the repository (e.g., databases/postgres/k8s). Only consulted when worker_orchestrator = false — empty omits the path segment.",
      "required": false
    },
    {
      "name": "agent_arguments",
      "description": "Arguments to pass to the agent entrypoint command. Unused when worker_orchestrator = true.",
      "required": false
    },
    {
      "name": "description",
      "description": "Description shown for the notification channel.",
      "required": false
    },
    {
      "name": "worker_orchestrator",
      "description": "",
      "required": false
    },
    {
      "name": "package_slug",
      "description": "Package/service slug — the package-exec NP_PLUGIN and default entrypoint path. Required when worker_orchestrator = true.",
      "required": false
    },
    {
      "name": "entrypoint",
      "description": "Override the worker's baked entrypoint path. Defaults to /app/packages/<package_slug>/entrypoint.",
      "required": false
    }
  ],
  "outputs": [
    "id"
  ],
  "hash": "b2f701872e8cb3f574bf3ac3cd623559"
}
END_AI_METADATA -->
