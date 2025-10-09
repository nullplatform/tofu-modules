variable "nullplatform_base_helm_version" {
  description = "Helm chart version for the Nullplatform agent"
  type        = string
  default     = "2.12.0"
}

variable "namespace" {
  description = "Kubernetes namespace to agent run"
  type        = string
  default     = "nullplatform-tools"
}

variable "nrn" {
  description = "Identifier Nullplatform Resources Name"
  type        = string
}