variable "tenancy_id" {
  type        = string
  description = "OCID of the tenancy (dynamic groups are created at tenancy level)"
}

variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where resources are located"
}

variable "cluster_id" {
  type        = string
  description = "OCID of the OKE cluster"
}

variable "workload_name" {
  type        = string
  description = "Name of the workload (e.g., external-dns, cert-manager)"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace where the workload runs"
}

variable "service_account" {
  type        = string
  description = "Name of the Kubernetes service account"
}

variable "enable_dns_permissions" {
  type        = bool
  description = "Enable automatic DNS policy statements (inspect, read, use dns-zones and manage dns-records)"
  default     = false
}

variable "additional_policy_statements" {
  type        = list(string)
  description = "Additional custom OCI IAM policy statements to apply"
  default     = []
}

variable "name_prefix" {
  type        = string
  description = "Prefix for resource names"
  default     = "oke"
}

variable "defined_tags" {
  type        = map(string)
  description = "Defined tags for resources"
  default     = {}
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags for resources"
  default     = {}
}
