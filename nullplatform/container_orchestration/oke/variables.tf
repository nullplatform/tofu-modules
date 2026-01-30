variable "account" {
  description = "Nullplatform account ID"
  type        = string
}

variable "namespace" {
  description = "Nullplatform namespace"
  type        = string
}

variable "dimensions" {
  description = "Dimensions for the provider configuration"
  type        = map(any)
  default     = {}
}

variable "cluster_name" {
  description = "OKE cluster name"
  type        = string
}

variable "namespace_application_default" {
  description = "Default Kubernetes namespace for applications"
  type        = string
  default     = "nullplatform"
}

variable "region" {
  description = "OCI region where the OKE cluster is deployed"
  type        = string
}

variable "gateway_namespace" {
  description = "Kubernetes namespace where the gateway is deployed"
  type        = string
  default     = "gateways"
}

variable "public_gateway_name" {
  description = "Name of the public gateway"
  type        = string
  default     = "public-gateway"
}

variable "private_gateway_name" {
  description = "Name of the private gateway"
  type        = string
  default     = "private-gateway"
}
