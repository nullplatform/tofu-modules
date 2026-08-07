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
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/packaged_service?ref=v6.11.1"

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
