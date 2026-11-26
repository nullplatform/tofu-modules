# Module: action

## Description

Creates a nullplatform approval action decided by a checklist, and links it to a checklist specification version with what a failed checklist does to the request

## Architecture

The module creates one `nullplatform_approval_action` for an `action` at an `nrn` and its `dimensions`, deriving its `entity` from the action (`deployment` for `deployment:create`), and one `nullplatform_approval_action_checklist_specification_association` that links it to `checklist.specification_id`. `checklist.on_fail` becomes the action's `on_checklist_fail`. The action ignores changes to its `policies` attribute, which the module never sets. Several actions take `for_each` over the module.

## Features

- Creates an approval action with its entity derived from the action, so only `action` and `dimensions` are written
- Links the action to a checklist specification version, usually the `current_version_id` of the [`checklist`](../checklist) module, so a new version re-links it in the same apply
- Requires what happens when the checklist fails (`deny`, `manual` or `pending`), with no default
- Validates the `<entity>:<verb>` format of the action and the value of `on_fail`
- Leaves the action's policies alone, so an existing action can be moved into the module with a plan that changes nothing

## Basic Usage

Production deploys in a namespace evaluate a checklist kept at the account:

```hcl
module "prod_deploy_gate" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/approvals/checklist?ref=v9.17.3"

  nrn  = "organization=1:account=2"
  name = "prod-deploy-gate"

  definition = {
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
        id              = "peer_sign_off"
        type            = "manual"
        behavior        = "gate"
        severity        = "major"
        title           = "A peer signs off the deploy"
        require_comment = true
      },
    ]
  }
}

module "payments_prod_approval" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/approvals/action?ref=v9.17.3"

  nrn        = "organization=1:account=2:namespace=3" # the checklist lives in the account
  action     = "deployment:create"
  dimensions = { environment = "production" }

  checklist = {
    specification_id = module.prod_deploy_gate.current_version_id
    on_fail          = "manual" # a failed gate goes to review and the reviewers are notified
  }
}
```

