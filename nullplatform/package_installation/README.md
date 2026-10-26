# Module: package_installation

## Description

Installs a nullplatform package in an organization: finds the package by where it is visible (it is usually owned by another organization that published it for every organization) and creates the installation that pins the revision new services and scopes are born with.

## Architecture

The module reads the package with `data.nullplatform_package`, filtering by `visible_at = nrn`, `slug` and the exact `version` to install, so it finds packages owned elsewhere and published with `visible_to = ["organization=*"]`. It then creates one `nullplatform_package_installation` at `nrn` whose `default_revision_id` is the revision of that version. The installation never follows the publisher's default afterwards: upgrading is changing `package_version`, and only new services and scopes move; existing ones keep their revision until they are moved one by one.

It also exposes the revision's bill of materials. An installing organization does not own the package's resources, and the BOM is how it finds them: `service_specification_ids` is what a scope type has to point at.

## Features

- Finds a package by visibility, not by owner, so packages published for every organization can be installed
- Pins the installation to the exact revision of `package_version`, independent of the publisher's default
- Restricts where the package is usable inside the organization with `visible_to`
- Reports the optional providers the package can use and the organization has not configured
- Exposes the installed revision's bill of materials and its service specification IDs

## Basic Usage

```hcl
module "package_installation" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/package_installation?ref=v9.5.0"

  nrn             = "organization=123:account=456"
  package_slug    = "my-package"
  package_version = "1.2.3"
}
```

Services and scopes have their own modules on top of this one, which also create the agent channel and, for scopes, the pieces each organization owns: [`service_package_installation`](../service_package_installation) and [`scope_package_installation`](../scope_package_installation).

## Using Outputs

```hcl
# The scope type of a scope package points at the package's specification
resource "nullplatform_scope_type" "this" {
  nrn           = "organization=123:account=456"
  name          = "My Scope"
  provider_type = "service"
  provider_id   = one(module.package_installation.service_specification_ids)
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
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | >= 0.0.110 |

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
