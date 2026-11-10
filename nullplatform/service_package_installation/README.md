# Module: service_package_installation

## Description

Installs a published nullplatform service package and wires an agent notification channel that routes service actions to the package worker

## Architecture

The module composes two child modules: `package_installation` creates the package installation resource binding the specified semver to the target organization NRN with visibility controls, and `service_definition_agent_association` creates an agent notification channel that routes package-exec actions to the package worker filtered by agent tag selectors. The agent channel depends on the installation completing first, ensuring the service specification is reachable before routing begins. Outputs surface the installation ID, installed version, service specification identifiers, and the notification channel ID from the respective child modules.

## Features

- Creates a package installation binding an exact semver revision to a nullplatform organization NRN
- Configures visibility scope for installed services within the installing organization
- Creates an agent notification channel routing service and telemetry actions to the package worker
- Enforces agent tag selector filtering so the channel targets only matching worker agents
- Coalesces service specification slug from package slug when not explicitly provided
- Supports custom channel entrypoint commands for package worker invocation
- Outputs installation ID, installed version, service specification metadata, and notification channel ID

## Basic Usage

```hcl
module "service_package_installation" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/service_package_installation?ref=v9.12.0"

  agent_tags_selectors = "your-agent-tags-selectors"
  nrn                  = "your-nrn"
  package_slug         = "your-package-slug"
  package_version      = "your-package-version"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.service_package_installation.installation_id
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
| <a name="output_notification_channel_id"></a> [notification\_channel\_id](#output\_notification\_channel\_id) | ID of the agent notification channel. |
| <a name="output_service_specification_id"></a> [service\_specification\_id](#output\_service\_specification\_id) | ID of the package's service specification. |
| <a name="output_service_specification_slug"></a> [service\_specification\_slug](#output\_service\_specification\_slug) | Slug of the package's service specification. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "service_package_installation",
  "description": "Installs a published nullplatform service package and wires an agent notification channel that routes service actions to the package worker",
  "architecture": "The module composes two child modules: `package_installation` creates the package installation resource binding the specified semver to the target organization NRN with visibility controls, and `service_definition_agent_association` creates an agent notification channel that routes package-exec actions to the package worker filtered by agent tag selectors. The agent channel depends on the installation completing first, ensuring the service specification is reachable before routing begins. Outputs surface the installation ID, installed version, service specification identifiers, and the notification channel ID from the respective child modules.",
  "features": [
    "Creates a package installation binding an exact semver revision to a nullplatform organization NRN",
    "Configures visibility scope for installed services within the installing organization",
    "Creates an agent notification channel routing service and telemetry actions to the package worker",
    "Enforces agent tag selector filtering so the channel targets only matching worker agents",
    "Coalesces service specification slug from package slug when not explicitly provided",
    "Supports custom channel entrypoint commands for package worker invocation",
    "Outputs installation ID, installed version, service specification metadata, and notification channel ID"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "NRN of the installing organization where the service is installed (e.g. organization=123:account=456). The package is looked up as visible there, installed there, and the agent channel is created there.",
      "required": true
    },
    {
      "name": "package_slug",
      "description": "Slug of the service package to install.",
      "required": true
    },
    {
      "name": "package_version",
      "description": "Exact semver of the package revision to install (X.Y.Z, without a leading v). Service repositories pass the version of the tag their installation module is referenced at.",
      "required": true
    },
    {
      "name": "agent_tags_selectors",
      "description": "Tags that select the agent running the package worker (must match the agent's TAGS), e.g. { cluster = \\",
      "required": true
    },
    {
      "name": "visible_to",
      "description": "Where inside the installing organization the service can be used. Null uses [nrn]. Every entry must be under the installing organization.",
      "required": false
    },
    {
      "name": "service_specification_slug",
      "description": "Slug of the service specification the channel routes. Null uses package_slug, which is what a package published with service_definition gets.",
      "required": false
    },
    {
      "name": "channel_sources",
      "description": "Notification sources the agent channel listens to.",
      "required": false
    },
    {
      "name": "channel_description",
      "description": "Description of the agent channel. Null uses \\",
      "required": false
    },
    {
      "name": "entrypoint",
      "description": "Command the channel sends to the worker. Empty uses the module default (/app/packages/<package_slug>/entrypoint). worker-bridge images ignore it and run their baked NP_SCOPE_ENTRYPOINT.",
      "required": false
    }
  ],
  "outputs": [
    "installation_id",
    "installed_version",
    "service_specification_id",
    "service_specification_slug",
    "notification_channel_id"
  ],
  "hash": "802dc2ab8d7182c740a74a424edd55bf"
}
END_AI_METADATA -->
