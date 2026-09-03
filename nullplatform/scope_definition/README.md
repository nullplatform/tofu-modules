# Module: scope_definition

## Description

Provisions a nullplatform scope definition by fetching and rendering service specification, scope type, and action specification templates from a remote repository, then wiring all resources together with metrics and logging provider configuration

## Architecture

The module uses `data.http` to fetch Jinja/gomplate templates for service specs, scope types, and action specs from a configurable GitHub raw URL, then processes them via `data.external` shell programs invoking gomplate and jq. Core nullplatform resources (`nullplatform_service_specification`, `nullplatform_scope_type`, `nullplatform_action_specification`) are created in dependency order using the rendered template outputs, with IDs flowing downstream into scope type and action spec resources. A `null_resource` provisioner runs `np nrn patch` to register external metrics and logging providers against the NRN, and an optional `nullplatform_provider_specification` is created when `create_scope_configuration` is enabled. When `var.package` is set, `nullplatform_package` and `nullplatform_artifact` resources are also created to publish versioned package revisions.

## Features

- Fetches and renders service specification, scope type, and action specification templates from a remote GitHub repository using gomplate
- Creates nullplatform_service_specification with configurable visibility, selectors, and attributes derived from rendered templates
- Creates nullplatform_scope_type linked to the service specification with provider type resolved from the scope type template
- Creates nullplatform_action_specification resources for each action defined in the service spec or explicitly listed via action_spec_names
- Patches the NRN with external metrics and logging provider configuration using the np CLI via null_resource provisioner
- Optionally creates nullplatform_provider_specification from a scope-configuration template when create_scope_configuration is enabled
- Optionally publishes versioned nullplatform_package and nullplatform_artifact resources to pin scope definitions to immutable revisions

## Basic Usage

