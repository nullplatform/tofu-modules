variable "nrn" {
  description = "NRN where the agent notification channel is anchored."
  type        = string
}

variable "api_key" {
  description = "Agent API key for the notification channel. Rotating it recreates the channel (via terraform_data.api_key_trigger)."
  type        = string
  sensitive   = true
}

variable "tags_selectors" {
  description = "Map of tags the agent uses to select/filter this channel against scope tags (e.g. { environment = \"production\" })."
  type        = map(string)
  default     = {}
}

variable "script_path" {
  description = "Command line path the agent executes to handle parameter storage and retrieval."
  type        = string
  default     = "nullplatform/parameters-provider/parameters/entrypoint"
}
