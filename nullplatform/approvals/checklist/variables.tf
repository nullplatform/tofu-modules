variable "nrn" {
  description = "NRN the specification lives at (e.g. organization=1:account=2). With name, it identifies the specification: changing either replaces it."
  type        = string
}

variable "name" {
  description = "Name of the specification. A name once used at an NRN cannot be created there again, even after it is deleted: do not derive it from something that changes."
  type        = string
}

variable "description" {
  description = "What the specification enforces. Changing it publishes a new version."
  type        = string
  default     = null
}

variable "definition" {
  description = "The definition as an object: items, and optionally aggregation and execution_trigger, in the format the nullplatform UI and API take. It is sent as given and the API validates it on apply. Changing it publishes a new version; key order and spacing are not a change."
  type        = any

  validation {
    condition     = can(var.definition.items)
    error_message = "definition must be an object with items. Pass the object itself (or yamldecode/jsondecode of a file), not jsonencode of it."
  }
}
