# Module: parameter_storage_definition

## Description

Registers a nullplatform provider specification for parameter storage by fetching, rendering with gomplate, and applying a template from a remote GitHub repository

## Architecture

A data.http resource fetches the raw specification template from a configurable GitHub repository URL composed of repository base, branch, and template path variables. A data.external resource then pipes the fetched template body through gomplate for NRN-based variable substitution and jq for JSON normalization. The rendered JSON is decoded into locals and fed into a nullplatform_provider_specification resource that sets name, icon, description, category, schema, and visibility scope. Outputs expose the created resource's id, slug, and resolved name for downstream configuration modules.

## Features

- Fetches provider specification templates from a configurable remote GitHub repository with branch selection
- Renders specification templates using gomplate with NRN variable substitution before applying
- Creates a nullplatform_provider_specification resource with full schema, icon, category, and dimension support
- Controls specification visibility across multiple NRNs by merging the anchor NRN with additional NRNs via distinct(concat())
- Exposes specification ID and slug outputs for use by downstream parameter storage configuration modules

## Basic Usage

```hcl
module "parameter_storage_definition" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/parameter_storage_definition?ref=v6.8.0"

  np_api_key    = "your-np-api-key"
  nrn           = "your-nrn"
  template_path = "your-template-path"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.parameter_storage_definition.specification_id
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
| <a name="provider_external"></a> [external](#provider\_external) | 2.4.0 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.6.0 |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.96 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_specification.parameter_storage_specification](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_specification) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_extra_visible_to_nrns"></a> [extra\_visible\_to\_nrns](#input\_extra\_visible\_to\_nrns) | Additional NRNs that should see the provider specification besides var.nrn. Callers registering instances at other NRNs (via parameter\_storage\_configuration) should list those NRNs here so the spec is visible where the instances are anchored. | `list(string)` | `[]` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | nullplatform API key. Kept for interface consistency across the parameter-storage modules; the provider is configured at the root. | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | NRN where the provider specification is anchored (the top-level scope it belongs to). | `string` | n/a | yes |
| <a name="input_repository_parameter_storage_spec"></a> [repository\_parameter\_storage\_spec](#input\_repository\_parameter\_storage\_spec) | repository of parameter storage spec | `string` | `"https://raw.githubusercontent.com/nullplatform/parameters-provider/refs/heads"` | no |
| <a name="input_repository_parameter_storage_spec_branch"></a> [repository\_parameter\_storage\_spec\_branch](#input\_repository\_parameter\_storage\_spec\_branch) | branch reference of parameter storage spec | `string` | `"main"` | no |
| <a name="input_template_path"></a> [template\_path](#input\_template\_path) | Path to the parameter storage specification template | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | Name of the provider specification, resolved from the rendered template. |
| <a name="output_slug"></a> [slug](#output\_slug) | Slug of the created provider specification. Pass this to parameter\_storage\_configuration.provider\_specification\_slug. |
| <a name="output_specification_id"></a> [specification\_id](#output\_specification\_id) | ID of the created parameter-storage provider specification. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "parameter_storage_definition",
  "description": "Registers a nullplatform provider specification for parameter storage by fetching, rendering with gomplate, and applying a template from a remote GitHub repository",
  "architecture": "A data.http resource fetches the raw specification template from a configurable GitHub repository URL composed of repository base, branch, and template path variables. A data.external resource then pipes the fetched template body through gomplate for NRN-based variable substitution and jq for JSON normalization. The rendered JSON is decoded into locals and fed into a nullplatform_provider_specification resource that sets name, icon, description, category, schema, and visibility scope. Outputs expose the created resource's id, slug, and resolved name for downstream configuration modules.",
  "features": [
    "Fetches provider specification templates from a configurable remote GitHub repository with branch selection",
    "Renders specification templates using gomplate with NRN variable substitution before applying",
    "Creates a nullplatform_provider_specification resource with full schema, icon, category, and dimension support",
    "Controls specification visibility across multiple NRNs by merging the anchor NRN with additional NRNs via distinct(concat())",
    "Exposes specification ID and slug outputs for use by downstream parameter storage configuration modules"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "NRN where the provider specification is anchored (the top-level scope it belongs to).",
      "required": true
    },
    {
      "name": "np_api_key",
      "description": "nullplatform API key. Kept for interface consistency across the parameter-storage modules; the provider is configured at the root.",
      "required": true
    },
    {
      "name": "template_path",
      "description": "Path to the parameter storage specification template",
      "required": true
    },
    {
      "name": "extra_visible_to_nrns",
      "description": "Additional NRNs that should see the provider specification besides var.nrn. Callers registering instances at other NRNs (via parameter_storage_configuration) should list those NRNs here so the spec is visible where the instances are anchored.",
      "required": false
    },
    {
      "name": "repository_parameter_storage_spec",
      "description": "repository of parameter storage spec",
      "required": false
    },
    {
      "name": "repository_parameter_storage_spec_branch",
      "description": "branch reference of parameter storage spec",
      "required": false
    }
  ],
  "outputs": [
    "specification_id",
    "slug",
    "name"
  ],
  "hash": "3392b26896c52e2a2d0131bda856b5fd"
}
END_AI_METADATA -->
