# Module: parameter_storage_definition_agent_association

## Description

Creates a NullPlatform agent notification channel configured to handle parameter storage and retrieval via an exec command

## Architecture

The module provisions a single nullplatform_notification_channel resource of type 'agent' with source set to 'parameters'. The resource is anchored to a given NRN and internally wires the api_key, tag selectors, and script_path into the agent configuration block's command data. The exec command injects a NOTIFICATION_CONTEXT environment variable via jsonencode, and the resulting channel ID is surfaced as an output.

## Features

- Creates a NullPlatform agent notification channel anchored to a specified NRN
- Configures an exec-type command with a customizable script path for parameter storage and retrieval
- Injects NOTIFICATION_CONTEXT environment variable into the agent exec command automatically
- Supports tag-based selector filtering so agents can scope channels to specific environments
- Accepts an optional sensitive API key with platform-managed credential fallback when omitted
- Exposes the created notification channel ID as an output for downstream reference

## Basic Usage

```hcl
module "parameter_storage_definition_agent_association" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/parameter_storage_definition_agent_association?ref=v9.4.0"

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
| <a name="input_nrn"></a> [nrn](#input\_nrn) | NRN where the agent notification channel is anchored. | `string` | n/a | yes |
| <a name="input_script_path"></a> [script\_path](#input\_script\_path) | Command line path the agent executes to handle parameter storage and retrieval. | `string` | `"nullplatform/parameters-provider/parameters/entrypoint"` | no |
| <a name="input_tags_selectors"></a> [tags\_selectors](#input\_tags\_selectors) | Map of tags the agent uses to select/filter this channel against scope tags (e.g. { environment = "production" }). | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_notification_channel_id"></a> [notification\_channel\_id](#output\_notification\_channel\_id) | ID of the created agent notification channel. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "parameter_storage_definition_agent_association",
  "description": "Creates a NullPlatform agent notification channel configured to handle parameter storage and retrieval via an exec command",
  "architecture": "The module provisions a single nullplatform_notification_channel resource of type 'agent' with source set to 'parameters'. The resource is anchored to a given NRN and internally wires the api_key, tag selectors, and script_path into the agent configuration block's command data. The exec command injects a NOTIFICATION_CONTEXT environment variable via jsonencode, and the resulting channel ID is surfaced as an output.",
  "features": [
    "Creates a NullPlatform agent notification channel anchored to a specified NRN",
    "Configures an exec-type command with a customizable script path for parameter storage and retrieval",
    "Injects NOTIFICATION_CONTEXT environment variable into the agent exec command automatically",
    "Supports tag-based selector filtering so agents can scope channels to specific environments",
    "Accepts an optional sensitive API key with platform-managed credential fallback when omitted",
    "Exposes the created notification channel ID as an output for downstream reference"
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
      "description": "Command line path the agent executes to handle parameter storage and retrieval.",
      "required": false
    },
    {
      "name": "description",
      "description": "Description shown for the notification channel.",
      "required": false
    }
  ],
  "outputs": [
    "notification_channel_id"
  ],
  "hash": "249bce6a359aa0aafd7481fe094c04d1"
}
END_AI_METADATA -->
