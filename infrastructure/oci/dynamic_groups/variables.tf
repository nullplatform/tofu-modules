variable "tenancy_id" {
  type        = string
  description = "OCID del tenancy (los dynamic groups se crean a nivel de tenancy)"
}

variable "compartment_id" {
  type        = string
  description = "OCID del compartment donde están los recursos (cluster, DNS zones)"
}

variable "cluster_id" {
  type        = string
  description = "OCID del cluster OKE"
}

variable "external_dns_namespace" {
  type        = string
  description = "Namespace de Kubernetes donde corre external-dns"
  default     = "external-dns"
}

variable "external_dns_service_account" {
  type        = string
  description = "Nombre del service account de external-dns"
  default     = "external-dns"
}

variable "dns_zone_ids" {
  type        = list(string)
  description = "Lista de OCIDs de las DNS zones que external-dns puede gestionar (opcional, si no se especifica permite todas en el compartment)"
  default     = []
}

variable "name_prefix" {
  type        = string
  description = "Prefijo para los nombres de los recursos"
  default     = "oke"
}

variable "defined_tags" {
  type        = map(string)
  description = "Defined tags para los recursos"
  default     = {}
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags para los recursos"
  default     = {}
}
