variable "nrn" {
  description = "NRN where the agent notification channel is anchored."
  type        = string
}

variable "api_key" {
  description = "Deprecated: omit it. When null (default) the platform creates and manages the channel credential (an API key holding only controlplane:agent-dispatcher on the channel NRN); the identity running the apply must be able to assign that role. Passing a key keeps using it; removing it later converts the channel in place (same id). Requires nullplatform provider >= 0.0.107."
  type        = string
  default     = null
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

variable "description" {
  description = "Description shown for the notification channel."
  type        = string
  default     = ""
}
