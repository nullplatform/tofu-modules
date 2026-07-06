variable "nrn" {
  description = "NRN where the provider specification is anchored (the top-level scope it belongs to)."
  type        = string
}

variable "np_api_key" {
  description = "nullplatform API key. Kept for interface consistency across the parameter-storage modules; the provider is configured at the root."
  type        = string
  sensitive   = true
}

variable "extra_visible_to_nrns" {
  description = "Additional NRNs that should see the provider specification besides var.nrn. Callers registering instances at other NRNs (via parameter_storage_configuration) should list those NRNs here so the spec is visible where the instances are anchored."
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