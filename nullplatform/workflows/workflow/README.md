# Module: workflow

## Description

Manages a nullplatform workflow, its definition and the alias that serves it and registers its triggers, from a definition written as a plain object

## Architecture

The module creates one `nullplatform_workflow`, with `definition` sent as `jsonencode(var.definition)`, and by default one `nullplatform_workflow_alias` that serves the workflow's latest revision. The API keeps every change of the definition as a new revision, and the alias takes `revision` from the workflow, so the apply that publishes a revision moves the alias in the same run and, while the alias is active, registers the triggers of the new revision (webhooks and, for the checklist, action item, scope and deployment triggers, notification channels). The `item_kinds` and `validation_kinds` outputs read the kinds the definition's checklist triggers serve, and wait for the alias, so a checklist that takes its kinds from them is published once the workflow listens.

## Features

- Creates a workflow from a definition written as an HCL object, or read with `yamldecode(file(...))` or `jsondecode(file(...))`
- Publishes a new revision on every change of the definition, and moves the alias to it in the same apply
- Creates an alias (`live` by default) that registers the workflow's triggers, and can leave it inactive or leave it out
- Exposes the webhook URL of each trigger (sensitive) and the kinds served by the definition's `np-checklist-trigger` steps
- Refuses what the API would refuse late or never notice: a definition without steps, one that carries the record's own keys, a checklist trigger without an NRN, a channel trigger without an alias

## Basic Usage

A workflow started by a webhook.

```hcl
module "notify" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/workflows/workflow?ref=v9.20.0"

  key  = "notify"
  name = "Notify"

  definition = {
    steps = {
      on_webhook = {
        id         = "on_webhook"
        type       = "trigger"
        pluginType = "webhook"
        config     = { path = "/notify", mode = "start" }
      }
    }
    connections = []
  }
}
```

The definition takes the same format as the nullplatform UI and API. It can also live in a file:

```hcl
  # file(), not templatefile(): the workflow's ${{ }} expressions are not
  # Terraform's, and file() leaves them as they are.
  definition = yamldecode(file("${path.module}/workflows/notify.yaml"))
```

`name`, `key`, `description`, `folder` and `nrn` are inputs of the module, not keys of the definition: a definition that carries `name`, `key`, `description`, `path` or `nrn` is refused, and so is one with `id`, `triggers` or `pinnedDescriptors`, which the API derives. [`examples/webhook-trigger`](examples/webhook-trigger) has the configuration above, and [`examples/checklist-gate`](examples/checklist-gate) a workflow that serves a checklist.

## Revisions and the alias

- **A change publishes a revision.** A different `definition` is a new revision; key order and spacing are not a change. The alias follows `revision` in the same apply and registers the new revision's triggers again. Changing `name`, `description` or `folder` changes the record and publishes no revision.
- **`active = false`** leaves the alias pointing at the revision with nothing registered: no webhook answers and no notification channel exists. Setting it back registers them.
- **`alias = null`** creates no alias, for a workflow that other workflows call by its latest revision. A definition with a channel trigger (`np-checklist-trigger`, `np-action-item-trigger`, `np-scope-trigger`, `np-deployment-trigger`) is refused without one: nothing would register the trigger.
- **The key is the identity.** It cannot be changed or added later: a different `key`, or adding one to a workflow that has none, replaces the workflow.
- **Destroying** deactivates the alias, which deletes the notification channels its triggers created, then deletes it and the workflow. If a channel cannot be deleted, the destroy fails and keeps the alias, so the next run retries the release.

## Checklists: kinds through the outputs

A checklist item or validation that an `np-checklist-trigger` step serves names the step's `kind`. A checklist takes it from the module's outputs instead of repeating the string:

- `item_kinds`: for each trigger step that listens to item dispatches (its `action` is `checklist:item:dispatched`, the default), the step id and its `kind`. An external item takes `module.<name>.item_kinds["<step>"]`.
- `validation_kinds`: the same for the steps that listen to `checklist:item:validation_dispatched`, for an item's external validation.

