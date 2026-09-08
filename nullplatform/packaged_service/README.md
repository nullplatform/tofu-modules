# Module: packaged_service

## Description

Publishes a versioned nullplatform package by assembling a bill of materials from a flat list of service specifications, link specifications, action specifications, and artifacts into a nullplatform_package resource

## Architecture

The module accepts a flat `components` list and partitions it into spec components (service_specification, link_specification), action components, and artifact components using local map expressions. For artifact components, it creates new revisions via nullplatform_artifact resources or resolves existing ones via nullplatform_artifact data sources depending on whether meta and lookup flags are set. All partitioned components are assembled into a unified BOM list and wired into a single nullplatform_package resource via a dynamic components block, with slug, name, and visible_to values cascading from the release variable through to the service specification resource.

## Features

- Creates nullplatform_artifact resources for inline artifact definitions with meta fields, registering new OCI image revisions
- Resolves existing nullplatform_artifact revisions by identity lookup using meta and type without requiring explicit IDs
- Automatically expands service_specification and link_specification default action_specifications as child BOM entries
- Publishes a nullplatform_package with a complete versioned bill of materials including specs, actions, and artifacts
- Validates BOM uniqueness by enforcing distinct component names and resource IDs within a single package revision
- Supports stable zero-padded indexing for BOM entry ordering to prevent spurious reordering diffs beyond nine components
- Cascades slug, name, and visible_to from the release variable or falls back to the service specification resource defaults

## Basic Usage

```hcl
module "packaged_service" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/packaged_service?ref=v7.6.0"

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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.102 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | >= 0.0.102 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_artifact.this](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/artifact) | resource |
| [nullplatform_package.this](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/package) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_components"></a> [components](#input\_components) | The package's bill of materials, as one flat list that mirrors<br/>nullplatform\_package.components. Each entry:<br/><br/>  type            = "service\_specification" \| "link\_specification" \| "artifact" \| "action\_specification"<br/>  resource        = the whole TF resource to pin (for artifact: an inline object, see below)<br/>  parent\_resource = (optional) the resource this hangs off — e.g. a link's service<br/><br/>Pass whole resources, not ids — the module reads each one's id + snapshot<br/>itself. Exactly one service\_specification is required (the BOM root). For<br/>every service\_specification / link\_specification, its default<br/>action\_specifications are pinned automatically as children — don't list them.<br/><br/>An artifact's `resource` is an inline object doing exactly ONE of:<br/>  register  { type = "oci\_image", meta = {…} }                 # new revision<br/>  look up   { type = "oci\_image", meta = {…}, lookup = true }   # resolve by identity<br/>  pin       { resource\_id = "…", resource\_revision\_id = "…" }   # existing ids<br/>`type` defaults to "oci\_image"; `name` (optional) labels it in the BOM/outputs.<br/>Lookup resolves artifacts VISIBLE at the nrn — owned, ancestor-shared, or<br/>global ("organization=*") — and the lookup meta may pin a revision by<br/>digest, by reference (git), or by tag (oci\_image: the NEWEST revision<br/>registered with that tag wins; a moved tag drifts to the new digest by<br/>design). Requires provider >= 0.0.102. | `any` | n/a | yes |
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
  "description": "Publishes a versioned nullplatform package by assembling a bill of materials from a flat list of service specifications, link specifications, action specifications, and artifacts into a nullplatform_package resource",
  "architecture": "The module accepts a flat `components` list and partitions it into spec components (service_specification, link_specification), action components, and artifact components using local map expressions. For artifact components, it creates new revisions via nullplatform_artifact resources or resolves existing ones via nullplatform_artifact data sources depending on whether meta and lookup flags are set. All partitioned components are assembled into a unified BOM list and wired into a single nullplatform_package resource via a dynamic components block, with slug, name, and visible_to values cascading from the release variable through to the service specification resource.",
  "features": [
    "Creates nullplatform_artifact resources for inline artifact definitions with meta fields, registering new OCI image revisions",
    "Resolves existing nullplatform_artifact revisions by identity lookup using meta and type without requiring explicit IDs",
    "Automatically expands service_specification and link_specification default action_specifications as child BOM entries",
    "Publishes a nullplatform_package with a complete versioned bill of materials including specs, actions, and artifacts",
    "Validates BOM uniqueness by enforcing distinct component names and resource IDs within a single package revision",
    "Supports stable zero-padded indexing for BOM entry ordering to prevent spurious reordering diffs beyond nine components",
    "Cascades slug, name, and visible_to from the release variable or falls back to the service specification resource defaults"
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
  "hash": "bd77177f1b7287a347031dea83b1eaa4"
}
END_AI_METADATA -->
