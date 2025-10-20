variable "np_api_key" {
  type        = string
  description = "Your nullplatform api key(developer.member, ops and secops permissions)"

}
variable "azure_subscription_id" {
  type        = string
  description = "Your azure suscription id"

}

variable "azure_tenant_id" {
  type        = string
  description = "Your azure tenant id"

}

variable "nrn" {
  type        = string
  description = "The nrn of your nullplatform account"

}
variable "domain_name" {
  description = "The domain name to be used"
  type        = string
  default     = ""

}

variable "azure_resource_group_name" {
  type        = string
  description = "Your azure reource group name"

}

variable "dimensions" {
  type        = map(any)
  description = "Define to dimensions, for more information https://docs.nullplatform.com/docs/dimensions"
  default     = {}
}