A step with `channelActions` set and not empty listens to those actions, and `action` is ignored. A step whose `kind` is `"*"` listens to every kind and is in neither output.

The outputs exist for ordering, as much as for avoiding the repeated string. A trigger creates its notification channel when the alias is activated, and an item dispatched before that finds no channel: it waits and times out. Both outputs depend on the alias, so a checklist that reads them is created after the workflow listens, and on a change of kind the checklist is updated after the new channel exists.

```hcl
module "payments_gate_workflow" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/workflows/workflow?ref=v9.20.0"

  nrn  = "organization=1"
  key  = "payments-gate"
  name = "Payments gate"

  definition = yamldecode(file("${path.module}/workflows/payments-gate.yaml"))
}

resource "nullplatform_checklist_specification" "payments_gate" {
  nrn  = "organization=1"
  name = "payments-prod-gate"

  definition = jsonencode({
    items = [
      {
        id       = "security_scan"
        type     = "external"
        behavior = "gate"
        severity = "major"
        title    = "Security scan passes"
        external = { kind = module.payments_gate_workflow.item_kinds["on_item"] }
      },
    ]
  })
}
```

A checklist module takes the same expression wherever its definition names an external item's kind.

### Renaming a kind used by production gates

A kind is the contract between the checklist and the workflow: changing it in one apply leaves a window where items are dispatched with a kind nobody listens to. Do it in three applies:

1. Add a trigger step with the new kind and its own `pathPrefix` (two triggers cannot share one). Both kinds are served.
2. Move the checklists to the new kind (they read it from `item_kinds`, so this is a change of the step they name) and apply: the checklists publish new versions that dispatch the new kind.
3. Remove the old step once no checklist version in use dispatches its kind.

## Adopting a workflow created outside Terraform

Write the module with the `name`, `key`, `nrn` and `definition` the API returns, then import the workflow by its id (`wf_...`), by an older id, or by its key, and the alias as `<workflow id or key>/<alias>`:

```hcl
import {
  to = module.notify.nullplatform_workflow.this
  id = "wf_AbCd1234"
}

import {
  to = module.notify.nullplatform_workflow_alias.this[0]
  id = "wf_AbCd1234/live"
}
```

With several workflows, `for_each` over the keys:

```hcl
locals {
  workflows = { notify = "wf_AbCd1234", cleanup = "wf_EfGh5678" }
}

import {
  for_each = local.workflows
  to       = module.workflow[each.key].nullplatform_workflow.this
  id       = each.value
}

import {
  for_each = local.workflows
  to       = module.workflow[each.key].nullplatform_workflow_alias.this[0]
  id       = "${each.value}/live"
}
```

The plan must show the imports with no changes. An update means the definition is not the stored one, and applying it would publish a revision; a workflow whose alias is active and whose definition changes re-registers its triggers.

## What the API key must be allowed to do

The provider's API key (`NULLPLATFORM_API_KEY`) acts on the platform in the module's name, and activation and deactivation of an alias act as that key, not as the engine. At the workflow's NRN it must be allowed to write workflows, publish them (the deploy of a revision), activate aliases and delete workflows. When the definition has code steps, it must be allowed to run code. And at the NRN of each channel trigger (`config.nrn` of `np-checklist-trigger` and the like) it must be allowed to create and delete notification channels: activation creates the channel and deactivation, including the one on destroy, deletes it. A key that lacks one of these fails the apply or the destroy with the API's refusal in the error.

## Versions

