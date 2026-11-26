# Module: checklist

## Description

Manages a nullplatform approval checklist specification, the items an approval action evaluates, from a definition written as a plain object

## Architecture

The module creates one `nullplatform_checklist_specification`, identified by `nrn` and `name`, with `definition` sent as `jsonencode(var.definition)`. The API keeps every change of the definition or the description as a new version with its own id, and the `current_version_id` output follows the newest one: the [`action`](../action) module links approval actions to it, so the apply that publishes a version re-links them in the same run. The specification is created before it is destroyed, so a new `name` or `nrn` can move linked actions to the replacement.

## Features

- Creates a checklist specification from a definition written as an HCL object, or read with `yamldecode(file(...))` or `jsondecode(file(...))`
- Publishes a new version on every change of the definition or the description; key order and spacing are not a change
- Exposes `current_version_id`, the version id approval actions link to
- Sends the definition as given: the API validates it on apply, and the module only checks that it has `items`
- Replaces the specification create-before-destroy when its `name` or `nrn` changes

## Basic Usage

A production deploy gate: two conditions on the build and a sign-off by someone other than the requester.

```hcl
module "prod_deploy_gate" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/approvals/checklist?ref=v9.17.3"

  nrn         = "organization=1:account=2"
  name        = "prod-deploy-gate"
  description = "Production deploys: line coverage, no critical vulnerabilities and a peer sign-off"

  definition = {
    execution_trigger = "explicit" # once approved, someone starts the deploy
    items = [
      {
        id       = "coverage_gate"
        type     = "condition"
        behavior = "gate"
        severity = "major"
        title    = "Line coverage at least 80%"
        query    = { "build.metadata.coverage.lines.percent" = { "$gte" = 80 } }
      },
      {
        id       = "no_critical_vulnerabilities"
        type     = "condition"
        behavior = "gate"
        severity = "critical"
        title    = "No critical vulnerabilities"
        query    = { "build.metadata.security.critical" = { "$eq" = 0 } }
      },
      {
        id              = "peer_sign_off"
        type            = "manual"
        behavior        = "gate"
        severity        = "major"
        title           = "A peer signs off the deploy"
        require_comment = true
        validations = [
          {
            id      = "four_eyes"
            message = "Someone other than the requester must sign off."
            rule    = { "actor.user_id" = { "$ne" = "$approval.requested_by" } }
          },
          {
            id      = "approver_role"
            message = "Only secops or admin can sign off."
            rule    = { "actor.effective_roles" = { "$in" = ["secops", "admin"] } }
          },
        ]
      },
    ]
  }
}
```

