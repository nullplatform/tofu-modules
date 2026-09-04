# Module: service_definition

## Description

Provisions nullplatform service, action, and link specifications by fetching JSON templates from a remote Git repository (GitHub, GitLab, or Bitbucket) or local filesystem and registering them as versioned resources

## Architecture

The module uses data.http resources to fetch service-spec, action, and link JSON templates from a remote Git provider (GitHub, GitLab, or Bitbucket) using provider-specific raw URLs and auth headers, or reads them from the local filesystem when git_provider is 'local'. Parsed templates are fed into nullplatform_service_specification, nullplatform_action_specification, and nullplatform_link_specification resources, with action and link specifications depending on the service specification via explicit depends_on. When var.package is set, the module additionally creates nullplatform_package and nullplatform_artifact resources to register a versioned immutable package revision pinning all specifications and artifacts.

## Features

- Creates nullplatform_service_specification from a JSON template with configurable visibility, selectors, and dimensions
- Creates nullplatform_action_specification resources for each action template fetched from the repository
- Creates nullplatform_link_specification resources for each link template with scopes, assignability, and external config
- Fetches specification templates from GitHub, GitLab, or Bitbucket using provider-specific raw URLs and authentication headers
- Supports local filesystem template loading for offline or CI environments via git_provider = 'local'
- Registers versioned nullplatform_package and nullplatform_artifact resources when package configuration is provided
- Supports pinning to branches, tags, or raw commit SHAs via repository_ref_type and repository_branch variables

## Basic Usage

