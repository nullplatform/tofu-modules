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

variable "policy_statements" {
  type        = list(string)
  description = "List of OCI IAM policy statements to apply"
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
