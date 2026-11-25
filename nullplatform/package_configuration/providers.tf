terraform {
  required_version = ">= 1.5"

  # terraform_data is built in. The record is read back with the external
  # data source, which runs `np package status`.
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = ">= 2.3"
    }
  }
}