`action` is one of the [approval actions](https://docs.nullplatform.com/docs/approvals/actions), such as `deployment:create`, `scope:write`, `service:action:create` or `parameter:read-secrets`. The entity is everything before the last colon.

`checklist` takes both keys, with no default:

| `on_fail` | When the checklist fails |
|---|---|
| `deny` | The request is denied. |
| `manual` | The request goes to manual review and the reviewers are notified. |
| `pending` | The request waits, without notifying anyone, until the requester fixes it, cancels it or asks for a review. |

[`examples/single-action`](examples/single-action) has the configuration above.

## Several actions and environments

One module call per action. To give several actions and environments the same checklist version, use `for_each` over the module:

```hcl
# module.nonprod_sizing is a checklist module, as in Basic Usage.
locals {
  nonprod_sizing = {
    for pair in setproduct(["scope:create", "scope:write"], ["development", "staging"]) :
    "${pair[0]}/${pair[1]}" => { action = pair[0], environment = pair[1] }
  }
}

module "nonprod_sizing_approval" {
  source   = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/approvals/action?ref=v9.17.3"
  for_each = local.nonprod_sizing

  nrn        = "organization=1:account=2"
  action     = each.value.action
  dimensions = { environment = each.value.environment }

  checklist = {
    specification_id = module.nonprod_sizing.current_version_id
    on_fail          = "deny" # a scope change over the size is rejected
  }
}
# 4 actions and 4 links: "scope:create/development", "scope:create/staging",
# "scope:write/development", "scope:write/staging"
```

The `for_each` keys are state addresses (`module.nonprod_sizing_approval["scope:create/staging"]`). Renaming a key or the module block destroys that action and creates another one with a new id, unless a [`moved`](https://opentofu.org/docs/language/modules/develop/refactoring/) block goes with the rename. The API rejects a second action with the same action, NRN and dimensions on apply. [`examples/several-actions`](examples/several-actions) has the whole configuration.

## Adopting an action that already evaluates a checklist

An approval action that is a `nullplatform_approval_action` resource in your configuration, linked to a checklist specification created outside Terraform, moves into the two modules with a plan that changes nothing:

1. Read from the API the action (its id and `on_checklist_fail`) and the specification version it is linked to (its id, `nrn`, `name`, `description` and `definition`).
2. Write both modules with those exact values. Put the definition as the API returns it, every key included, in a JSON file.
3. Add an `import` block for the specification and one for the link, and a `moved` block for the action. An action that is not in your configuration takes a third `import` block (by the action's id) instead of the `moved` block.
4. Remove the raw action resource.
5. Run the plan, and apply only if it shows what the list below says.

```hcl
module "payments_prod_gate" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/approvals/checklist?ref=v9.17.3"

  nrn         = "organization=1:account=2:namespace=3"
  name        = "payments-prod-gate"
  description = "Production deploys: line coverage and a peer sign-off"
  definition  = jsondecode(file("${path.module}/checklists/payments-prod-gate.json"))
}

module "payments_prod_approval" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/approvals/action?ref=v9.17.3"

  nrn        = "organization=1:account=2:namespace=3"
  action     = "deployment:create"
  dimensions = { environment = "production" }

  checklist = {
    specification_id = module.payments_prod_gate.current_version_id
    on_fail          = "manual" # the on_checklist_fail the action has today
  }
}

import {
  to = module.payments_prod_gate.nullplatform_checklist_specification.this
  id = "spec_0123456789abcdef" # the version the action evaluates
}

import {
  to = module.payments_prod_approval.nullplatform_approval_action_checklist_specification_association.this
  id = "123" # the action's id
}

moved {
  from = nullplatform_approval_action.deployment_create
  to   = module.payments_prod_approval.nullplatform_approval_action.this
}
```

The plan must show:

- the specification and the link imported, with no changes;
- the action moved, with no update and no replacement;
- nothing else.

An update on the specification means the definition or the description is not the one stored: applying it publishes a new version and re-links the action. A replacement means the `name` or the `nrn` differs. An update of `on_checklist_fail` means `on_fail` is not the value the action has. If the specification has a version newer than the one the action evaluates, the plan re-links the action to it.

With `for_each` on the modules, the key goes in the module address: `module.payments_prod_approval["<key>"].nullplatform_approval_action.this`. A raw resource with `for_each` moves from its instance, `nullplatform_approval_action.deployment_create["<key>"]`. [`examples/adopt-existing`](examples/adopt-existing) has the whole configuration.

## What the module does not do

- **Policies.** The module has no input for policies, and it ignores the action's `policies` attribute: while an action is linked, the provider stops reading its policies back, so the state can keep a list from before. An action decided by policies stays as provider resources.
- **Policy callbacks.** It does not set `on_policy_success` or `on_policy_fail`.
- **A list of actions.** It checks that `action` is `<entity>:<verb>` in lowercase letters and underscores, with a hyphen only in the verb (`parameter:read-secrets`), not that the action exists, so a new kind of action in that format needs no new release of the module.
- **A default for `on_fail`.** Without a value, linking a specification sets `deny` or `pending` depending on the action's `on_policy_fail`, and an action replaced later (a new dimension, a renamed key) would take that value without the plan showing it. With `on_fail` written, the plan shows every change and a replaced action keeps it.

## Versions

- **Provider:** `nullplatform/nullplatform` 0.0.106 or later.
- **`import` blocks** that target this module (`module.<name>.<resource>.this`, or `module.<name>["<key>"]...` with `for_each`) need OpenTofu 1.6.0 or later ([docs](https://opentofu.org/docs/v1.6/language/import/)) or Terraform 1.5.0 or later ([docs](https://developer.hashicorp.com/terraform/language/v1.5.x/import)). On Terraform 1.5 the `id` must be a literal string; an expression there needs 1.6. Without `import` blocks, `tofu import` and `terraform import` take the same address.

## Using Outputs

```hcl
output "payments_prod_approval_id" {
  value = module.payments_prod_approval.id
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
| [nullplatform_approval_action.this](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/approval_action) | resource |
| [nullplatform_approval_action_checklist_specification_association.this](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/approval_action_checklist_specification_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action"></a> [action](#input\_action) | The action that needs approval, as <entity>:<verb> (e.g. deployment:create, scope:write, service:action:create). The entity is what comes before the last colon. Changing it replaces the action. | `string` | n/a | yes |
| <a name="input_checklist"></a> [checklist](#input\_checklist) | The checklist the action evaluates, with both keys required. specification\_id is the specification version to link, usually module.<checklist>.current\_version\_id. on\_fail is what happens to a request when the checklist fails: deny rejects it; manual sends it to manual review and notifies the reviewers; pending keeps it waiting, without notifying anyone, until the requester fixes it, cancels it or asks for a review. | <pre>object({<br/>    specification_id = string<br/>    on_fail          = string<br/>  })</pre> | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimensions the action applies to (e.g. { environment = "production" }). Leave it empty for an action without dimensions. Changing it replaces the action. | `map(string)` | `{}` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | NRN the approval action applies at (e.g. organization=1:account=2:namespace=3). Changing it replaces the action. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_action"></a> [action](#output\_action) | The action that needs approval. |
| <a name="output_dimensions"></a> [dimensions](#output\_dimensions) | Dimensions the action applies to. |
| <a name="output_entity"></a> [entity](#output\_entity) | Entity of the action, derived from it (deployment for deployment:create). |
| <a name="output_id"></a> [id](#output\_id) | Id of the approval action. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "action",
  "description": "Creates a nullplatform approval action decided by a checklist, and links it to a checklist specification version with what a failed checklist does to the request",
  "architecture": "The module creates one `nullplatform_approval_action` for an `action` at an `nrn` and its `dimensions`, deriving its `entity` from the action (`deployment` for `deployment:create`), and one `nullplatform_approval_action_checklist_specification_association` that links it to `checklist.specification_id`. `checklist.on_fail` becomes the action's `on_checklist_fail`. The action ignores changes to its `policies` attribute, which the module never sets. Several actions take `for_each` over the module.",
  "features": [
    "Creates an approval action with its entity derived from the action, so only `action` and `dimensions` are written",
    "Links the action to a checklist specification version, usually the `current_version_id` of the `checklist` module, so a new version re-links it in the same apply",
    "Requires what happens when the checklist fails (`deny`, `manual` or `pending`), with no default",
    "Validates the `<entity>:<verb>` format of the action and the value of `on_fail`",
    "Leaves the action's policies alone, so an existing action can be moved into the module with a plan that changes nothing"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "NRN the approval action applies at (e.g. organization=1:account=2:namespace=3). Changing it replaces the action.",
      "required": true
    },
    {
      "name": "action",
      "description": "The action that needs approval, as <entity>:<verb> (e.g. deployment:create, scope:write, service:action:create). The entity is what comes before the last colon. Changing it replaces the action.",
      "required": true
    },
    {
      "name": "checklist",
      "description": "The checklist the action evaluates, with both keys required. specification_id is the specification version to link, usually module.<checklist>.current_version_id. on_fail is what happens to a request when the checklist fails: deny rejects it; manual sends it to manual review and notifies the reviewers; pending keeps it waiting, without notifying anyone, until the requester fixes it, cancels it or asks for a review.",
      "required": true
    },
    {
      "name": "dimensions",
      "description": "Dimensions the action applies to (e.g. { environment = \"production\" }). Leave it empty for an action without dimensions. Changing it replaces the action.",
      "required": false
    }
  ],
  "outputs": [
    "id",
    "entity",
    "action",
    "dimensions"
  ],
  "hash": "a7158755fe08601fd489553d3a61b7ae"
}
END_AI_METADATA -->
