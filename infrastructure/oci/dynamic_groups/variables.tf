variable "tenancy_id" {
  type        = string
  description = "OCID of the tenancy (dynamic groups are created at tenancy level)"
}

variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where resources are located (cluster, DNS zones)"
}

variable "cluster_id" {
  type        = string
  description = "OCID of the OKE cluster"
}

variable "external_dns_namespace" {
  type        = string
  description = "Kubernetes namespace where external-dns runs"
  default     = "external-dns"
}

variable "external_dns_service_account" {
  type        = string
  description = "Name of the external-dns service account"
  default     = "external-dns"
}

variable "dns_zone_ids" {
  type        = list(string)
  description = "List of DNS zone OCIDs that external-dns can manage (optional, if not specified allows all zones in the compartment)"
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
