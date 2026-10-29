# Module: package_installation

## Description

Installs a versioned nullplatform package at a specified NRN scope, pinning new services and scopes to a specific semver revision

## Architecture

The module uses a `nullplatform_package` data source to look up a package by slug and version as visible at the target NRN, resolving the exact revision ID to pin. A `nullplatform_package_installation` resource is then created, binding the package to the specified NRN with the resolved revision set as the default for new services and scopes. The `visible_to` input controls which child NRNs within the installing organization can use the package's specifications. Outputs expose the installation ID, package ID, revision ID, installed version, missing optional requirements, and a filtered list of service specification IDs from the package's bill of materials.

## Features

- Looks up a nullplatform package by slug and semver version as visible at the target NRN
- Creates a nullplatform_package_installation resource pinning new services and scopes to an exact revision
- Validates package_version as a strict X.Y.Z semver format without a leading v
- Controls visibility scope of installed package specifications via configurable NRN list
- Exposes service specification IDs filtered from the package bill of materials for downstream dependencies
- Outputs missing optional requirements to surface unconfigured provider gaps at install time

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
| <a name="output_package_id"></a> [package\_id](#output\_package\_id) | ID of the installed package. |
| <a name="output_revision_id"></a> [revision\_id](#output\_revision\_id) | ID of the installed package revision: the one new services and scopes are born with. |
| <a name="output_service_specification_ids"></a> [service\_specification\_ids](#output\_service\_specification\_ids) | IDs of the service specifications in the installed revision. They are readable at nrn once the installation exists: depend on installation\_id before reading them. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "package_installation",
  "description": "Installs a versioned nullplatform package at a specified NRN scope, pinning new services and scopes to a specific semver revision",
  "architecture": "The module uses a `nullplatform_package` data source to look up a package by slug and version as visible at the target NRN, resolving the exact revision ID to pin. A `nullplatform_package_installation` resource is then created, binding the package to the specified NRN with the resolved revision set as the default for new services and scopes. The `visible_to` input controls which child NRNs within the installing organization can use the package's specifications. Outputs expose the installation ID, package ID, revision ID, installed version, missing optional requirements, and a filtered list of service specification IDs from the package's bill of materials.",
  "features": [
    "Looks up a nullplatform package by slug and semver version as visible at the target NRN",
    "Creates a nullplatform_package_installation resource pinning new services and scopes to an exact revision",
    "Validates package_version as a strict X.Y.Z semver format without a leading v",
    "Controls visibility scope of installed package specifications via configurable NRN list",
    "Exposes service specification IDs filtered from the package bill of materials for downstream dependencies",
    "Outputs missing optional requirements to surface unconfigured provider gaps at install time"
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
    "service_specification_ids"
  ],
  "hash": "6b60f547b5804a3b5f8e6d89b68496a6"
}
END_AI_METADATA -->
