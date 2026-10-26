# Module: service_package_installation

## Description

Installs a service package published by another organization and creates the agent channel that routes the service's actions to the package worker. Service repositories call it from their `installation/` module, next to their own cloud requirements.

## Architecture

The module composes [`package_installation`](../package_installation), which finds the package by visibility and pins the installation to `package_version`, with [`service_definition_agent_association`](../service_definition_agent_association) in worker-orchestrator mode: a `package-exec` channel to the package worker, filtered to the service specification slug (by default the package slug, which is what a package published with `service_definition` gets). The channel is created after the installation, because it routes nothing until the specification is reachable at `nrn`.

Cloud permissions are deliberately out of this module: each service repository creates them with its own requirements module (`specs/requirements/<cloud>`), so the same installation works on any cloud.

## Features

- Installs the service package at the version of the tag the caller references
- Creates the `package-exec` agent channel to the package worker, filtered to the service specification
- Uses a platform-managed credential for the channel (no API key to pass)
- Reports the optional providers the package can use and the organization has not configured

## Basic Usage

A service repository's `installation/main.tf`, referenced by its users at a release tag:

```hcl
locals {
  package_slug = "my-service"
  version      = trimspace(file("${path.module}/../../version.txt"))
}

module "requirements" {
  source = "../specs/requirements/aws"
  # ...
}

module "package" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/service_package_installation?ref=v9.5.0"

  nrn                  = var.nrn
  package_slug         = local.package_slug
  package_version      = local.version
  visible_to           = var.visible_to
  agent_tags_selectors = var.agent_tags_selectors
}
```

## Using Outputs

```hcl
output "installed_version" {
  value = module.package.installed_version
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.110 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_agent_channel"></a> [agent\_channel](#module\_agent\_channel) | ../service_definition_agent_association | n/a |
| <a name="module_installation"></a> [installation](#module\_installation) | ../package_installation | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_tags_selectors"></a> [agent\_tags\_selectors](#input\_agent\_tags\_selectors) | Tags that select the agent running the package worker (must match the agent's TAGS), e.g. { cluster = "runtime" }. | `map(string)` | n/a | yes |
| <a name="input_channel_description"></a> [channel\_description](#input\_channel\_description) | Description of the agent channel. Null uses "<package\_slug> package worker". | `string` | `null` | no |
| <a name="input_channel_sources"></a> [channel\_sources](#input\_channel\_sources) | Notification sources the agent channel listens to. | `list(string)` | <pre>[<br/>  "service",<br/>  "telemetry"<br/>]</pre> | no |
| <a name="input_entrypoint"></a> [entrypoint](#input\_entrypoint) | Command the channel sends to the worker. Empty uses the module default (/app/packages/<package\_slug>/entrypoint). worker-bridge images ignore it and run their baked NP\_SCOPE\_ENTRYPOINT. | `string` | `""` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | NRN of the installing organization where the service is installed (e.g. organization=123:account=456). The package is looked up as visible there, installed there, and the agent channel is created there. | `string` | n/a | yes |
| <a name="input_package_slug"></a> [package\_slug](#input\_package\_slug) | Slug of the service package to install. | `string` | n/a | yes |
| <a name="input_package_version"></a> [package\_version](#input\_package\_version) | Exact semver of the package revision to install (X.Y.Z, without a leading v). Service repositories pass the version of the tag their installation module is referenced at. | `string` | n/a | yes |
| <a name="input_service_specification_slug"></a> [service\_specification\_slug](#input\_service\_specification\_slug) | Slug of the service specification the channel routes. Null uses package\_slug, which is what a package published with service\_definition gets. | `string` | `null` | no |
| <a name="input_visible_to"></a> [visible\_to](#input\_visible\_to) | Where inside the installing organization the service can be used. Null uses [nrn]. Every entry must be under the installing organization. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_installation_id"></a> [installation\_id](#output\_installation\_id) | ID of the package installation. |
| <a name="output_installed_version"></a> [installed\_version](#output\_installed\_version) | Version new services are born with. |
| <a name="output_missing_optional_requirements"></a> [missing\_optional\_requirements](#output\_missing\_optional\_requirements) | Optional providers the package can use that were not configured at nrn or above it when it was installed. |
| <a name="output_notification_channel_id"></a> [notification\_channel\_id](#output\_notification\_channel\_id) | ID of the agent notification channel. |
<!-- END_TF_DOCS -->
