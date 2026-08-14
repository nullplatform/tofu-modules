# packaged_service

Turns a `nullplatform_service_specification` (+ its links and artifacts) into a
versioned nullplatform **package**. You describe the bill of materials as one
flat `components` list that mirrors `nullplatform_package.components` 1:1; the
module pins every entry to an exact snapshot and expands each spec's default
actions as children. Mirrors what `np package publish` registers, so
Terraform-defined and CLI-published service packages are interchangeable.

## Requirements

Provider **`nullplatform/nullplatform` >= 0.0.99**. It exposes the BOM computed
fields the module pins (`last_snapshot_id`, `action_specifications`) and handles
spec updates / republish correctly.

## Usage

```hcl
module "packaged_service" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/packaged_service?ref=v6.13.1"

  nrn = "organization=…:account=…:namespace=…"

  components = [
    {
      type     = "service_specification"
      resource = nullplatform_service_specification.postgres
    },
    {
      type            = "link_specification"
      resource        = nullplatform_link_specification.postgres
      parent_resource = nullplatform_service_specification.postgres
    },
    {
      type     = "artifact"
      resource = {
        type = "git_repository"
        meta = { url = "https://github.com/org/pg-provisioner", reference = "v1.2.0" }
      }
    },
  ]

  release = {
    version = "0.0.1"   # bump to publish a new revision
    default = true      # promote this revision to the package default
  }
}
```

You pass the **whole resource objects** in `components`; the module reads each
one's `id`, `last_snapshot_id` and `action_specifications` itself, and pins every
spec's default actions as child components automatically — you never list them.

## The `components` list

One entry per thing in the bill of materials — it maps 1:1 onto
`nullplatform_package.components`.

| Field | Required | Meaning |
|-------|----------|---------|
| `type` | yes | `service_specification` \| `link_specification` \| `artifact` \| `action_specification` |
| `resource` | yes | The whole TF resource to pin (for `artifact`: an inline object, below). |
| `parent_resource` | no | The resource this hangs off — e.g. a link's service. Root components omit it. |

Exactly **one** `service_specification` is required — it's the BOM root and its
`slug` / `name` / `visible_to` become the package defaults.

An `artifact`'s `resource` is an inline object doing exactly one of:

```hcl
resource = { type = "oci_image", meta = {…} }                 # register a new revision
resource = { type = "oci_image", meta = {…}, lookup = true }  # resolve an existing one by identity
resource = { resource_id = "…", resource_revision_id = "…" }  # pin explicit ids
```

`type` defaults to `oci_image`; add `name` to label it in the BOM and the
`artifacts` output.

## The `release` object

| Field | Required | Default | Meaning |
|-------|----------|---------|---------|
| `version` | yes | — | Semver of the revision to publish; bump for a new one. |
| `default` | no | `true` | Promote this revision to the package default. |
| `slug` | no | service spec's | Package slug (unique per NRN). |
| `name` | no | service spec's | Package display name. |
| `visible_to` | no | service spec's | Package + artifact visibility. |

`version` sits **inside `release`**, not at the top level, because a top-level
`version` is Terraform's reserved registry-module argument and errors on a
git/local source.

## Notes

- **Default actions are automatic** — every `service_specification` /
  `link_specification` in `components` contributes its default
  `action_specifications` as children. List an `action_specification` component
  yourself only to pin one that a spec didn't create.
- **No tags yet** — release tags beyond `default` aren't modeled; `release.default`
  is the only promotion knob today.
- **Source `@version` sugar** isn't native Terraform — pin the module with a git
  `?ref=` (or the registry `version` argument), not `…/packaged_service@1.0.0`.

## Outputs

| Name | Description |
|------|-------------|
| `package_id` | ID of the published package. |
| `package_slug` | Slug of the published package. |
| `published_revision_id` | Revision UUID published for `release.version`. |
| `default_version` | The package's default version after apply. |
| `default_revision_id` | Revision services bind to by default. |
| `artifacts` | `name => { resource_id, resource_revision_id }` for artifacts registered here. |

See `examples/postgres` for a full sample PostgreSQL service + link packaged in
one apply.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.99 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | >= 0.0.99 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_artifact.this](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/artifact) | resource |
| [nullplatform_package.this](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/package) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_components"></a> [components](#input\_components) | The package's bill of materials, as one flat list that mirrors<br/>nullplatform\_package.components. Each entry:<br/><br/>  type            = "service\_specification" \| "link\_specification" \| "artifact" \| "action\_specification"<br/>  resource        = the whole TF resource to pin (for artifact: an inline object, see below)<br/>  parent\_resource = (optional) the resource this hangs off — e.g. a link's service<br/><br/>Pass whole resources, not ids — the module reads each one's id + snapshot<br/>itself. Exactly one service\_specification is required (the BOM root). For<br/>every service\_specification / link\_specification, its default<br/>action\_specifications are pinned automatically as children — don't list them.<br/><br/>An artifact's `resource` is an inline object doing exactly ONE of:<br/>  register  { type = "oci\_image", meta = {…} }                 # new revision<br/>  look up   { type = "oci\_image", meta = {…}, lookup = true }   # resolve by identity<br/>  pin       { resource\_id = "…", resource\_revision\_id = "…" }   # existing ids<br/>`type` defaults to "oci\_image"; `name` (optional) labels it in the BOM/outputs. | `any` | n/a | yes |
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