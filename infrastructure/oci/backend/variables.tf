variable "compartment_id" {
  description = "OCID del compartment donde se creará el bucket"
  type        = string
}

variable "bucket_name" {
  description = "Nombre del bucket para almacenar el estado de OpenTofu"
  type        = string
  default     = "tofu-state"
}

variable "namespace" {
  description = "Object Storage namespace (generalmente el nombre del tenancy)"
  type        = string
}

variable "access_type" {
  description = "Tipo de acceso al bucket (NoPublicAccess, ObjectRead, ObjectReadWithoutList)"
  type        = string
  default     = "NoPublicAccess"
}

variable "versioning" {
  description = "Habilitar versionado de objetos para el bucket"
  type        = string
  default     = "Enabled"
  validation {
    condition     = contains(["Enabled", "Disabled", "Suspended"], var.versioning)
    error_message = "El valor debe ser 'Enabled', 'Disabled' o 'Suspended'."
  }
}

variable "storage_tier" {
  description = "Tier de almacenamiento (Standard, Archive)"
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "Tags de formato libre para el bucket"
  type        = map(string)
  default     = {}
}
