variable "vpc" {
  description = "VPC configuration settings"
  type = object({
    cidr_block      = string
    azs             = list(string)
    private_subnets = list(string)
    public_subnets  = list(string)
  })
}

variable "organization" {
  type        = string
  description = "A organization name"
}

variable "account" {
  type        = string
  description = "The account name"
}