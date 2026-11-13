# Module: scope_package_publish

## Description

Publishes a scope as a versioned package by creating a scope specification, its action specs, and a pinned package revision with an OCI image artifact in the nullplatform registry

## Architecture

The module delegates all resource creation to a child `scope_definition` module, passing through the NRN, spec templates from the local checkout, and a constructed `package` object. The `package` object pins the OCI image artifact by digest (sha256) and sets the revision version from the release tag with the `v` prefix stripped. A `promote_default` local controls whether a stable release (no `-` in version) becomes the package default, with `var.promote_default` able to force either direction. Outputs surface the specification ID, slug, package ID, published revision ID, version string, and whether promotion occurred.

## Features

- Creates a scope specification with configurable name, slug, and description from local checkout templates
- Publishes a versioned package revision pinned to an OCI image artifact by sha256 digest
- Automatically promotes stable releases (vX.Y.Z) as the package default while leaving prereleases (vX.Y.Z-*) unpromoted
- Registers action specifications from a configurable list of template names under specs/actions/
- Controls package visibility across organizations via a configurable visible_to list
- Supports overriding the scope specification slug independently from the package slug

## Basic Usage

```hcl
module "scope_package_publish" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_package_publish?ref=v9.16.0"

  action_spec_names        = "your-action-spec-names"
  image_digest             = "your-image-digest"
  image_repository         = "your-image-repository"
  local_specs_path         = "your-local-specs-path"
  nrn                      = "your-nrn"
  package_slug             = "your-package-slug"
  release_tag              = "your-release-tag"
  service_path             = "your-service-path"
  service_spec_description = "your-service-spec-description"
  service_spec_name        = "your-service-spec-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.scope_package_publish.service_specification_id
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
| <a name="module_scope_definition"></a> [scope\_definition](#module\_scope\_definition) | ../scope_definition | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action_spec_names"></a> [action\_spec\_names](#input\_action\_spec\_names) | Action specifications to publish, by template name under specs/actions/. | `list(string)` | n/a | yes |
| <a name="input_artifact_name"></a> [artifact\_name](#input\_artifact\_name) | Name of the image component in the package revision. | `string` | `"worker-image"` | no |
| <a name="input_image_digest"></a> [image\_digest](#input\_image\_digest) | Digest of the worker image this release pushed (sha256:<64 hex>). The revision pins the artifact registered with it. | `string` | n/a | yes |
| <a name="input_image_registry"></a> [image\_registry](#input\_image\_registry) | Registry host of the worker image. | `string` | `"public.ecr.aws"` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Repository of the worker image inside the registry (e.g. nullplatform/scopes/lambda). | `string` | n/a | yes |
| <a name="input_local_specs_path"></a> [local\_specs\_path](#input\_local\_specs\_path) | Directory holding the scope's specs/ in the checkout being published: the release workflow applies the stack at the release tag, so the revision pins exactly that tag's templates. Usually abspath("${path.module}/..") from a <service\_path>/publish stack. | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | NRN of the publisher organization (e.g. organization=123). The scope specification, its actions and the package are created here. | `string` | n/a | yes |
| <a name="input_package_slug"></a> [package\_slug](#input\_package\_slug) | Slug of the package, and of the scope specification unless service\_spec\_slug says otherwise. Keep it apart from the slug a copy of this scope gets when an organization registers it with scope\_definition (package lookups and agent channels match by slug): nullplatform's own packages take the np- prefix. | `string` | n/a | yes |
| <a name="input_promote_default"></a> [promote\_default](#input\_promote\_default) | Whether the published revision becomes the package default, what an organization that installs without pinning a version is born with. Null (the default) promotes a stable release and leaves a prerelease (a version with a `-`) where it is; true or false forces it. | `bool` | `null` | no |
| <a name="input_release_tag"></a> [release\_tag](#input\_release\_tag) | Release tag being published (vX.Y.Z, or vX.Y.Z-<prerelease>). It is the package revision's version, without the v: the same version the worker image is registered with. The release workflow passes it. | `string` | n/a | yes |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path of the scope inside its repository (e.g. lambda). | `string` | n/a | yes |
| <a name="input_service_spec_description"></a> [service\_spec\_description](#input\_service\_spec\_description) | Description of the scope specification. | `string` | n/a | yes |
| <a name="input_service_spec_name"></a> [service\_spec\_name](#input\_service\_spec\_name) | Name of the scope specification: what people read. | `string` | n/a | yes |
| <a name="input_service_spec_slug"></a> [service\_spec\_slug](#input\_service\_spec\_slug) | Slug of the scope specification. Null uses package\_slug. | `string` | `null` | no |
| <a name="input_visible_to"></a> [visible\_to](#input\_visible\_to) | Who can install the package and see its specification. The default publishes to every organization; only the platform organization may. Another publisher passes its own NRNs. | `list(string)` | <pre>[<br/>  "organization=*"<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_package_default_version"></a> [package\_default\_version](#output\_package\_default\_version) | The package's default version after this apply. |
| <a name="output_package_id"></a> [package\_id](#output\_package\_id) | Id of the package. |
| <a name="output_package_promoted"></a> [package\_promoted](#output\_package\_promoted) | Whether the published revision became the package default. |
| <a name="output_package_published_revision_id"></a> [package\_published\_revision\_id](#output\_package\_published\_revision\_id) | Revision published by this apply. |
| <a name="output_package_version"></a> [package\_version](#output\_package\_version) | Version published by this apply: the release tag without the v. |
| <a name="output_service_specification_id"></a> [service\_specification\_id](#output\_service\_specification\_id) | Id of the published scope specification. |
| <a name="output_service_specification_slug"></a> [service\_specification\_slug](#output\_service\_specification\_slug) | Slug of the published scope specification. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "scope_package_publish",
  "description": "Publishes a scope as a versioned package by creating a scope specification, its action specs, and a pinned package revision with an OCI image artifact in the nullplatform registry",
  "architecture": "The module delegates all resource creation to a child `scope_definition` module, passing through the NRN, spec templates from the local checkout, and a constructed `package` object. The `package` object pins the OCI image artifact by digest (sha256) and sets the revision version from the release tag with the `v` prefix stripped. A `promote_default` local controls whether a stable release (no `-` in version) becomes the package default, with `var.promote_default` able to force either direction. Outputs surface the specification ID, slug, package ID, published revision ID, version string, and whether promotion occurred.",
  "features": [
    "Creates a scope specification with configurable name, slug, and description from local checkout templates",
    "Publishes a versioned package revision pinned to an OCI image artifact by sha256 digest",
    "Automatically promotes stable releases (vX.Y.Z) as the package default while leaving prereleases (vX.Y.Z-*) unpromoted",
    "Registers action specifications from a configurable list of template names under specs/actions/",
    "Controls package visibility across organizations via a configurable visible_to list",
    "Supports overriding the scope specification slug independently from the package slug"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "NRN of the publisher organization (e.g. organization=123). The scope specification, its actions and the package are created here.",
      "required": true
    },
    {
      "name": "image_repository",
      "description": "Repository of the worker image inside the registry (e.g. nullplatform/scopes/lambda).",
      "required": true
    },
    {
      "name": "package_slug",
      "description": "Slug of the package, and of the scope specification unless service_spec_slug says otherwise. Keep it apart from the slug a copy of this scope gets when an organization registers it with scope_definition (package lookups and agent channels match by slug): nullplatform's own packages take the np- prefix.",
      "required": true
    },
    {
      "name": "service_spec_name",
      "description": "Name of the scope specification: what people read.",
      "required": true
    },
    {
      "name": "service_spec_description",
      "description": "Description of the scope specification.",
      "required": true
    },
    {
      "name": "service_path",
      "description": "Path of the scope inside its repository (e.g. lambda).",
      "required": true
    },
    {
      "name": "local_specs_path",
      "description": "Directory holding the scope's specs/ in the checkout being published: the release workflow applies the stack at the release tag, so the revision pins exactly that tag's templates. Usually abspath(\\",
      "required": true
    },
    {
      "name": "action_spec_names",
      "description": "Action specifications to publish, by template name under specs/actions/.",
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
      "name": "service_spec_slug",
      "description": "Slug of the scope specification. Null uses package_slug.",
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
  "hash": "91a6abc53ea412793571234346cfd821"
}
END_AI_METADATA -->
