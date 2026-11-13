# Module: service_package_publish

## Description

Publishes a service as a nullplatform package from its repository's release: the specification, its links, every action and the worker image, as one immutable revision versioned by the release tag

## Architecture

The module wraps `service_definition` with the release contract a service repository has with the platform. The specs are read from the checkout being published (`git_provider = "local"`), so a release publishes exactly the specs of its own tag. The revision's version is the release tag without the `v`, the version the worker image was registered with; the image is pinned by digest, as an artifact looked up by identity. A stable release becomes the package default and a prerelease (a version with a `-`) does not, unless `promote_default` says otherwise. The package is visible to every organization by default, which only the platform organization may do; another publisher passes its own NRNs.

A stack built on this module is applied only by the release workflow, through actions-nullplatform's `publish-package`, which passes the tag and the digest it pushed. Organizations install the result with `service_package_installation`. One apply publishes a complete revision, platform default actions included: no bootstrap apply is needed.

## Features

- Versions the package revision by the release tag, the same version as the image artifact
- Pins the worker image by digest, looked up among the artifacts the release registered
- Promotes a stable release to the package default and leaves a prerelease where it is
- Publishes the specs of the checkout being released, never of a remote branch
- Gives the specification the package slug, so copies registered with `service_definition` can live next to the global one
- Refuses a tag that is not a release tag and a digest that is not `sha256:<64 hex>`

## Basic Usage

A `<service_path>/publish/` stack in the service repository:

```hcl
module "publish" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/service_package_publish?ref=v9.16.0"

  nrn              = var.publisher_nrn
  release_tag      = var.release_tag
  image_digest     = var.image_digest
  image_repository = "nullplatform/services/s3"

  package_slug     = "np-aws-s3-bucket"
  service_name     = "AWS S3 Bucket"
  service_path     = "aws-s3-bucket"
  local_specs_path = abspath("${path.module}/..")
}
```

`var.publisher_nrn`, `var.release_tag` and `var.image_digest` are what `publish-package` passes as `TF_VAR_*`.

## Using Outputs

```hcl
output "package_version" {
  value = module.publish.package_version
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
| <a name="input_nrn"></a> [nrn](#input\_nrn) | NRN of the publisher organization (e.g. organization=123). The specification, its links, their actions and the package are created here. | `string` | n/a | yes |
| <a name="input_release_tag"></a> [release\_tag](#input\_release\_tag) | Release tag being published (vX.Y.Z, or vX.Y.Z-<prerelease>). It is the package revision's version, without the v: the same version the worker image is registered with. The release workflow passes it. | `string` | n/a | yes |
| <a name="input_image_digest"></a> [image\_digest](#input\_image\_digest) | Digest of the worker image this release pushed (sha256:<64 hex>). The revision pins the artifact registered with it. | `string` | n/a | yes |
| <a name="input_image_registry"></a> [image\_registry](#input\_image\_registry) | Registry host of the worker image. | `string` | `"public.ecr.aws"` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Repository of the worker image inside the registry (e.g. nullplatform/services/s3). | `string` | n/a | yes |
| <a name="input_artifact_name"></a> [artifact\_name](#input\_artifact\_name) | Name of the image component in the package revision. | `string` | `"worker-image"` | no |
| <a name="input_package_slug"></a> [package\_slug](#input\_package\_slug) | Slug of the package, and of the service specification unless service\_slug says otherwise. Keep it apart from the slug a copy of this service gets when an organization registers it with service\_definition: nullplatform's own packages take the np- prefix. | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the service specification: what people read. | `string` | n/a | yes |
| <a name="input_service_slug"></a> [service\_slug](#input\_service\_slug) | Slug of the service specification. Null uses package\_slug. | `string` | `null` | no |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path of the service inside its repository (e.g. aws-s3-bucket). | `string` | n/a | yes |
| <a name="input_local_specs_path"></a> [local\_specs\_path](#input\_local\_specs\_path) | Directory holding the service's specs/ in the checkout being published. Usually abspath("${path.module}/..") from a <service\_path>/publish stack. | `string` | n/a | yes |
| <a name="input_available_links"></a> [available\_links](#input\_available\_links) | Link specifications to publish, by template name under specs/links/. | `list(string)` | `["connect"]` | no |
| <a name="input_available_actions"></a> [available\_actions](#input\_available\_actions) | Action specifications written as templates under specs/actions/, by name. Default actions need no entry. | `list(string)` | `[]` | no |
| <a name="input_link_slugs"></a> [link\_slugs](#input\_link\_slugs) | Slug of each link specification, by template name. | `map(string)` | `{}` | no |
| <a name="input_visible_to"></a> [visible\_to](#input\_visible\_to) | Who can install the package and see its specification. The default publishes to every organization; only the platform organization may. | `list(string)` | `["organization=*"]` | no |
| <a name="input_promote_default"></a> [promote\_default](#input\_promote\_default) | Whether the published revision becomes the package default. Null promotes a stable release and leaves a prerelease where it is; true or false forces it. | `bool` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_specification_id"></a> [service\_specification\_id](#output\_service\_specification\_id) | Id of the published service specification. |
| <a name="output_service_specification_slug"></a> [service\_specification\_slug](#output\_service\_specification\_slug) | Slug of the published service specification. |
| <a name="output_package_id"></a> [package\_id](#output\_package\_id) | Id of the package. |
| <a name="output_package_version"></a> [package\_version](#output\_package\_version) | Version published by this apply: the release tag without the v. |
| <a name="output_package_promoted"></a> [package\_promoted](#output\_package\_promoted) | Whether the published revision became the package default. |
| <a name="output_package_published_revision_id"></a> [package\_published\_revision\_id](#output\_package\_published\_revision\_id) | Revision published by this apply. |
| <a name="output_package_default_version"></a> [package\_default\_version](#output\_package\_default\_version) | The package's default version after this apply. |
<!-- END_TF_DOCS -->
