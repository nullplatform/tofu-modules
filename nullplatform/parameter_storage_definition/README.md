# Module: parameter_storage_definition

## Description

Provisions a nullplatform parameter-storage provider specification by fetching and rendering a gomplate template from a remote repository. It creates the specification only; instances are registered separately with the parameter_storage_configuration module

## Architecture

The module fetches a parameter-storage specification template via a `data.http` resource and renders it through `data.external` using a gomplate shell command that injects the `NRN` environment variable, emitting the result as a JSON string that `locals` decode into the provider specification fields. It then creates a single `nullplatform_provider_specification` (name, icon, description, category, allow_dimensions, schema) whose `visible_to` is computed from `var.nrn` plus any `extra_visible_to_nrns`. It exposes the specification `slug` and `id` so callers can register instances against it — one per NRN and dimension set — using the companion `parameter_storage_configuration` module with their own `for_each`.

## Features

- Creates a nullplatform_provider_specification from a remotely fetched and gomplate-rendered JSON template
- Resolves specification fields (name, icon, description, category, allow_dimensions, schema) from the rendered template rather than hardcoding them
- Computes `visible_to` from the anchor NRN plus optional extra NRNs to support cross-account visibility sharing
- Exposes the specification `slug`, `id`, and `name` so callers can wire instances into parameter_storage_configuration

## Basic Usage

```hcl
module "parameter_storage_definition" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/parameter_storage_definition?ref=v6.1.0"

  np_api_key    = "your-np-api-key"
  nrn           = "organization=1"
  template_path = "parameters/providers/aws-secrets-manager/specs/install/aws-secrets-manager-configuration.json.tpl"

  # Make the spec visible at every NRN where you will anchor an instance.
  extra_visible_to_nrns = [for i in local.instances : i.nrn]
}
```

Register the instances separately with `parameter_storage_configuration`, driving multiplicity with `for_each`:

```hcl
module "parameter_storage_configuration" {
  source   = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/parameter_storage_configuration?ref=v6.1.0"
  for_each = local.instances

  np_api_key                  = "your-np-api-key"
  nrn                         = each.value.nrn
  provider_specification_slug = module.parameter_storage_definition.slug
  dimensions                  = each.value.dimensions
  attributes                  = each.value.attributes
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
| <a name="provider_external"></a> [external](#provider\_external) | n/a |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | >= 0.0.95 |

## Modules

No modules.

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
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | nullplatform API key. Kept for interface consistency across the parameter-storage modules; the provider is configured at the root. | `string` | n/a | yes |
| <a name="input_template_path"></a> [template\_path](#input\_template\_path) | Path to the parameter storage specification template | `string` | n/a | yes |
| <a name="input_extra_visible_to_nrns"></a> [extra\_visible\_to\_nrns](#input\_extra\_visible\_to\_nrns) | Additional NRNs that should see the provider specification besides var.nrn. Callers registering instances at other NRNs (via parameter\_storage\_configuration) should list those NRNs here so the spec is visible where the instances are anchored. | `list(string)` | `[]` | no |
| <a name="input_repository_parameter_storage_spec"></a> [repository\_parameter\_storage\_spec](#input\_repository\_parameter\_storage\_spec) | repository of parameter storage spec | `string` | `"https://raw.githubusercontent.com/nullplatform/parameters-provider/refs/heads"` | no |
| <a name="input_repository_parameter_storage_spec_branch"></a> [repository\_parameter\_storage\_spec\_branch](#input\_repository\_parameter\_storage\_spec\_branch) | branch reference of parameter storage spec | `string` | `"main"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | Name of the provider specification, resolved from the rendered template. |
| <a name="output_slug"></a> [slug](#output\_slug) | Slug of the provider specification, resolved from the rendered template. Pass this to parameter\_storage\_configuration.provider\_specification\_slug. |
| <a name="output_specification_id"></a> [specification\_id](#output\_specification\_id) | ID of the created parameter-storage provider specification. |
<!-- END_TF_DOCS -->
