variable "nrn" {
  description = "NRN where the provider specification is anchored (the top-level scope it belongs to)."
  type        = string
}

variable "np_api_key" {
  description = "nullplatform API key used by the upstream scope_configuration module to register provider instances."
  type        = string
  sensitive   = true
}

variable "extra_visible_to_nrns" {
  description = "Additional NRNs that should see the provider specification besides var.nrn and the per-instance NRNs."
  type        = list(string)
  default     = []
}

variable "template_path" {
  description = "Path to the parameter storage specification template"
  type        = string
}

variable "repository_parameter_storage_spec" {
  description = "repository of parameter storage spec"
  type        = string
  default     = "https://raw.githubusercontent.com/nullplatform/parameters/refs/heads"
}

variable "repository_parameter_storage_spec_branch" {
  description = "branch reference of parameter storage spec"
  type        = string
  default     = "main"
}

variable "instances" {
  description = <<-EOT
    Provider instances to create. Map key is a stable identifier (used in for_each).
    Each entry carries its own NRN, dimensions, and a provider-specific `attributes`
    object that each caller shapes to match its provider specification schema (e.g.
    Parameter Store sends setup.tier, Secrets Manager omits it).
    Each instance also gets its own agent API key + notification channel (anchored at the
    instance NRN) unless notification_channel_enabled=false. Fields:
      attributes                   — provider-specific config matching the provider spec schema (opaque here).
  EOT
  type = map(object({
    nrn                          = string
    dimensions                   = map(string)
    attributes                   = any
  }))
  default = {}
}