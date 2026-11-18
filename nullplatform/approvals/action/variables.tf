variable "nrn" {
  description = "NRN the approval action applies at (e.g. organization=1:account=2:namespace=3). Changing it replaces the action."
  type        = string
}

variable "action" {
  description = "The action that needs approval, as <entity>:<verb> (e.g. deployment:create, scope:write, service:action:create). The entity is what comes before the last colon. Changing it replaces the action."
  type        = string

  validation {
    condition     = can(regex("^[a-z_]+(:[a-z_]+)*:[a-z_-]+$", var.action))
    error_message = "action must be <entity>:<verb> in lowercase letters and underscores, with a hyphen only in the verb, e.g. deployment:create, parameter:read-secrets or service:action:create."
  }
}

variable "dimensions" {
  description = "Dimensions the action applies to (e.g. { environment = \"production\" }). Leave it empty for an action without dimensions. Changing it replaces the action."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "checklist" {
  description = "The checklist the action evaluates, with both keys required. specification_id is the specification version to link, usually module.<checklist>.current_version_id. on_fail is what happens to a request when the checklist fails: deny rejects it; manual sends it to manual review and notifies the reviewers; pending keeps it waiting, without notifying anyone, until the requester fixes it, cancels it or asks for a review."
  type = object({
    specification_id = string
    on_fail          = string
  })
  nullable = false

  validation {
    condition     = try(contains(["deny", "manual", "pending"], var.checklist.on_fail), false)
    error_message = "checklist.on_fail must be deny, manual or pending."
  }
}
