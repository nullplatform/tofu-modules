# Module: scope_package_publish

## Description

Publishes a scope as a nullplatform package from its repository's release: the scope specification, its actions and the worker image, as one immutable revision versioned by the release tag

## Architecture

The module wraps `scope_definition` with the release contract a scope repository has with the platform. The templates are read from the checkout being published (`local_specs_path`), so a release publishes exactly the specs of its own tag. The revision's version is the release tag without the `v`, the version the worker image was registered with; the image is pinned by digest, as an artifact looked up by identity. A stable release becomes the package default and a prerelease (a version with a `-`) does not, unless `promote_default` says otherwise. The package is visible to every organization by default, which only the platform organization may do; another publisher passes its own NRNs.

A stack built on this module is applied only by the release workflow, through actions-nullplatform's `publish-package`, which passes the tag and the digest it pushed. Organizations install the result with `scope_package_installation`, which creates what each of them owns on top of the package: the scope type, the NRN settings and the scope-configuration schema. Only the specification, its actions and the package are created in the publisher organization.

## Features

- Versions the package revision by the release tag, the same version as the image artifact
- Pins the worker image by digest, looked up among the artifacts the release registered
- Promotes a stable release to the package default and leaves a prerelease where it is
- Publishes the templates of the checkout being released, never of a remote branch
- Creates nothing an installing organization owns: no scope type, NRN settings or scope-configuration schema
- Gives the specification the package slug, so copies registered with `scope_definition` can live next to the global one
- Refuses a tag that is not a release tag and a digest that is not `sha256:<64 hex>`

## Basic Usage

A `<service_path>/publish/` stack in the scope repository:

```hcl
module "publish" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_package_publish?ref=v9.16.0"

  nrn              = var.publisher_nrn
  release_tag      = var.release_tag
  image_digest     = var.image_digest
  image_repository = "nullplatform/scopes/lambda"

  package_slug             = "np-aws-lambda"
  service_spec_name        = "AWS Lambda"
  service_spec_description = "AWS Lambda functions managed by nullplatform"
  service_path             = "lambda"
  local_specs_path         = abspath("${path.module}/..")
  action_spec_names        = ["create-scope", "delete-scope", "start-initial"]
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
| <a name="module_scope_definition"></a> [scope\_definition](#module\_scope\_definition) | ../scope_definition | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_nrn"></a> [nrn](#input\_nrn) | NRN of the publisher organization (e.g. organization=123). The scope specification, its actions and the package are created here. | `string` | n/a | yes |
| <a name="input_release_tag"></a> [release\_tag](#input\_release\_tag) | Release tag being published (vX.Y.Z, or vX.Y.Z-<prerelease>). It is the package revision's version, without the v: the same version the worker image is registered with. The release workflow passes it. | `string` | n/a | yes |
| <a name="input_image_digest"></a> [image\_digest](#input\_image\_digest) | Digest of the worker image this release pushed (sha256:<64 hex>). The revision pins the artifact registered with it. | `string` | n/a | yes |
| <a name="input_image_registry"></a> [image\_registry](#input\_image\_registry) | Registry host of the worker image. | `string` | `"public.ecr.aws"` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Repository of the worker image inside the registry (e.g. nullplatform/scopes/lambda). | `string` | n/a | yes |
| <a name="input_artifact_name"></a> [artifact\_name](#input\_artifact\_name) | Name of the image component in the package revision. | `string` | `"worker-image"` | no |
| <a name="input_package_slug"></a> [package\_slug](#input\_package\_slug) | Slug of the package, and of the scope specification unless service\_spec\_slug says otherwise. Keep it apart from the slug a copy of this scope gets when an organization registers it with scope\_definition: nullplatform's own packages take the np- prefix. | `string` | n/a | yes |
| <a name="input_service_spec_name"></a> [service\_spec\_name](#input\_service\_spec\_name) | Name of the scope specification: what people read. | `string` | n/a | yes |
| <a name="input_service_spec_slug"></a> [service\_spec\_slug](#input\_service\_spec\_slug) | Slug of the scope specification. Null uses package\_slug. | `string` | `null` | no |
| <a name="input_service_spec_description"></a> [service\_spec\_description](#input\_service\_spec\_description) | Description of the scope specification. | `string` | n/a | yes |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path of the scope inside its repository (e.g. lambda). | `string` | n/a | yes |
| <a name="input_local_specs_path"></a> [local\_specs\_path](#input\_local\_specs\_path) | Directory holding the scope's specs/ in the checkout being published. Usually abspath("${path.module}/..") from a <service\_path>/publish stack. | `string` | n/a | yes |
| <a name="input_action_spec_names"></a> [action\_spec\_names](#input\_action\_spec\_names) | Action specifications to publish, by template name under specs/actions/. | `list(string)` | n/a | yes |
| <a name="input_visible_to"></a> [visible\_to](#input\_visible\_to) | Who can install the package and see its specification. The default publishes to every organization; only the platform organization may. | `list(string)` | `["organization=*"]` | no |
| <a name="input_promote_default"></a> [promote\_default](#input\_promote\_default) | Whether the published revision becomes the package default. Null promotes a stable release and leaves a prerelease where it is; true or false forces it. | `bool` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_specification_id"></a> [service\_specification\_id](#output\_service\_specification\_id) | Id of the published scope specification. |
| <a name="output_service_specification_slug"></a> [service\_specification\_slug](#output\_service\_specification\_slug) | Slug of the published scope specification. |
| <a name="output_package_id"></a> [package\_id](#output\_package\_id) | Id of the package. |
| <a name="output_package_version"></a> [package\_version](#output\_package\_version) | Version published by this apply: the release tag without the v. |
| <a name="output_package_promoted"></a> [package\_promoted](#output\_package\_promoted) | Whether the published revision became the package default. |
| <a name="output_package_published_revision_id"></a> [package\_published\_revision\_id](#output\_package\_published\_revision\_id) | Revision published by this apply. |
| <a name="output_package_default_version"></a> [package\_default\_version](#output\_package\_default\_version) | The package's default version after this apply. |
<!-- END_TF_DOCS -->
