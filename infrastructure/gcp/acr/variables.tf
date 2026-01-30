###############################################################################
# REQUIRED VARIABLES
###############################################################################

variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "location" {
  type        = string
  description = "The GCP region where the container registry will be created (e.g., us-central1, europe-west1)"
}

variable "containerregistry_name" {
  type        = string
  description = "The name of the container registry (repository ID)"
}

###############################################################################
# OPTIONAL VARIABLES - REGISTRY CONFIGURATION
###############################################################################

variable "format" {
  type        = string
  description = "The format of the repository (DOCKER, NPM, PYTHON, etc)"
  default     = "DOCKER"
}

###############################################################################
# OPTIONAL VARIABLES - TAGS AND METADATA
###############################################################################

variable "tags" {
  type        = map(string)
  description = "A mapping of labels to assign to the container registry"
  default     = {}
}
