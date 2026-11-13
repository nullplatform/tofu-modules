# Module: parameter_storage_definition_agent_association

## Description

Creates a nullplatform agent notification channel that routes parameter storage and retrieval commands either through a legacy git-clone exec or a worker-orchestrator package-exec mechanism

## Architecture

The module creates a single nullplatform_notification_channel resource of type 'agent' anchored to the provided NRN. Input variables flow into a nested configuration block containing agent settings including API key, tag selectors, and a command block whose type and data attributes are conditionally set based on the worker_orchestrator boolean. A lifecycle precondition enforces that package_slug and entrypoint are non-empty when worker_orchestrator is true, and the resource ID is surfaced via output.

## Features

- Creates a nullplatform_notification_channel of type agent anchored to a specified NRN
- Configures legacy git-clone exec command with a script path when worker orchestration is disabled
- Configures package-exec worker-orchestrator command with package slug and entrypoint when worker orchestration is enabled
- Supports tag-based agent selector filtering via a configurable map of key-value tags
- Manages platform-created API key credentials by default, with optional override for legacy key injection
- Enforces precondition validation ensuring package_slug and entrypoint are provided when worker_orchestrator is true

## Basic Usage

```hcl
module "parameter_storage_definition_agent_association" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/parameter_storage_definition_agent_association?ref=v9.15.0"

  nrn = "your-nrn"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.parameter_storage_definition_agent_association.notification_channel_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.107 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.107 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_notification_channel.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/notification_channel) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | Deprecated: omit it. When null (default) the platform creates and manages the channel credential (an API key holding only controlplane:agent-dispatcher on the channel NRN); the identity running the apply must be able to assign that role. Passing a key keeps using it; removing it later converts the channel in place (same id). Requires nullplatform provider >= 0.0.107. | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Description shown for the notification channel. | `string` | `""` | no |
| <a name="input_entrypoint"></a> [entrypoint](#input\_entrypoint) | Entrypoint baked into the parameters worker image. Used when worker\_orchestrator = true. | `string` | `"/app/pkg/parameters/entrypoint"` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | NRN where the agent notification channel is anchored. | `string` | n/a | yes |
| <a name="input_package_slug"></a> [package\_slug](#input\_package\_slug) | Package slug of the parameters worker — the package-exec package and NP\_PLUGIN. Used when worker\_orchestrator = true. | `string` | `"parameters"` | no |
| <a name="input_script_path"></a> [script\_path](#input\_script\_path) | Command line path the agent executes to handle parameter storage and retrieval. Unused when worker\_orchestrator = true. | `string` | `"nullplatform/parameters-provider/parameters/entrypoint"` | no |
| <a name="input_tags_selectors"></a> [tags\_selectors](#input\_tags\_selectors) | Map of tags the agent uses to select/filter this channel against scope tags (e.g. { environment = "production" }). | `map(string)` | `{}` | no |
| <a name="input_worker_orchestrator"></a> [worker\_orchestrator](#input\_worker\_orchestrator) | Emit a worker-orchestrator (package-exec) channel instead of the legacy<br/>git-clone exec channel. When true, the agent spawns the parameters worker<br/>image (public.ecr.aws/nullplatform/agent-plugins/services/parameters) in its<br/>own pod and runs its baked entrypoint, instead of running the provider<br/>inside the agent. The agent must resolve package\_slug to that image (worker<br/>pins) and be selected by tags\_selectors. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_notification_channel_id"></a> [notification\_channel\_id](#output\_notification\_channel\_id) | ID of the created agent notification channel. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "parameter_storage_definition_agent_association",
  "description": "Creates a nullplatform agent notification channel that routes parameter storage and retrieval commands either through a legacy git-clone exec or a worker-orchestrator package-exec mechanism",
  "architecture": "The module creates a single nullplatform_notification_channel resource of type 'agent' anchored to the provided NRN. Input variables flow into a nested configuration block containing agent settings including API key, tag selectors, and a command block whose type and data attributes are conditionally set based on the worker_orchestrator boolean. A lifecycle precondition enforces that package_slug and entrypoint are non-empty when worker_orchestrator is true, and the resource ID is surfaced via output.",
  "features": [
    "Creates a nullplatform_notification_channel of type agent anchored to a specified NRN",
    "Configures legacy git-clone exec command with a script path when worker orchestration is disabled",
    "Configures package-exec worker-orchestrator command with package slug and entrypoint when worker orchestration is enabled",
    "Supports tag-based agent selector filtering via a configurable map of key-value tags",
    "Manages platform-created API key credentials by default, with optional override for legacy key injection",
    "Enforces precondition validation ensuring package_slug and entrypoint are provided when worker_orchestrator is true"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "NRN where the agent notification channel is anchored.",
      "required": true
    },
    {
      "name": "api_key",
      "description": "Deprecated: omit it. When null (default) the platform creates and manages the channel credential (an API key holding only controlplane:agent-dispatcher on the channel NRN); the identity running the apply must be able to assign that role. Passing a key keeps using it; removing it later converts the channel in place (same id). Requires nullplatform provider >= 0.0.107.",
      "required": false
    },
    {
      "name": "tags_selectors",
      "description": "Map of tags the agent uses to select/filter this channel against scope tags (e.g. { environment = \\",
      "required": false
    },
    {
      "name": "script_path",
      "description": "Command line path the agent executes to handle parameter storage and retrieval. Unused when worker_orchestrator = true.",
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
      "description": "Package slug of the parameters worker — the package-exec package and NP_PLUGIN. Used when worker_orchestrator = true.",
      "required": false
    },
    {
      "name": "entrypoint",
      "description": "Entrypoint baked into the parameters worker image. Used when worker_orchestrator = true.",
      "required": false
    }
  ],
  "outputs": [
    "notification_channel_id"
  ],
  "hash": "c3197818678ab029cb4c44fb08d062c3"
}
END_AI_METADATA -->
