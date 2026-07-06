# Module: parameter_storage_definition

## Description

Provisions a nullplatform parameter-storage provider specification by fetching and rendering a gomplate template from a remote repository, then registers one or more provider instances (per NRN and dimensions) via the upstream scope_configuration module

## Architecture

The module fetches a parameter-storage specification template via a `data.http` resource and renders it through `data.external` using a gomplate shell command that injects the `NRN` environment variable, emitting the result as a JSON string that `locals` decode into the provider specification fields. It then creates a single `nullplatform_provider_specification` (name, icon, description, category, allow_dimensions, schema) whose `visible_to` is computed from `var.nrn`, the per-instance NRNs, and any `extra_visible_to_nrns`. For every entry in `var.instances`, it instantiates the remote `scope_configuration` module (pinned to a fixed ref) to register a provider config against that instance's NRN and dimensions, passing the caller-shaped `attributes` object through unchanged. The instance modules `depend_on` the provider specification to enforce that the spec exists before any instance is registered.

## Features

- Creates a nullplatform_provider_specification from a remotely fetched and gomplate-rendered JSON template
- Resolves specification fields (name, icon, description, category, allow_dimensions, schema) from the rendered template rather than hardcoding them
- Registers multiple provider instances via the scope_configuration module, one per entry in `var.instances`, each with its own NRN and dimensions
- Passes a provider-specific `attributes` object per instance so each caller matches its own provider schema (e.g. Parameter Store sends setup.tier, Secrets Manager omits it)
- Computes `visible_to` from the anchor NRN, every instance NRN, and optional extra NRNs to support cross-account visibility sharing
- Exposes the specification ID plus per-instance provider config IDs keyed by instance identifier through a single output

## Basic Usage

```hcl
module "parameter_storage_definition" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/parameter_storage_definition?ref=v6.1.0"

  np_api_key    = "your-np-api-key"
  nrn           = "your-nrn"
  template_path = "parameters/providers/aws-secrets-manager/specs/install/aws-secrets-manager-configuration.json.tpl"

  instances = {
    prod = {
      nrn        = "organization=1:account=2:namespace=3"
      dimensions = { environment = "production" }
      attributes = {
        sensibility = { applies_to = ["secret"] }
        setup       = { kms_key_id = "alias/parameters-prod" }
      }
    }
  }
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.parameter_storage_definition.storage_configuration.specification_id
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
| <a name="provider_external"></a> [external](#provider\_external) | n/a |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | >= 0.0.95 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_parameter_storage_instance"></a> [parameter\_storage\_instance](#module\_parameter\_storage\_instance) | git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_configuration | v4.5.1 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_specification.parameter_storage_specification](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_specification) | resource |
| [external_external.parameter_storage_spec](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [http_http.parameter_storage_spec_template](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_nrn"></a> [nrn](#input\_nrn) | NRN where the provider specification is anchored (the top-level scope it belongs to). | `string` | n/a | yes |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | nullplatform API key used by the upstream scope\_configuration module to register provider instances. | `string` | n/a | yes |
| <a name="input_template_path"></a> [template\_path](#input\_template\_path) | Path to the parameter storage specification template | `string` | n/a | yes |
| <a name="input_extra_visible_to_nrns"></a> [extra\_visible\_to\_nrns](#input\_extra\_visible\_to\_nrns) | Additional NRNs that should see the provider specification besides var.nrn and the per-instance NRNs. | `list(string)` | `[]` | no |
| <a name="input_instances"></a> [instances](#input\_instances) | Provider instances to create. Map key is a stable identifier (used in for\_each). Each entry carries its own NRN, dimensions, and a provider-specific `attributes` object that each caller shapes to match its provider specification schema (e.g. Parameter Store sends setup.tier, Secrets Manager omits it). | <pre>map(object({<br/>  nrn            = string<br/>  dimensions     = map(string)<br/>  attributes     = any<br/>  tags_selectors = optional(map(string), {})<br/>}))</pre> | `{}` | no |
| <a name="input_repository_parameter_storage_spec"></a> [repository\_parameter\_storage\_spec](#input\_repository\_parameter\_storage\_spec) | repository of parameter storage spec | `string` | `"https://raw.githubusercontent.com/nullplatform/parameters/refs/heads"` | no |
| <a name="input_repository_parameter_storage_spec_branch"></a> [repository\_parameter\_storage\_spec\_branch](#input\_repository\_parameter\_storage\_spec\_branch) | branch reference of parameter storage spec | `string` | `"main"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_storage_configuration"></a> [storage\_configuration](#output\_storage\_configuration) | Provider specification ID plus the per-instance provider configs (id, nrn, dimensions), keyed by instance key. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "parameter_storage_definition",
  "description": "Provisions a nullplatform parameter-storage provider specification by fetching and rendering a gomplate template from a remote repository, then registers one or more provider instances (per NRN and dimensions) via the upstream scope_configuration module",
  "architecture": "The module fetches a parameter-storage specification template via a `data.http` resource and renders it through `data.external` using a gomplate shell command that injects the `NRN` environment variable, emitting the result as a JSON string that `locals` decode into the provider specification fields. It then creates a single `nullplatform_provider_specification` (name, icon, description, category, allow_dimensions, schema) whose `visible_to` is computed from `var.nrn`, the per-instance NRNs, and any `extra_visible_to_nrns`. For every entry in `var.instances`, it instantiates the remote `scope_configuration` module (pinned to a fixed ref) to register a provider config against that instance's NRN and dimensions, passing the caller-shaped `attributes` object through unchanged. The instance modules `depend_on` the provider specification to enforce that the spec exists before any instance is registered.",
  "features": [
    "Creates a nullplatform_provider_specification from a remotely fetched and gomplate-rendered JSON template",
    "Resolves specification fields (name, icon, description, category, allow_dimensions, schema) from the rendered template rather than hardcoding them",
    "Registers multiple provider instances via the scope_configuration module, one per entry in var.instances, each with its own NRN and dimensions",
    "Passes a provider-specific attributes object per instance so each caller matches its own provider schema (e.g. Parameter Store sends setup.tier, Secrets Manager omits it)",
    "Computes visible_to from the anchor NRN, every instance NRN, and optional extra NRNs to support cross-account visibility sharing",
    "Exposes the specification ID plus per-instance provider config IDs keyed by instance identifier through a single output"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "NRN where the provider specification is anchored (the top-level scope it belongs to).",
      "required": true
    },
    {
      "name": "np_api_key",
      "description": "nullplatform API key used by the upstream scope_configuration module to register provider instances.",
      "required": true
    },
    {
      "name": "template_path",
      "description": "Path to the parameter storage specification template",
      "required": true
    },
    {
      "name": "extra_visible_to_nrns",
      "description": "Additional NRNs that should see the provider specification besides var.nrn and the per-instance NRNs.",
      "required": false
    },
    {
      "name": "instances",
      "description": "Provider instances to create. Map key is a stable identifier (used in for_each). Each entry carries its own NRN, dimensions, and a provider-specific attributes object that each caller shapes to match its provider specification schema.",
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
    "storage_configuration"
  ]
}
END_AI_METADATA -->
