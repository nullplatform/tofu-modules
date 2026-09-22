# Module: packaged_service

## Description

Publishes a versioned nullplatform package by assembling a bill of materials from service specifications, link specifications, action specifications, and artifacts into a nullplatform_package resource

## Architecture

The module accepts a flat `components` list and partitions it into spec components (service_specification, link_specification), action components, and artifact components using local map transformations. Artifact components are further split into three sub-paths: new revisions created via nullplatform_artifact resources, existing revisions resolved via nullplatform_artifact data sources, and pre-pinned artifacts taken by ID. The assembled bill of materials (spec BOM entries plus their auto-expanded action_specification children, explicit action entries, and artifact entries) is fed as a dynamic block into a single nullplatform_package resource. The package slug, name, and visibility default to the service_specification resource values when not overridden by the release input.

## Features

- Creates nullplatform_artifact resources for inline artifact definitions, registering new OCI image revisions under the given NRN
- Resolves existing artifacts by identity using nullplatform_artifact data sources with metadata-based lookup
- Assembles a fully-pinned bill of materials by combining service specifications, link specifications, action specifications, and artifacts into a single nullplatform_package resource
- Automatically expands each service_specification and link_specification's default action_specifications as child BOM entries without requiring explicit listing
- Enforces BOM integrity with preconditions that validate snapshot existence, unique component names, and unique resource IDs before publishing
- Derives package slug, name, and visibility from the service_specification resource when not explicitly set in the release variable
- Outputs published revision ID, default revision ID, package slug, and a map of registered artifact resource IDs for downstream consumption

## Basic Usage

```hcl
module "packaged_service" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/packaged_service?ref=v7.14.0"

  components = "your-components"
  nrn        = "your-nrn"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.packaged_service.package_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.104 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | >= 0.0.104 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_artifact.this](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/artifact) | resource |
| [nullplatform_package.this](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/package) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_components"></a> [components](#input\_components) | The package's bill of materials, as one flat list that mirrors<br/>nullplatform\_package.components. Each entry:<br/><br/>  type            = "service\_specification" \| "link\_specification" \| "artifact" \| "action\_specification"<br/>  resource        = the whole TF resource to pin (for artifact: an inline object, see below)<br/>  parent\_resource = (optional) the resource this hangs off — e.g. a link's service<br/><br/>Pass whole resources, not ids — the module reads each one's id + snapshot<br/>itself. Exactly one service\_specification is required (the BOM root). For<br/>every service\_specification / link\_specification, its default<br/>action\_specifications are pinned automatically as children — don't list them.<br/><br/>An artifact's `resource` is an inline object doing exactly ONE of:<br/>  register  { type = "oci\_image", meta = {…} }                 # new revision<br/>  look up   { type = "oci\_image", meta = {…}, lookup = true }   # resolve by identity<br/>  pin       { resource\_id = "…", resource\_revision\_id = "…" }   # existing ids<br/>`type` defaults to "oci\_image"; `name` (optional) labels it in the BOM/outputs.<br/>Lookup resolves artifacts VISIBLE at the nrn — owned, ancestor-shared, or<br/>global ("organization=*") — and the lookup meta may pin a revision by<br/>digest, by reference (git), or by tag (oci\_image: the NEWEST revision<br/>registered with that tag wins; a moved tag drifts to the new digest by<br/>design). Requires provider >= 0.0.104.<br/><br/>The published BOM is exactly this list: a component you drop is gone from<br/>the next revision. Provider releases before 0.0.104 let the platform merge<br/>the previous default revision's components back in, so removals silently<br/>stayed. | `any` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Owner NRN — the org/account/namespace the package and its artifacts live in. | `string` | n/a | yes |
| <a name="input_release"></a> [release](#input\_release) | How this revision is published. `version` lives here (nested) because a<br/>top-level `version` is Terraform's reserved registry-module argument and<br/>errors on a git/local source. slug/name/visible\_to default to the service<br/>spec's when unset. | <pre>object({<br/>    version    = string                 # semver of the revision to publish; bump for a new revision<br/>    default    = optional(bool, true)   # promote this revision to the package default<br/>    slug       = optional(string)       # package slug — defaults to the service spec's slug<br/>    name       = optional(string)       # display name — defaults to the service spec's name<br/>    visible_to = optional(list(string)) # visibility    — defaults to the service spec's visible_to<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_artifacts"></a> [artifacts](#output\_artifacts) | Artifacts registered by this module: name => { resource\_id, resource\_revision\_id }. |
| <a name="output_default_revision_id"></a> [default\_revision\_id](#output\_default\_revision\_id) | Revision that services bind to by default. |
| <a name="output_default_version"></a> [default\_version](#output\_default\_version) | The package's default version after apply. |
| <a name="output_package_id"></a> [package\_id](#output\_package\_id) | ID of the published package. |
| <a name="output_package_slug"></a> [package\_slug](#output\_package\_slug) | Slug of the published package. |
| <a name="output_published_revision_id"></a> [published\_revision\_id](#output\_published\_revision\_id) | Revision UUID published for package\_version. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "packaged_service",
  "description": "Publishes a versioned nullplatform package by assembling a bill of materials from service specifications, link specifications, action specifications, and artifacts into a nullplatform_package resource",
  "architecture": "The module accepts a flat `components` list and partitions it into spec components (service_specification, link_specification), action components, and artifact components using local map transformations. Artifact components are further split into three sub-paths: new revisions created via nullplatform_artifact resources, existing revisions resolved via nullplatform_artifact data sources, and pre-pinned artifacts taken by ID. The assembled bill of materials (spec BOM entries plus their auto-expanded action_specification children, explicit action entries, and artifact entries) is fed as a dynamic block into a single nullplatform_package resource. The package slug, name, and visibility default to the service_specification resource values when not overridden by the release input.",
  "features": [
    "Creates nullplatform_artifact resources for inline artifact definitions, registering new OCI image revisions under the given NRN",
    "Resolves existing artifacts by identity using nullplatform_artifact data sources with metadata-based lookup",
    "Assembles a fully-pinned bill of materials by combining service specifications, link specifications, action specifications, and artifacts into a single nullplatform_package resource",
    "Automatically expands each service_specification and link_specification's default action_specifications as child BOM entries without requiring explicit listing",
    "Enforces BOM integrity with preconditions that validate snapshot existence, unique component names, and unique resource IDs before publishing",
    "Derives package slug, name, and visibility from the service_specification resource when not explicitly set in the release variable",
    "Outputs published revision ID, default revision ID, package slug, and a map of registered artifact resource IDs for downstream consumption"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "Owner NRN — the org/account/namespace the package and its artifacts live in.",
      "required": true
    },
    {
      "name": "components",
      "description": "",
      "required": true
    },
    {
      "name": "release",
      "description": "",
      "required": false
    }
  ],
  "outputs": [
    "package_id",
    "package_slug",
    "published_revision_id",
    "default_version",
    "default_revision_id",
    "artifacts"
  ],
  "hash": "4127cd6260dd82bb6e72789264351f89"
}
END_AI_METADATA -->