```hcl
module "scope_definition" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_definition?ref=v8.0.0"

  np_api_key = "your-np-api-key"
  nrn        = "your-nrn"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.scope_definition.service_specification_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.3.5 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2.4 |
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.99 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.5 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.5.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.4 |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.99 |

## Resources

| Name | Type |
|------|------|
| [null_resource.nrn_patch](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [nullplatform_action_specification.from_templates](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/action_specification) | resource |
| [nullplatform_artifact.package](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/artifact) | resource |
| [nullplatform_package.this](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/package) | resource |
| [nullplatform_provider_specification.from_scope_configuration](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_specification) | resource |
| [nullplatform_scope_type.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/scope_type) | resource |
| [nullplatform_service_specification.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/service_specification) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action_spec_names"></a> [action\_spec\_names](#input\_action\_spec\_names) | List of action specification template names to fetch and create for scope<br/>operations. Default `null` -> use the `available_actions` array from the<br/>scope's `service-spec.json.tpl` (fetched via `repository_service_spec` /<br/>`service_path`). Set this explicitly only when the spec's list is wrong<br/>for your case or the spec predates the `available_actions` field. | `list(string)` | `null` | no |
| <a name="input_create_scope_configuration"></a> [create\_scope\_configuration](#input\_create\_scope\_configuration) | Whether to fetch and apply scope-configuration.json.tpl from the template repo. Set to true only if the file exists for this scope. | `bool` | `false` | no |
| <a name="input_external_logging_provider"></a> [external\_logging\_provider](#input\_external\_logging\_provider) | Name of the external log provider | `string` | `"external"` | no |
| <a name="input_external_metrics_provider"></a> [external\_metrics\_provider](#input\_external\_metrics\_provider) | Name of the external metrics provider for monitoring integration | `string` | `"externalmetrics"` | no |
| <a name="input_extra_visible_to_nrns"></a> [extra\_visible\_to\_nrns](#input\_extra\_visible\_to\_nrns) | Additional NRNs to add to `visible_to` of the `nullplatform_service_specification`<br/>and `nullplatform_provider_specification` created by this module. The base<br/>visible\_to (the spec template's value for the service\_spec, and `[var.nrn]`<br/>for the provider\_spec) is preserved; this list is appended.<br/><br/>Use case: share a scope\_definition with sibling accounts in the same<br/>organization without duplicating it per account. Example:<br/><br/>  extra\_visible\_to\_nrns = ["organization=1636958496"]<br/><br/>makes the spec consumable by every account under that organization.<br/>Default = [] (no extra visibility, backwards compatible). | `list(string)` | `[]` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key used for executing local commands (e.g., 'np nrn patch') | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Unique NRN identifier of the environment or resource in nullplatform | `string` | n/a | yes |
| <a name="input_package"></a> [package](#input\_package) | Register this scope definition as a versioned PACKAGE. When set, the module<br/>publishes a package revision whose bill of materials pins the service<br/>specification, every action specification, and the artifacts you list —<br/>so scopes bind to an immutable revision and later template changes never<br/>mutate what already runs.<br/><br/>artifacts: each entry does ONE of:<br/>  • register a new artifact revision — set `meta` (JSON-able object, e.g.<br/>    { registry = "ghcr.io", repository = "acme/img", digest = "sha256:…" });<br/>  • look up one registered elsewhere BY IDENTITY (no ids needed) — set<br/>    `lookup = true` + `meta` with the identity fields (e.g. registry +<br/>    repository for oci\_image, or url for git\_repository); add the<br/>    type's own per-revision field to pin a specific revision (digest,<br/>    formatted "sha256:<64-hex>", for oci\_image; reference, e.g. a tag,<br/>    for git\_repository — the API rejects the other type's field name),<br/>    otherwise the latest revision is used;<br/>  • pin explicit ids — set `resource_id` + `resource_revision_id`.<br/><br/>For an "oci\_image" artifact (the default type), `name` defaults to<br/>"worker-image" and meta.registry/meta.repository default to<br/>var.package\_oci\_default\_registry/var.package\_oci\_default\_repository —<br/>the platform's own container-scope worker image — when omitted from<br/>`meta`. Only meta.digest needs setting on every release; every other<br/>artifact type gets no meta defaults (their meta shape is unrelated to a<br/>container registry).<br/><br/>Null (the default) keeps the classic module behavior — no package. | <pre>object({<br/>    slug       = optional(string)          # default: the service specification slug<br/>    name       = optional(string)          # default: var.service_spec_name<br/>    version    = string                    # semver of the revision this configuration publishes<br/>    default    = optional(bool, true)      # promote each published revision to the package default<br/>    tags       = optional(map(string), {}) # release tags: name => version (requires an API with the package release-tag routes)<br/>    visible_to = optional(list(string))    # default: [var.nrn]<br/>    artifacts = optional(list(object({<br/>      name                 = optional(string, "worker-image")<br/>      type                 = optional(string, "oci_image") # oci_image | oras_artifact | git_repository | blob<br/>      meta                 = optional(any)                 # register (lookup=false) or find (lookup=true)<br/>      lookup               = optional(bool, false)         # true: resolve an EXISTING artifact by meta identity<br/>      resource_id          = optional(string)              # …or pin explicit ids<br/>      resource_revision_id = optional(string)<br/>    })), [])<br/>  })</pre> | `null` | no |
| <a name="input_package_oci_default_registry"></a> [package\_oci\_default\_registry](#input\_package\_oci\_default\_registry) | Default meta.registry for an oci\_image package artifact whose own meta omits it. See var.package's artifacts docs. | `string` | `"public.ecr.aws"` | no |
| <a name="input_package_oci_default_repository"></a> [package\_oci\_default\_repository](#input\_package\_oci\_default\_repository) | Default meta.repository for an oci\_image package artifact whose own meta omits it — the platform's own container-scope worker image. See var.package's artifacts docs. | `string` | `"nullplatform/scopes/containers"` | no |
| <a name="input_repo_path"></a> [repo\_path](#input\_repo\_path) | Base path to the repository used as context for gomplate template rendering | `string` | `"/root/.np/nullplatform/scopes"` | no |
| <a name="input_repository_action_templates"></a> [repository\_action\_templates](#input\_repository\_action\_templates) | repository of action template | `string` | `"https://raw.githubusercontent.com/nullplatform/scopes/refs/heads"` | no |
| <a name="input_repository_action_templates_branch"></a> [repository\_action\_templates\_branch](#input\_repository\_action\_templates\_branch) | branch reference of action template | `string` | `"main"` | no |
| <a name="input_repository_scope_template"></a> [repository\_scope\_template](#input\_repository\_scope\_template) | repository of scope template | `string` | `"https://raw.githubusercontent.com/nullplatform/scopes/refs/heads"` | no |
| <a name="input_repository_scope_template_branch"></a> [repository\_scope\_template\_branch](#input\_repository\_scope\_template\_branch) | branch reference of scope template | `string` | `"main"` | no |
| <a name="input_repository_service_spec"></a> [repository\_service\_spec](#input\_repository\_service\_spec) | repository of service spec | `string` | `"https://raw.githubusercontent.com/nullplatform/scopes/refs/heads"` | no |
| <a name="input_repository_service_spec_branch"></a> [repository\_service\_spec\_branch](#input\_repository\_service\_spec\_branch) | branch reference of service spec | `string` | `"main"` | no |
| <a name="input_scope_configuration_name_override"></a> [scope\_configuration\_name\_override](#input\_scope\_configuration\_name\_override) | Optional override for the `name` of the `nullplatform_provider_specification`<br/>created from `scope-configuration.json.tpl` (when `create_scope_configuration = true`).<br/><br/>Default `null` -> use the `name` field from the template, preserving<br/>current behavior. Set to a string when consuming this module from a<br/>setup where the template's name would collide with an existing<br/>org-visible provider\_specification (e.g., a hub/principal account<br/>already registered the canonical "Static Files" / "AWS Lambda" name<br/>org-wide, and a sibling spoke account needs an account-local copy<br/>with a distinct name).<br/><br/>The `slug` is auto-derived server-side from the name; pass a name<br/>that will produce a unique slug per the API uniqueness constraints<br/>(name must be unique across `visible_to` overlaps in the same org).<br/><br/>Example:<br/><br/>  scope\_configuration\_name\_override = "Static Files Galicia 3"<br/><br/>Default = null (no override, backwards compatible). | `string` | `null` | no |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path within the repository where the service specification files are stored (e.g., 'services/api') | `string` | `"k8s"` | no |
| <a name="input_service_spec_description"></a> [service\_spec\_description](#input\_service\_spec\_description) | Description of the created service or associated scope type | `string` | `"Docker containers on pods"` | no |
| <a name="input_service_spec_name"></a> [service\_spec\_name](#input\_service\_spec\_name) | Name of the service that will be created from the specification template | `string` | `"Containers"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_actions_created"></a> [actions\_created](#output\_actions\_created) | Map of all action specifications created from templates. |
| <a name="output_package_artifacts"></a> [package\_artifacts](#output\_package\_artifacts) | Artifacts registered by this module: name => { resource\_id, resource\_revision\_id }. |
| <a name="output_package_default_version"></a> [package\_default\_version](#output\_package\_default\_version) | The package's default version after apply, or null. |
| <a name="output_package_id"></a> [package\_id](#output\_package\_id) | ID of the package registered from this scope definition, or null when packaging is disabled. |
| <a name="output_package_published_revision_id"></a> [package\_published\_revision\_id](#output\_package\_published\_revision\_id) | Revision UUID published for the configured package version, or null. |
| <a name="output_provider_specification_id"></a> [provider\_specification\_id](#output\_provider\_specification\_id) | The ID of the created provider specification, or null if scope configuration was not fetched |
| <a name="output_provider_specification_slug"></a> [provider\_specification\_slug](#output\_provider\_specification\_slug) | The slug of the created provider specification, or null if scope configuration was not fetched |
| <a name="output_scope_configuration"></a> [scope\_configuration](#output\_scope\_configuration) | Parsed scope configuration from scope-configuration.json.tpl, or null if not fetched |
| <a name="output_scope_type_id"></a> [scope\_type\_id](#output\_scope\_type\_id) | ID of the scope type created from the template. |
| <a name="output_service_slug"></a> [service\_slug](#output\_service\_slug) | Slug (unique name) of the service specification created in nullplatform. |
| <a name="output_service_specification_id"></a> [service\_specification\_id](#output\_service\_specification\_id) | ID of the service specification created in nullplatform. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "scope_definition",
  "description": "Provisions a nullplatform scope definition by fetching and rendering service specification, scope type, and action specification templates from a remote repository, then wiring all resources together with metrics and logging provider configuration",
  "architecture": "The module uses `data.http` to fetch Jinja/gomplate templates for service specs, scope types, and action specs from a configurable GitHub raw URL, then processes them via `data.external` shell programs invoking gomplate and jq. Core nullplatform resources (`nullplatform_service_specification`, `nullplatform_scope_type`, `nullplatform_action_specification`) are created in dependency order using the rendered template outputs, with IDs flowing downstream into scope type and action spec resources. A `null_resource` provisioner runs `np nrn patch` to register external metrics and logging providers against the NRN, and an optional `nullplatform_provider_specification` is created when `create_scope_configuration` is enabled. When `var.package` is set, `nullplatform_package` and `nullplatform_artifact` resources are also created to publish versioned package revisions.",
  "features": [
    "Fetches and renders service specification, scope type, and action specification templates from a remote GitHub repository using gomplate",
    "Creates nullplatform_service_specification with configurable visibility, selectors, and attributes derived from rendered templates",
    "Creates nullplatform_scope_type linked to the service specification with provider type resolved from the scope type template",
    "Creates nullplatform_action_specification resources for each action defined in the service spec or explicitly listed via action_spec_names",
    "Patches the NRN with external metrics and logging provider configuration using the np CLI via null_resource provisioner",
    "Optionally creates nullplatform_provider_specification from a scope-configuration template when create_scope_configuration is enabled",
    "Optionally publishes versioned nullplatform_package and nullplatform_artifact resources to pin scope definitions to immutable revisions"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "Unique NRN identifier of the environment or resource in nullplatform",
      "required": true
    },
    {
      "name": "np_api_key",
      "description": "Nullplatform API key used for executing local commands (e.g., 'np nrn patch')",
      "required": true
    },
    {
      "name": "package",
      "description": "",
      "required": false
    },
    {
      "name": "repository_service_spec",
      "description": "repository of service spec",
      "required": false
    },
    {
      "name": "repository_service_spec_branch",
      "description": "branch reference of service spec",
      "required": false
    },
    {
      "name": "repository_scope_template",
      "description": "repository of scope template",
      "required": false
    },
    {
      "name": "repository_scope_template_branch",
      "description": "branch reference of scope template",
      "required": false
    },
    {
      "name": "repository_action_templates",
      "description": "repository of action template",
      "required": false
    },
    {
      "name": "repository_action_templates_branch",
      "description": "branch reference of action template",
      "required": false
    },
    {
      "name": "service_path",
      "description": "Path within the repository where the service specification files are stored (e.g., 'services/api')",
      "required": false
    },
    {
      "name": "repo_path",
      "description": "Base path to the repository used as context for gomplate template rendering",
      "required": false
    },
    {
      "name": "action_spec_names",
      "description": "",
      "required": false
    },
    {
      "name": "service_spec_name",
      "description": "Name of the service that will be created from the specification template",
      "required": false
    },
    {
      "name": "service_spec_description",
      "description": "Description of the created service or associated scope type",
      "required": false
    },
    {
      "name": "external_metrics_provider",
      "description": "Name of the external metrics provider for monitoring integration",
      "required": false
    },
    {
      "name": "external_logging_provider",
      "description": "Name of the external log provider",
      "required": false
    },
    {
      "name": "create_scope_configuration",
      "description": "Whether to fetch and apply scope-configuration.json.tpl from the template repo. Set to true only if the file exists for this scope.",
      "required": false
    },
    {
      "name": "scope_configuration_name_override",
      "description": "",
      "required": false
    },
    {
      "name": "extra_visible_to_nrns",
      "description": "",
      "required": false
    },
    {
      "name": "package_oci_default_registry",
      "description": "Default meta.registry for an oci_image package artifact whose own meta omits it. See var.package's artifacts docs.",
      "required": false
    },
    {
      "name": "package_oci_default_repository",
      "description": "Default meta.repository for an oci_image package artifact whose own meta omits it — the platform's own container-scope worker image. See var.package's artifacts docs.",
      "required": false
    }
  ],
  "outputs": [
    "service_specification_id",
    "service_slug",
    "scope_type_id",
    "actions_created",
    "scope_configuration",
    "provider_specification_id",
    "provider_specification_slug",
    "package_id",
    "package_published_revision_id",
    "package_default_version",
    "package_artifacts"
  ],
  "hash": "25f527f71a7a022a2aaa44bd891e2688"
}
END_AI_METADATA -->
