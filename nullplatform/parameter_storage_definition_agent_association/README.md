# Module: parameter_storage_definition_agent_association

## Description

Creates a single nullplatform agent notification channel for parameter storage and retrieval, anchored at an NRN and selected by tags. Designed to be instantiated with `for_each` by the caller, one per instance

## Architecture

The module creates one `nullplatform_notification_channel` of type `agent` with a parameter-storage-specific configuration (source `["parameters"]`, an `exec` command pointing at the agent entrypoint, and a tag selector). The agent API key is supplied by the caller rather than created here; a `terraform_data.api_key_trigger` records the key and the channel declares `replace_triggered_by` on it, so rotating the key recreates the channel (API keys are immutable on an existing channel). Modeling a single channel keeps the module focused: the caller drives multiplicity with its own `for_each`, passing each instance's NRN, API key, and selectors.

## Features

- Creates one agent notification channel for parameter storage/retrieval per module invocation
- Receives the agent API key from the caller instead of provisioning one
- Recreates the channel automatically when the API key rotates, via a terraform_data trigger and `replace_triggered_by`
- Selects the channel against scope tags with a caller-provided selector map
- Exposes the created notification channel ID for downstream references

## Basic Usage

```hcl
module "parameter_storage_definition_agent_association" {
  source   = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/parameter_storage_definition_agent_association?ref=v6.1.0"
  for_each = local.instances

  nrn            = each.value.nrn
  api_key        = each.value.api_key
  tags_selectors = each.value.tags_selectors
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.parameter_storage_definition_agent_association["prod"].notification_channel_id
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
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | >= 0.0.95 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [nullplatform_notification_channel.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/notification_channel) | resource |
| [terraform_data.api_key_trigger](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_nrn"></a> [nrn](#input\_nrn) | NRN where the agent notification channel is anchored. | `string` | n/a | yes |
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | Agent API key for the notification channel. Rotating it recreates the channel (via terraform\_data.api\_key\_trigger). | `string` | n/a | yes |
| <a name="input_tags_selectors"></a> [tags\_selectors](#input\_tags\_selectors) | Map of tags the agent uses to select/filter this channel against scope tags (e.g. { environment = "production" }). | `map(string)` | `{}` | no |
| <a name="input_script_path"></a> [script\_path](#input\_script\_path) | Command line path the agent executes to handle parameter storage and retrieval. | `string` | `"nullplatform/parameters/parameters/entrypoint"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_notification_channel_id"></a> [notification\_channel\_id](#output\_notification\_channel\_id) | ID of the created agent notification channel. |
<!-- END_TF_DOCS -->
