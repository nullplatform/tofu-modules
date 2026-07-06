# Module: parameter_storage_definition_agent_association

## Description

Creates a NullPlatform agent notification channel configured to handle parameter storage and retrieval via an exec command

## Architecture

The module creates a terraform_data resource that tracks the api_key value as a lifecycle trigger, and a nullplatform_notification_channel resource of type 'agent' anchored to the provided NRN. The notification channel is configured with an agent block containing the API key, tag selectors, and an exec command pointing to a script path with an injected NOTIFICATION_CONTEXT environment variable. When the api_key changes, the replace_triggered_by lifecycle rule forces recreation of the notification channel. The channel ID is exposed as an output for downstream consumption.

## Features

- Creates a nullplatform_notification_channel of type 'agent' anchored to a specified NRN resource
- Configures an exec-based command with a customizable script path for parameter storage and retrieval
- Injects NOTIFICATION_CONTEXT environment variable into the agent exec command at runtime
- Supports tag-based selector filtering via a configurable map of key-value tag selectors
- Automatically recreates the notification channel when the API key is rotated using terraform_data lifecycle triggers
- Marks the API key as sensitive to prevent exposure in Terraform plan and state output

## Basic Usage

```hcl
module "parameter_storage_definition_agent_association" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/parameter_storage_definition_agent_association?ref=v6.2.0"

  api_key = "your-api-key"
  nrn     = "your-nrn"
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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.95 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.96 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Resources

| Name | Type |
|------|------|
| [nullplatform_notification_channel.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/notification_channel) | resource |
| [terraform_data.api_key_trigger](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | Agent API key for the notification channel. Rotating it recreates the channel (via terraform\_data.api\_key\_trigger). | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | NRN where the agent notification channel is anchored. | `string` | n/a | yes |
| <a name="input_script_path"></a> [script\_path](#input\_script\_path) | Command line path the agent executes to handle parameter storage and retrieval. | `string` | `"nullplatform/parameters/parameters/entrypoint"` | no |
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
  "architecture": "The module creates a terraform_data resource that tracks the api_key value as a lifecycle trigger, and a nullplatform_notification_channel resource of type 'agent' anchored to the provided NRN. The notification channel is configured with an agent block containing the API key, tag selectors, and an exec command pointing to a script path with an injected NOTIFICATION_CONTEXT environment variable. When the api_key changes, the replace_triggered_by lifecycle rule forces recreation of the notification channel. The channel ID is exposed as an output for downstream consumption.",
  "features": [
    "Creates a nullplatform_notification_channel of type 'agent' anchored to a specified NRN resource",
    "Configures an exec-based command with a customizable script path for parameter storage and retrieval",
    "Injects NOTIFICATION_CONTEXT environment variable into the agent exec command at runtime",
    "Supports tag-based selector filtering via a configurable map of key-value tag selectors",
    "Automatically recreates the notification channel when the API key is rotated using terraform_data lifecycle triggers",
    "Marks the API key as sensitive to prevent exposure in Terraform plan and state output"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "NRN where the agent notification channel is anchored.",
      "required": true
    },
    {
      "name": "api_key",
      "description": "Agent API key for the notification channel. Rotating it recreates the channel (via terraform_data.api_key_trigger).",
      "required": true
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
    }
  ],
  "outputs": [
    "notification_channel_id"
  ],
  "hash": "9be10070d69155de12b0c1bc965d7ac4"
}
END_AI_METADATA -->