- **Provider:** `nullplatform/nullplatform` 0.0.114 or later, the first release with the workflow resources.
- **`import` blocks** that target this module (`module.<name>.nullplatform_workflow.this`, or `module.<name>["<key>"]...` with `for_each`) need OpenTofu 1.6.0 or later ([docs](https://opentofu.org/docs/v1.6/language/import/)) or Terraform 1.5.0 or later ([docs](https://developer.hashicorp.com/terraform/language/v1.5.x/import)). On Terraform 1.5 the `id` must be a literal string; an expression there needs 1.6. Without `import` blocks, `tofu import` and `terraform import` take the same address.

## Using Outputs

```hcl
resource "example_resource" "this" {
  example_attribute = module.notify.id
}
```

`webhook_urls` is sensitive; read it with `tofu output -json webhook_urls`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.114 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | >= 0.0.114 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_workflow.this](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/workflow) | resource |
| [nullplatform_workflow_alias.this](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/workflow_alias) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active"></a> [active](#input\_active) | Whether the alias is active, which registers the triggers of its revision (webhooks, notification channels). False: the alias exists and points at the revision, and nothing listens. Ignored when alias is null. | `bool` | `true` | no |
| <a name="input_alias"></a> [alias](#input\_alias) | Alias that serves the workflow and registers its triggers. It follows the latest revision this module publishes. Null: no alias, for a workflow other workflows call by its latest revision; a definition with a channel trigger (np-checklist-trigger, np-action-item-trigger, np-scope-trigger, np-deployment-trigger) needs one. | `string` | `"live"` | no |
| <a name="input_definition"></a> [definition](#input\_definition) | The workflow graph as an object: steps (a map of step id to step), connections, inputs, variables, execution, outputs and any other key the engine takes, in the format the nullplatform UI and API take. name, key, description, path, nrn, id, triggers and pinnedDescriptors are not part of it: the first five are inputs of this module, the rest the API derives. Changing it publishes a new revision, and the alias follows it in the same apply. | `any` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | What the workflow does. Null: none. | `string` | `null` | no |
| <a name="input_folder"></a> [folder](#input\_folder) | Folder the workflow lives in (e.g. /governance/checklists): a leading /, segments joined by one /, no trailing /. Null: the folder is left as it is; an empty string is refused. | `string` | `null` | no |
| <a name="input_key"></a> [key](#input\_key) | Stable handle of the workflow, lowercase letters, digits and hyphens (up to 63, starting with a letter or digit), unique in the organization. It cannot be changed or added later: a different key replaces the workflow. Null: the workflow has no key, and cannot get one. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the workflow. Changing it renames the record without publishing a revision. | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | NRN the workflow belongs to (e.g. organization=1:account=2). Null: the organization. The API key Terraform uses needs the workflow permissions at this NRN. Changing it moves the workflow, without a new revision. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alias"></a> [alias](#output\_alias) | Name of the alias, or null when the module creates none. |
| <a name="output_id"></a> [id](#output\_id) | Id of the workflow (wf\_...): what other workflows and aliases refer to it by. |
| <a name="output_item_kinds"></a> [item\_kinds](#output\_item\_kinds) | For each np-checklist-trigger step that listens to item dispatches, by step id, the kind it serves. A checklist's external item takes its kind from here, so the checklist is published once the workflow listens. Triggers of kind "*" are left out. |
| <a name="output_key"></a> [key](#output\_key) | Key of the workflow, or null when it has none. |
| <a name="output_revision"></a> [revision](#output\_revision) | Number of the latest revision. It changes with every new definition. |
| <a name="output_validation_kinds"></a> [validation\_kinds](#output\_validation\_kinds) | For each np-checklist-trigger step that listens to validation dispatches, by step id, the kind it serves. A checklist item's external validation takes its kind from here, so the checklist is published once the workflow listens. Triggers of kind "*" are left out. |
| <a name="output_webhook_urls"></a> [webhook\_urls](#output\_webhook\_urls) | Webhook URL of each trigger of the alias's revision that has one, by trigger id. Empty while the alias is inactive or absent. Sensitive: the URL ends in a capability token. |
<!-- END_TF_DOCS -->
