variable "nrn" {
  description = "NRN the workflow belongs to (e.g. organization=1:account=2). Null: the organization. The API key Terraform uses needs the workflow permissions at this NRN. Changing it moves the workflow, without a new revision."
  type        = string
  default     = null
}

variable "key" {
  description = "Stable handle of the workflow, lowercase letters, digits and hyphens (up to 63, starting with a letter or digit), unique in the organization. It cannot be changed or added later: a different key replaces the workflow. Null: the workflow has no key, and cannot get one."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the workflow. Changing it renames the record without publishing a revision."
  type        = string
}

variable "description" {
  description = "What the workflow does. Null: none."
  type        = string
  default     = null
}

variable "folder" {
  description = "Folder the workflow lives in (e.g. /governance/checklists): a leading /, segments joined by one /, no trailing /. Null: the folder is left as it is; an empty string is refused."
  type        = string
  default     = null
}

variable "definition" {
  description = "The workflow graph as an object: steps (a map of step id to step), connections, inputs, variables, execution, outputs and any other key the engine takes, in the format the nullplatform UI and API take. name, key, description, path, nrn, id, triggers and pinnedDescriptors are not part of it: the first five are inputs of this module, the rest the API derives. Changing it publishes a new revision, and the alias follows it in the same apply."
  type        = any

  validation {
    condition     = can(keys(var.definition.steps))
    error_message = "definition must be an object with steps, a map of step id to step. Pass the object itself (or yamldecode/jsondecode of a file), not jsonencode of it."
  }

  validation {
    condition = try(
      length(setintersection(
        toset(keys(var.definition)),
        toset(["name", "key", "description", "path", "nrn", "id", "triggers", "pinnedDescriptors"])
      )) == 0,
      true
    )
    error_message = "definition must not contain name, key, description, path, nrn, id, triggers or pinnedDescriptors: the first five are inputs of this module (path is folder), and the API derives the rest."
  }

  validation {
    condition = try(
      alltrue([
        for step in values(var.definition.steps) :
        try(step.pluginType, "") != "np-checklist-trigger" || try(step.config.nrn, "") != ""
      ]),
      true
    )
    error_message = "Every np-checklist-trigger step needs config.nrn, the NRN where its notification channel is created."
  }
}

variable "alias" {
  description = "Alias that serves the workflow and registers its triggers. It follows the latest revision this module publishes. Null: no alias, for a workflow other workflows call by its latest revision; a definition with a channel trigger (np-checklist-trigger, np-action-item-trigger, np-scope-trigger, np-deployment-trigger) needs one."
  type        = string
  default     = "live"

  validation {
    condition     = var.alias == null || (var.alias != "" && var.alias != "latest")
    error_message = "alias must not be empty or latest: the API maintains latest itself."
  }
}

variable "active" {
  description = "Whether the alias is active, which registers the triggers of its revision (webhooks, notification channels). False: the alias exists and points at the revision, and nothing listens. Ignored when alias is null."
  type        = bool
  default     = true
}
