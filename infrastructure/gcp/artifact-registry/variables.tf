variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "location" {
  type        = string
  description = "The location for the repository"
}

variable "repository_id" {
  type        = string
  description = "The repository ID (name)"
}

variable "format" {
  type        = string
  description = "The format (DOCKER, NPM, PYTHON, etc)"
  default     = "DOCKER"
}