The definition takes the same format as the nullplatform UI and API: see [Specs and actions](https://docs.nullplatform.com/docs/approvals/checklist-specs) and the [items reference](https://docs.nullplatform.com/docs/approvals/checklist-items). It can also live in a file:

```hcl
  definition = yamldecode(file("${path.module}/checklists/prod-deploy-gate.yaml"))
```

To have the checklist decide requests, link an approval action to `module.prod_deploy_gate.current_version_id` with the [`action`](../action) module. [`examples/production-gate`](examples/production-gate) has the configuration above.

## Versions and names

- **A change publishes a version.** A different `definition` or `description` publishes a new version with a new id, and every approval action whose link references `current_version_id` moves to it in the same apply. Actions linked outside Terraform stay on the version they have.
- **The name is the identity.** A different `name` or `nrn` creates another specification and deletes this one. A name used once at an NRN cannot be created there again, even after it is deleted, so do not derive it from something that changes.
- **The API validates the definition.** The module checks only that the definition has `items`; the rest is validated by the API on apply. Key order and spacing never show in a plan.

## Adopting a specification created outside Terraform

Write the module with the `nrn`, `name`, `description` and `definition` the API returns, then import it by the id of the version (`spec_...`) or as `<nrn>/<name>`:

```hcl
import {
  to = module.prod_deploy_gate.nullplatform_checklist_specification.this
  id = "spec_0123456789abcdef"
}
```

The plan must show the import with no changes. An update means the definition or the description is not the one stored, and applying it would publish a new version. The [`action`](../action) module's README walks through adopting the approval action that evaluates it too.

## Versions

- **Provider:** `nullplatform/nullplatform` 0.0.106 or later.
- **`import` blocks** that target this module (`module.<name>.nullplatform_checklist_specification.this`, or `module.<name>["<key>"]...` with `for_each`) need OpenTofu 1.6.0 or later ([docs](https://opentofu.org/docs/v1.6/language/import/)) or Terraform 1.5.0 or later ([docs](https://developer.hashicorp.com/terraform/language/v1.5.x/import)). On Terraform 1.5 the `id` must be a literal string; an expression there needs 1.6. Without `import` blocks, `tofu import` and `terraform import` take the same address.

## Using Outputs

```hcl
module "payments_prod_approval" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/approvals/action?ref=v9.17.3"

  nrn    = "organization=1:account=2:namespace=3"
  action = "deployment:create"

  checklist = {
    specification_id = module.prod_deploy_gate.current_version_id
    on_fail          = "manual"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.106 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.113 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_checklist_specification.this](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/checklist_specification) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_definition"></a> [definition](#input\_definition) | The definition as an object: items, and optionally aggregation and execution\_trigger, in the format the nullplatform UI and API take. It is sent as given and the API validates it on apply. Changing it publishes a new version; key order and spacing are not a change. | `any` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | What the specification enforces. Changing it publishes a new version. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the specification. A name once used at an NRN cannot be created there again, even after it is deleted: do not derive it from something that changes. | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | NRN the specification lives at (e.g. organization=1:account=2). With name, it identifies the specification: changing either replaces it. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_current_version_id"></a> [current\_version\_id](#output\_current\_version\_id) | Id (spec\_...) of the current version: what an approval action links to. It changes with every new version. |
| <a name="output_id"></a> [id](#output\_id) | Id of the specification, <nrn>/<name>. Not a version id: approval actions link to current\_version\_id. |
| <a name="output_name"></a> [name](#output\_name) | Name of the specification. |
| <a name="output_nrn"></a> [nrn](#output\_nrn) | NRN the specification lives at. |
| <a name="output_version"></a> [version](#output\_version) | Number of the current version. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "checklist",
  "description": "Manages a nullplatform approval checklist specification, the items an approval action evaluates, from a definition written as a plain object",
  "architecture": "The module creates one `nullplatform_checklist_specification`, identified by `nrn` and `name`, with `definition` sent as `jsonencode(var.definition)`. The API keeps every change of the definition or the description as a new version with its own id, and the `current_version_id` output follows the newest one: the `action` module links approval actions to it, so the apply that publishes a version re-links them in the same run. The specification is created before it is destroyed, so a new `name` or `nrn` can move linked actions to the replacement.",
  "features": [
    "Creates a checklist specification from a definition written as an HCL object, or read with `yamldecode(file(...))` or `jsondecode(file(...))`",
    "Publishes a new version on every change of the definition or the description; key order and spacing are not a change",
    "Exposes `current_version_id`, the version id approval actions link to",
    "Sends the definition as given: the API validates it on apply, and the module only checks that it has `items`",
    "Replaces the specification create-before-destroy when its `name` or `nrn` changes"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "NRN the specification lives at (e.g. organization=1:account=2). With name, it identifies the specification: changing either replaces it.",
      "required": true
    },
    {
      "name": "name",
      "description": "Name of the specification. A name once used at an NRN cannot be created there again, even after it is deleted: do not derive it from something that changes.",
      "required": true
    },
    {
      "name": "definition",
      "description": "The definition as an object: items, and optionally aggregation and execution_trigger, in the format the nullplatform UI and API take. It is sent as given and the API validates it on apply. Changing it publishes a new version; key order and spacing are not a change.",
      "required": true
    },
    {
      "name": "description",
      "description": "What the specification enforces. Changing it publishes a new version.",
      "required": false
    }
  ],
  "outputs": [
    "current_version_id",
    "version",
    "id",
    "name",
    "nrn"
  ],
  "hash": "8d8fa7e32317fc9f69b597882cae12be"
}
END_AI_METADATA -->
