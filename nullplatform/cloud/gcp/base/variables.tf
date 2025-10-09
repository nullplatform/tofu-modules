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

variable "np_api_key" {
  type        = string
  sensitive   = true
  description = "Nullplatform API key for authentication"
}


variable "kubeconfig_path" {
  description = "Path to the kubeconfig file for Kubernetes cluster access"
  type        = string
  default     = "~/.kube/config"
}

variable "kube_context" {
  description = "Kubernetes context name to use from the kubeconfig file"
  type        = string
  default     = null
}
