variable "prometheus_namespace" {
  description = "Kubernetes namespace where Prometheus will be deployed"
  type        = string
  default     = "prometheus"
}

variable "nrn" {
  description = "Nullplatform Resource Name - unique identifier for resources"
  type        = string
}

variable "np_api_key" {
  description = "Nullplatform API key for authentication"
  type        = string
  sensitive   = true
}

variable "nullplatform_port" {
  description = "Port number for Nullplatform service communication"
  type        = number
  default     = 2021
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

