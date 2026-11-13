# Module: service_package_publish

## Description

Publishes a versioned service package revision by wiring a release tag and OCI image digest into a nullplatform service definition with pinned artifact metadata

## Architecture

The module delegates entirely to a child `service_definition` module, passing a `git_provider = local` configuration so specs are read from the checkout rather than a remote URL. It computes a `version` local by stripping the `v` prefix from `release_tag` and derives `promote_default` by detecting whether the version string contains a prerelease segment. The `package` block passed to `service_definition` pins the OCI artifact by digest, sets the slug and version, and controls default promotion, while link and action specifications are sourced from the local `local_specs_path` directory.

## Features

- Publishes an immutable package revision pinned to a specific OCI image digest and release tag version
- Automatically promotes stable releases as the package default while leaving prerelease versions unpromoted
- Reads service, link, and action specifications directly from the repository checkout at the release tag
- Configures package visibility to control which organizations can discover and install the published specification
- Supports custom service and package slugs to namespace specifications independently for agent channel routing
- Exposes revision ID, promoted version, and default version outputs for downstream release workflow steps

## Basic Usage

```hcl
module "service_package_publish" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/service_package_publish?ref=v9.17.0"

  image_digest     = "your-image-digest"
  image_repository = "your-image-repository"
  local_specs_path = "your-local-specs-path"
  nrn              = "your-nrn"
  package_slug     = "your-package-slug"
  release_tag      = "your-release-tag"
  service_name     = "your-service-name"
  service_path     = "your-service-path"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.service_package_publish.service_specification_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.113 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_service_definition"></a> [service\_definition](#module\_service\_definition) | ../service_definition | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifact_name"></a> [artifact\_name](#input\_artifact\_name) | Name of the image component in the package revision. | `string` | `"worker-image"` | no |
| <a name="input_available_actions"></a> [available\_actions](#input\_available\_actions) | Action specifications written as templates under specs/actions/, by name. Default actions (use\_default\_actions) need no entry: the platform creates them and the revision pins them. | `list(string)` | `[]` | no |
| <a name="input_available_links"></a> [available\_links](#input\_available\_links) | Link specifications to publish, by template name under specs/links/. | `list(string)` | <pre>[<br/>  "connect"<br/>]</pre> | no |
| <a name="input_image_digest"></a> [image\_digest](#input\_image\_digest) | Digest of the worker image this release pushed (sha256:<64 hex>). The revision pins the artifact registered with it. | `string` | n/a | yes |
| <a name="input_image_registry"></a> [image\_registry](#input\_image\_registry) | Registry host of the worker image. | `string` | `"public.ecr.aws"` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Repository of the worker image inside the registry (e.g. nullplatform/services/s3). | `string` | n/a | yes |
| <a name="input_link_slugs"></a> [link\_slugs](#input\_link\_slugs) | Slug of each link specification, by template name. Omitted links take the slug the platform derives from their name. | `map(string)` | `{}` | no |
| <a name="input_local_specs_path"></a> [local\_specs\_path](#input\_local\_specs\_path) | Directory holding the service's specs/ in the checkout being published: the release workflow applies the stack at the release tag, so the revision pins exactly that tag's specs. Usually abspath("${path.module}/..") from a <service\_path>/publish stack. | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | NRN of the publisher organization (e.g. organization=123). The specification, its links, their actions and the package are created here. | `string` | n/a | yes |
| <a name="input_package_slug"></a> [package\_slug](#input\_package\_slug) | Slug of the package, and of the service specification unless service\_slug says otherwise. Keep it apart from the slug a copy of this service gets when an organization registers it with service\_definition (agent channels route by specification slug): nullplatform's own packages take the np- prefix. | `string` | n/a | yes |
| <a name="input_promote_default"></a> [promote\_default](#input\_promote\_default) | Whether the published revision becomes the package default, what an organization that installs without pinning a version is born with. Null (the default) promotes a stable release and leaves a prerelease (a version with a `-`) where it is; true or false forces it. | `bool` | `null` | no |
| <a name="input_release_tag"></a> [release\_tag](#input\_release\_tag) | Release tag being published (vX.Y.Z, or vX.Y.Z-<prerelease>). It is the package revision's version, without the v: the same version the worker image is registered with. The release workflow passes it. | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the service specification: what people read. | `string` | n/a | yes |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path of the service inside its repository (e.g. aws-s3-bucket). | `string` | n/a | yes |
| <a name="input_service_slug"></a> [service\_slug](#input\_service\_slug) | Slug of the service specification. Null uses package\_slug. | `string` | `null` | no |
| <a name="input_visible_to"></a> [visible\_to](#input\_visible\_to) | Who can install the package and see its specification. The default publishes to every organization; only the platform organization may. Another publisher passes its own NRNs. | `list(string)` | <pre>[<br/>  "organization=*"<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_package_default_version"></a> [package\_default\_version](#output\_package\_default\_version) | The package's default version after this apply. |
| <a name="output_package_id"></a> [package\_id](#output\_package\_id) | Id of the package. |
| <a name="output_package_promoted"></a> [package\_promoted](#output\_package\_promoted) | Whether the published revision became the package default. |
| <a name="output_package_published_revision_id"></a> [package\_published\_revision\_id](#output\_package\_published\_revision\_id) | Revision published by this apply. |
| <a name="output_package_version"></a> [package\_version](#output\_package\_version) | Version published by this apply: the release tag without the v. |
| <a name="output_service_specification_id"></a> [service\_specification\_id](#output\_service\_specification\_id) | Id of the published service specification. |
| <a name="output_service_specification_slug"></a> [service\_specification\_slug](#output\_service\_specification\_slug) | Slug of the published service specification. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "service_package_publish",
  "description": "Publishes a versioned service package revision by wiring a release tag and OCI image digest into a nullplatform service definition with pinned artifact metadata",
  "architecture": "The module delegates entirely to a child `service_definition` module, passing a `git_provider = local` configuration so specs are read from the checkout rather than a remote URL. It computes a `version` local by stripping the `v` prefix from `release_tag` and derives `promote_default` by detecting whether the version string contains a prerelease segment. The `package` block passed to `service_definition` pins the OCI artifact by digest, sets the slug and version, and controls default promotion, while link and action specifications are sourced from the local `local_specs_path` directory.",
  "features": [
    "Publishes an immutable package revision pinned to a specific OCI image digest and release tag version",
    "Automatically promotes stable releases as the package default while leaving prerelease versions unpromoted",
    "Reads service, link, and action specifications directly from the repository checkout at the release tag",
    "Configures package visibility to control which organizations can discover and install the published specification",
    "Supports custom service and package slugs to namespace specifications independently for agent channel routing",
    "Exposes revision ID, promoted version, and default version outputs for downstream release workflow steps"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "NRN of the publisher organization (e.g. organization=123). The specification, its links, their actions and the package are created here.",
      "required": true
    },
    {
      "name": "image_repository",
      "description": "Repository of the worker image inside the registry (e.g. nullplatform/services/s3).",
      "required": true
    },
    {
      "name": "package_slug",
      "description": "Slug of the package, and of the service specification unless service_slug says otherwise. Keep it apart from the slug a copy of this service gets when an organization registers it with service_definition (agent channels route by specification slug): nullplatform's own packages take the np- prefix.",
      "required": true
    },
    {
      "name": "service_name",
      "description": "Name of the service specification: what people read.",
      "required": true
    },
    {
      "name": "service_path",
      "description": "Path of the service inside its repository (e.g. aws-s3-bucket).",
      "required": true
    },
    {
      "name": "local_specs_path",
      "description": "Directory holding the service's specs/ in the checkout being published: the release workflow applies the stack at the release tag, so the revision pins exactly that tag's specs. Usually abspath(\\",
      "required": true
    },
    {
      "name": "release_tag",
      "description": "Release tag being published (vX.Y.Z, or vX.Y.Z-<prerelease>). It is the package revision's version, without the v: the same version the worker image is registered with. The release workflow passes it.",
      "required": true
    },
    {
      "name": "image_digest",
      "description": "Digest of the worker image this release pushed (sha256:<64 hex>). The revision pins the artifact registered with it.",
      "required": true
    },
    {
      "name": "image_registry",
      "description": "Registry host of the worker image.",
      "required": false
    },
    {
      "name": "artifact_name",
      "description": "Name of the image component in the package revision.",
      "required": false
    },
    {
      "name": "service_slug",
      "description": "Slug of the service specification. Null uses package_slug.",
      "required": false
    },
    {
      "name": "available_links",
      "description": "Link specifications to publish, by template name under specs/links/.",
      "required": false
    },
    {
      "name": "available_actions",
      "description": "Action specifications written as templates under specs/actions/, by name. Default actions (use_default_actions) need no entry: the platform creates them and the revision pins them.",
      "required": false
    },
    {
      "name": "link_slugs",
      "description": "Slug of each link specification, by template name. Omitted links take the slug the platform derives from their name.",
      "required": false
    },
    {
      "name": "visible_to",
      "description": "Who can install the package and see its specification. The default publishes to every organization; only the platform organization may. Another publisher passes its own NRNs.",
      "required": false
    },
    {
      "name": "promote_default",
      "description": "Whether the published revision becomes the package default, what an organization that installs without pinning a version is born with. Null (the default) promotes a stable release and leaves a prerelease (a version with a `-`) where it is; true or false forces it.",
      "required": false
    }
  ],
  "outputs": [
    "service_specification_id",
    "service_specification_slug",
    "package_id",
    "package_version",
    "package_promoted",
    "package_published_revision_id",
    "package_default_version"
  ],
  "hash": "24a430f432c70dffb52ceba405304369"
}
END_AI_METADATA -->
