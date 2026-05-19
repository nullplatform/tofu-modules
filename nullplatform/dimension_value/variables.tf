variable "dimension_id" {
  description = "ID of the parent dimension this value belongs to. Typically the `id` output of a `dimension` module instance."
  type        = number
}

variable "name" {
  description = "Name of the dimension value. The same name is applied to every NRN."
  type        = string
}

variable "nrn" {
  description = "Single NRN where this dimension value should be created. Use this for one NRN. Mutually exclusive with `nrns`."
  type        = string
  default     = null
}

variable "nrns" {
  description = "List of NRNs where this dimension value should be created (one resource per NRN). Use this for multiple NRNs. Mutually exclusive with `nrn`."
  type        = list(string)
  default     = []
}