```hcl
module "service_definition" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/service_definition?ref=v7.3.1"

  nrn               = "your-nrn"
  repository_branch = "your-repository-branch"
  service_name      = "your-service-name"
  service_path      = "your-service-path"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.service_definition.service_specification_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.0 |
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_http"></a> [http](#provider\_http) | 3.5.0 |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.95 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_action_specification.from_templates](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/action_specification) | resource |
| [nullplatform_artifact.package](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/artifact) | resource |
| [nullplatform_link_specification.from_templates](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/link_specification) | resource |
| [nullplatform_package.this](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/package) | resource |
| [nullplatform_service_specification.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/service_specification) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_available_actions"></a> [available\_actions](#input\_available\_actions) | List of action template names to fetch from the service spec repository | `list(string)` | `[]` | no |
| <a name="input_available_links"></a> [available\_links](#input\_available\_links) | List of link template names to fetch from the service spec repository | `list(string)` | <pre>[<br/>  "connect"<br/>]</pre> | no |
| <a name="input_bitbucket_email"></a> [bitbucket\_email](#input\_bitbucket\_email) | Bitbucket account email, used only when git\_provider = "bitbucket". Set it when repository\_token is an Atlassian API token: those authenticate ONLY via HTTP Basic "email:api\_token" and return 401 with a Bearer header. Leave null when repository\_token is a Bitbucket workspace/repository access token, which is sent as a Bearer token. | `string` | `null` | no |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Key-value pairs for dimensions to be associated with the service specification | `map(string)` | `{}` | no |
| <a name="input_extra_visibile_to_nrns"></a> [extra\_visibile\_to\_nrns](#input\_extra\_visibile\_to\_nrns) | Additional NRNs that should have visibility to the created service specification | `list(string)` | `[]` | no |
| <a name="input_git_provider"></a> [git\_provider](#input\_git\_provider) | Git provider to fetch service specs from. Supported values: "github", "gitlab", "bitbucket", "local". | `string` | `"github"` | no |
| <a name="input_gitlab_host"></a> [gitlab\_host](#input\_gitlab\_host) | GitLab host. Only used when git\_provider = "gitlab". Override for self-hosted instances (e.g. "gitlab.mycompany.com"). | `string` | `"gitlab.com"` | no |
| <a name="input_local_specs_path"></a> [local\_specs\_path](#input\_local\_specs\_path) | Absolute path to the local service directory containing specs/. Required when git\_provider = "local". The directory must contain specs/service-spec.json.tpl and optionally specs/links/*.json.tpl and specs/actions/*.json.tpl. | `string` | `null` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (organization:account format) | `string` | n/a | yes |
| <a name="input_package"></a> [package](#input\_package) | Register this service definition as a versioned PACKAGE. When set, the module<br/>publishes a package revision whose bill of materials pins the service<br/>specification, every action specification, every LINK specification, and the<br/>artifacts you list — so consumers bind to an immutable revision and later<br/>template changes never mutate what already runs.<br/><br/>artifacts: each entry does ONE of:<br/>  • register a new artifact revision — set `meta` (JSON-able object, e.g.<br/>    { url = "https://github.com/acme/svc.git", reference = "main" } for a<br/>    git\_repository, or { registry, repository, digest } for an oci\_image);<br/>  • look up one registered elsewhere BY IDENTITY (no ids needed) — set<br/>    `lookup = true` + `meta` with the identity fields (url for<br/>    git\_repository, or registry+repository for oci\_image); add the<br/>    type's own per-revision field to pin a specific revision (reference,<br/>    e.g. a tag, for git\_repository; digest, formatted "sha256:<64-hex>",<br/>    for oci\_image — the API rejects the other type's field name),<br/>    otherwise the latest revision is used;<br/>  • pin explicit ids — set `resource_id` + `resource_revision_id`.<br/><br/>An artifact's `name` defaults to "impl" and `type` to "git\_repository" —<br/>a service package is typically a single artifact pointing at the<br/>service's own implementation repo, so only `meta` (url/reference) needs<br/>setting on every release.<br/><br/>For an artifact with `type = "oci_image"` (opt-in — not the default<br/>here), meta.registry/meta.repository default to<br/>var.package\_oci\_default\_registry/var.package\_oci\_default\_repository<br/>when omitted from `meta`. Only meta.digest needs setting on every<br/>release in that case; every other artifact type gets no meta defaults<br/>(their meta shape is unrelated to a container registry).<br/><br/>Null (the default) keeps the classic module behavior — no package. | <pre>object({<br/>    slug       = optional(string)          # default: the service specification slug<br/>    name       = optional(string)          # default: var.service_name<br/>    version    = string                    # semver of the revision this configuration publishes<br/>    default    = optional(bool, true)      # promote each published revision to the package default<br/>    tags       = optional(map(string), {}) # release tags: name => version (requires an API with the package release-tag routes)<br/>    visible_to = optional(list(string))    # default: [var.nrn]<br/>    artifacts = optional(list(object({<br/>      name                 = optional(string, "impl")           # default: a single service-implementation artifact<br/>      type                 = optional(string, "git_repository") # oci_image | oras_artifact | git_repository | blob<br/>      meta                 = optional(any)                      # register (lookup=false) or find (lookup=true)<br/>      lookup               = optional(bool, false)              # true: resolve an EXISTING artifact by meta identity<br/>      resource_id          = optional(string)                   # …or pin explicit ids<br/>      resource_revision_id = optional(string)<br/>    })), [])<br/>  })</pre> | `null` | no |
| <a name="input_package_oci_default_registry"></a> [package\_oci\_default\_registry](#input\_package\_oci\_default\_registry) | Default meta.registry for an oci\_image package artifact whose own meta omits it. See var.package's artifacts docs. | `string` | `"public.ecr.aws"` | no |
| <a name="input_package_oci_default_repository"></a> [package\_oci\_default\_repository](#input\_package\_oci\_default\_repository) | Default meta.repository for an oci\_image package artifact whose own meta omits it. See var.package's artifacts docs. | `string` | `"nullplatform/scopes/containers"` | no |
| <a name="input_repository_branch"></a> [repository\_branch](#input\_repository\_branch) | Git ref of the service spec repository to read, as a short name and not a full ref<br/>(e.g. "v1.4.0"). No default and no recommended value: which spec repository an install<br/>points at is its own choice, so there is no version anyone could pick for it.<br/><br/>Combine with repository\_ref\_type, which selects the namespace this name lives in. | `string` | n/a | yes |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | Repository name containing the service spec templates. | `string` | `"service"` | no |
| <a name="input_repository_org"></a> [repository\_org](#input\_repository\_org) | GitHub organization or GitLab group owning the service spec repository. | `string` | `"nullplatform"` | no |
| <a name="input_repository_ref_type"></a> [repository\_ref\_type](#input\_repository\_ref\_type) | Git ref namespace for `repository_branch` on GitHub: "heads" for a branch, "tags" for a tag, or "" to treat it as a raw commit SHA. Defaults to "heads", preserving previous behaviour. | `string` | `"tags"` | no |
| <a name="input_repository_token"></a> [repository\_token](#input\_repository\_token) | Access token for private repositories. GitHub: personal access token or fine-grained token. GitLab: Personal Access Token (PAT) with read\_api scope. | `string` | `null` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the scope type to be created | `string` | n/a | yes |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path within the repository for the specific service (e.g., databases/postgres/k8s) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_package_artifacts"></a> [package\_artifacts](#output\_package\_artifacts) | Artifacts registered by this module: name => { resource\_id, resource\_revision\_id }. |
| <a name="output_package_default_version"></a> [package\_default\_version](#output\_package\_default\_version) | The package's default version after apply, or null. |
| <a name="output_package_id"></a> [package\_id](#output\_package\_id) | ID of the package registered from this service definition, or null when packaging is disabled. |
| <a name="output_package_published_revision_id"></a> [package\_published\_revision\_id](#output\_package\_published\_revision\_id) | Revision UUID published for the configured package version, or null. |
| <a name="output_service_specification_id"></a> [service\_specification\_id](#output\_service\_specification\_id) | The ID of the created service specification |
| <a name="output_service_specification_slug"></a> [service\_specification\_slug](#output\_service\_specification\_slug) | The slug of the created service specification |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "service_definition",
  "description": "Provisions nullplatform service, action, and link specifications by fetching JSON templates from a remote Git repository (GitHub, GitLab, or Bitbucket) or local filesystem and registering them as versioned resources",
  "architecture": "The module uses data.http resources to fetch service-spec, action, and link JSON templates from a remote Git provider (GitHub, GitLab, or Bitbucket) using provider-specific raw URLs and auth headers, or reads them from the local filesystem when git_provider is 'local'. Parsed templates are fed into nullplatform_service_specification, nullplatform_action_specification, and nullplatform_link_specification resources, with action and link specifications depending on the service specification via explicit depends_on. When var.package is set, the module additionally creates nullplatform_package and nullplatform_artifact resources to register a versioned immutable package revision pinning all specifications and artifacts.",
  "features": [
    "Creates nullplatform_service_specification from a JSON template with configurable visibility, selectors, and dimensions",
    "Creates nullplatform_action_specification resources for each action template fetched from the repository",
    "Creates nullplatform_link_specification resources for each link template with scopes, assignability, and external config",
    "Fetches specification templates from GitHub, GitLab, or Bitbucket using provider-specific raw URLs and authentication headers",
    "Supports local filesystem template loading for offline or CI environments via git_provider = 'local'",
    "Registers versioned nullplatform_package and nullplatform_artifact resources when package configuration is provided",
    "Supports pinning to branches, tags, or raw commit SHAs via repository_ref_type and repository_branch variables"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "Nullplatform Resource Name (organization:account format)",
      "required": true
    },
    {
      "name": "service_path",
      "description": "Path within the repository for the specific service (e.g., databases/postgres/k8s)",
      "required": true
    },
    {
      "name": "service_name",
      "description": "Name of the scope type to be created",
      "required": true
    },
    {
      "name": "repository_branch",
      "description": "",
      "required": true
    },
    {
      "name": "git_provider",
      "description": "Git provider to fetch service specs from. Supported values: \\",
      "required": false
    },
    {
      "name": "repository_ref_type",
      "description": "Git ref namespace for `repository_branch` on GitHub: \\",
      "required": false
    },
    {
      "name": "package",
      "description": "",
      "required": false
    },
    {
      "name": "local_specs_path",
      "description": "Absolute path to the local service directory containing specs/. Required when git_provider = \\",
      "required": false
    },
    {
      "name": "repository_org",
      "description": "GitHub organization or GitLab group owning the service spec repository.",
      "required": false
    },
    {
      "name": "repository_name",
      "description": "Repository name containing the service spec templates.",
      "required": false
    },
    {
      "name": "available_actions",
      "description": "List of action template names to fetch from the service spec repository",
      "required": false
    },
    {
      "name": "available_links",
      "description": "List of link template names to fetch from the service spec repository",
      "required": false
    },
    {
      "name": "repository_token",
      "description": "Access token for private repositories. GitHub: personal access token or fine-grained token. GitLab: Personal Access Token (PAT) with read_api scope.",
      "required": false
    },
    {
      "name": "gitlab_host",
      "description": "GitLab host. Only used when git_provider = \\",
      "required": false
    },
    {
      "name": "bitbucket_email",
      "description": "Bitbucket account email, used only when git_provider = \\",
      "required": false
    },
    {
      "name": "extra_visibile_to_nrns",
      "description": "Additional NRNs that should have visibility to the created service specification",
      "required": false
    },
    {
      "name": "dimensions",
      "description": "Key-value pairs for dimensions to be associated with the service specification",
      "required": false
    },
    {
      "name": "package_oci_default_registry",
      "description": "Default meta.registry for an oci_image package artifact whose own meta omits it. See var.package's artifacts docs.",
      "required": false
    },
    {
      "name": "package_oci_default_repository",
      "description": "Default meta.repository for an oci_image package artifact whose own meta omits it. See var.package's artifacts docs.",
      "required": false
    }
  ],
  "outputs": [
    "service_specification_id",
    "service_specification_slug",
    "package_id",
    "package_published_revision_id",
    "package_default_version",
    "package_artifacts"
  ],
  "hash": "039deeba22b968f85608a586af19731e"
}
END_AI_METADATA -->
