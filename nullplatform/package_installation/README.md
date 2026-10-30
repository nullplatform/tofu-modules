# Module: package_installation

## Description

Installs a versioned nullplatform package at a specified NRN scope and exposes its service specifications for downstream consumption

## Architecture

The module uses a `nullplatform_package` data source to resolve the exact package revision by slug and semver version visible at the target NRN. A `nullplatform_package_installation` resource pins that revision as the default for new services and scopes, optionally scoping visibility via `visible_to`. A conditional `nullplatform_service_specification` data source then reads the single service specification from the installed revision using the installation ID as an implicit dependency gate. Outputs expose the installation ID, revision ID, installed version, components bill of materials, and derived service specification identifiers.

## Features

- Resolves a nullplatform package by slug and exact semver using a data source lookup scoped to the installing NRN
- Creates a nullplatform_package_installation resource that pins the resolved revision as the default for new services and scopes
- Enforces strict semver format (X.Y.Z without leading v) on the package version input via validation
- Exposes service specification ID and slug outputs compatible with service_definition and scope_definition module interfaces
- Reports missing optional provider requirements detected at installation time
- Supports configurable visibility scoping so specifications are usable only within designated NRN subtrees

## Basic Usage

```hcl
module "package_installation" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/package_installation?ref=v9.8.0"

  nrn             = "your-nrn"
  package_slug    = "your-package-slug"
  package_version = "your-package-version"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.package_installation.installation_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.110 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.110 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_package_installation.this](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/package_installation) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_nrn"></a> [nrn](#input\_nrn) | NRN of the installing organization where the package is installed (an organization, account, namespace or application). The package is looked up as visible there. | `string` | n/a | yes |
| <a name="input_package_slug"></a> [package\_slug](#input\_package\_slug) | Slug of the package to install. | `string` | n/a | yes |
| <a name="input_package_version"></a> [package\_version](#input\_package\_version) | Exact semver of the package revision to install (X.Y.Z, without a leading v). New services and scopes are born with it. | `string` | n/a | yes |
| <a name="input_visible_to"></a> [visible\_to](#input\_visible\_to) | Where inside the installing organization the package's specifications are usable: these NRNs and everything below them. Null uses [nrn]. Every entry must be under the installing organization. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_components"></a> [components](#output\_components) | Bill of materials of the installed revision. How the installing organization finds the resources of a package it does not own. |
| <a name="output_installation_id"></a> [installation\_id](#output\_installation\_id) | ID of the package installation. |
| <a name="output_installed_version"></a> [installed\_version](#output\_installed\_version) | Semver of the installed package revision. |
| <a name="output_missing_optional_requirements"></a> [missing\_optional\_requirements](#output\_missing\_optional\_requirements) | Optional providers the package can use that were not configured at nrn or above it when it was installed. |
| <a name="output_package_default_version"></a> [package\_default\_version](#output\_package\_default\_version) | Same as installed\_version: the version new services and scopes are born with. |
| <a name="output_package_id"></a> [package\_id](#output\_package\_id) | ID of the installed package. |
| <a name="output_revision_id"></a> [revision\_id](#output\_revision\_id) | ID of the installed package revision: the one new services and scopes are born with. |
| <a name="output_service_specification_id"></a> [service\_specification\_id](#output\_service\_specification\_id) | ID of the package's service specification. Null when the revision pins more than one. |
| <a name="output_service_specification_ids"></a> [service\_specification\_ids](#output\_service\_specification\_ids) | IDs of the service specifications in the installed revision. They are readable at nrn once the installation exists: depend on installation\_id before reading them. |
| <a name="output_service_specification_slug"></a> [service\_specification\_slug](#output\_service\_specification\_slug) | Slug of the package's service specification: what agent channels filter on. Null when the revision pins more than one. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "package_installation",
  "description": "Installs a versioned nullplatform package at a specified NRN scope and exposes its service specifications for downstream consumption",
  "architecture": "The module uses a `nullplatform_package` data source to resolve the exact package revision by slug and semver version visible at the target NRN. A `nullplatform_package_installation` resource pins that revision as the default for new services and scopes, optionally scoping visibility via `visible_to`. A conditional `nullplatform_service_specification` data source then reads the single service specification from the installed revision using the installation ID as an implicit dependency gate. Outputs expose the installation ID, revision ID, installed version, components bill of materials, and derived service specification identifiers.",
  "features": [
    "Resolves a nullplatform package by slug and exact semver using a data source lookup scoped to the installing NRN",
    "Creates a nullplatform_package_installation resource that pins the resolved revision as the default for new services and scopes",
    "Enforces strict semver format (X.Y.Z without leading v) on the package version input via validation",
    "Exposes service specification ID and slug outputs compatible with service_definition and scope_definition module interfaces",
    "Reports missing optional provider requirements detected at installation time",
    "Supports configurable visibility scoping so specifications are usable only within designated NRN subtrees"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "NRN of the installing organization where the package is installed (an organization, account, namespace or application). The package is looked up as visible there.",
      "required": true
    },
    {
      "name": "package_slug",
      "description": "Slug of the package to install.",
      "required": true
    },
    {
      "name": "package_version",
      "description": "Exact semver of the package revision to install (X.Y.Z, without a leading v). New services and scopes are born with it.",
      "required": true
    },
    {
      "name": "visible_to",
      "description": "Where inside the installing organization the package's specifications are usable: these NRNs and everything below them. Null uses [nrn]. Every entry must be under the installing organization.",
      "required": false
    }
  ],
  "outputs": [
    "installation_id",
    "package_id",
    "revision_id",
    "installed_version",
    "missing_optional_requirements",
    "components",
    "service_specification_ids",
    "service_specification_id",
    "service_specification_slug",
    "package_default_version"
  ],
  "hash": "523589665aa2aa0a8c67767a6256a8ac"
}
END_AI_METADATA -->
