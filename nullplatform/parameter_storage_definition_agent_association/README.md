# Module: parameter_storage_definition_agent_association

## Description

Creates a NullPlatform agent notification channel configured to handle parameter storage and retrieval via an exec command

## Architecture

A terraform_data resource stores the api_key as a trigger value, causing the nullplatform_notification_channel resource to be recreated whenever the API key changes. The nullplatform_notification_channel resource is created with type 'agent' and source 'parameters', wiring in the nrn, api_key, tags_selectors, and script_path inputs into its nested agent configuration block. The lifecycle replace_triggered_by directive links the notification channel to the terraform_data trigger, ensuring channel recreation on key rotation. The channel's ID is exposed via an output for downstream consumption.

## Features

- Creates a nullplatform_notification_channel of type 'agent' anchored to a specified NRN
- Configures an exec command within the agent channel to invoke a custom script path for parameter handling
- Injects the NOTIFICATION_CONTEXT environment variable into the agent exec command using jsonencode
- Supports tag-based selector filtering via a configurable map of tags applied to the agent channel
- Triggers automatic channel recreation via terraform_data when the API key is rotated
- Exposes the created notification channel ID as an output for reference by other modules

## Basic Usage

```hcl
module "parameter_storage_definition_agent_association" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/parameter_storage_definition_agent_association?ref=v6.2.2"

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
  "architecture": "A terraform_data resource stores the api_key as a trigger value, causing the nullplatform_notification_channel resource to be recreated whenever the API key changes. The nullplatform_notification_channel resource is created with type 'agent' and source 'parameters', wiring in the nrn, api_key, tags_selectors, and script_path inputs into its nested agent configuration block. The lifecycle replace_triggered_by directive links the notification channel to the terraform_data trigger, ensuring channel recreation on key rotation. The channel's ID is exposed via an output for downstream consumption.",
  "features": [
    "Creates a nullplatform_notification_channel of type 'agent' anchored to a specified NRN",
    "Configures an exec command within the agent channel to invoke a custom script path for parameter handling",
    "Injects the NOTIFICATION_CONTEXT environment variable into the agent exec command using jsonencode",
    "Supports tag-based selector filtering via a configurable map of tags applied to the agent channel",
    "Triggers automatic channel recreation via terraform_data when the API key is rotated",
    "Exposes the created notification channel ID as an output for reference by other modules"
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
  "hash": "456b971b7955c2f1cb601d516158cac6"
}
END_AI_METADATA -->
