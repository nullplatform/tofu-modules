# packaged_service

Turns a `nullplatform_service_specification` (+ optional `nullplatform_link_specification`)
into a versioned nullplatform **package**: one revision whose bill of materials
pins the service spec, the link spec, every default-created action of both, and
your artifacts — each frozen to an exact snapshot. Mirrors what `np package
publish` registers, so Terraform-defined and CLI-published service packages are
interchangeable.

## Requirements

A `nullplatform/nullplatform` provider that exposes `last_snapshot_id` **and**
`action_specifications` on the service and link specification resources. The
module pins the BOM from those computed attributes, so an older provider will
fail to resolve them. (Built locally via `dev_overrides` until released.)

## Usage

```hcl
module "packaged_service" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/packaged_service?ref=v1.0.0"

  nrn = "organization=…:account=…:namespace=…"

  service_specification = nullplatform_service_specification.my_service
  link_specification    = nullplatform_link_specification.my_link  # optional

  package_version = "0.0.1"   # bump to publish a new revision
}
```

You pass the **whole resource objects** for `service_specification` /
`link_specification`; the module reads their `id`, `last_snapshot_id` and
`action_specifications` itself.

### Overriding the defaults

Everything else is optional. Set any of these by hand:

```hcl
  slug      = "my-service"                 # defaults to the service spec's slug
  name      = "My Service"                 # defaults to the service spec's name
  visible_to = ["organization=…:account=…:namespace=…"]  # defaults to the spec's

  # Pin an artifact the package ships (image / git source / blob):
  artifacts = [{
    name = "provisioner"
    type = "oci_image"
    meta = { registry = "public.ecr.aws", repository = "org/provisioner", digest = "sha256:…" }
  }]

  # Only when the default should point at a version you're NOT publishing here:
  alias = { default = "0.0.2" }
```

## Notes

- **`package_version`, not `version`** — `version` is a reserved module
  meta-argument in Terraform/OpenTofu (parsed as a registry version constraint,
  rejected on git sources), so the input is `package_version`.
- **`alias`** — only the `default` key is honored today and maps to the
  package's `default_version`; omit it and `default_version = package_version`.
  Other aliases (e.g. `beta`) are reserved for a later revision → package `tags`.
- **`link_specification`** is optional — leave it null for a service with no link.
- **`artifacts`** — same shape as the `scope_definition` module: each entry
  registers a new revision (`meta`), looks one up by identity (`lookup = true`
  + `meta`), or pins explicit ids (`resource_id` + `resource_revision_id`).
- **Source `@version` sugar** isn't native Terraform — pin the module with a git
  `?ref=` (or the module registry `version` argument), not `…/packaged_service@1.0.0`.

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `service_specification` | any | — | The service spec resource to package (whole object). |
| `link_specification` | any | `null` | Optional link spec resource (whole object). |
| `package_version` | string | — | Semver of the revision to publish. |
| `alias` | map(string) | `{}` | `default` → package default_version. |
| `artifacts` | list(object) | `[]` | Artifacts to register + pin. |
| `nrn` | string | — | Owner NRN for the package + artifacts. |
| `slug` | string | service slug | Package slug (unique per NRN). |
| `name` | string | service name | Package display name. |
| `visible_to` | list(string) | service visible_to | Package/artifact visibility. |
| `tags` | map(string) | `{}` | Release tags (not `default`/`latest`). |

## Outputs

| Name | Description |
|------|-------------|
| `package_id` | ID of the published package. |
| `package_slug` | Slug of the published package. |
| `published_revision_id` | Revision UUID published for `package_version`. |
| `default_version` | The package's default version after apply. |
| `default_revision_id` | Revision services bind to by default. |
| `artifacts` | `name => { resource_id, resource_revision_id }` for artifacts registered here. |

See `examples/postgres` for a full "Managed PostgreSQL (Non-Prod)" service + link
packaged in one apply.
