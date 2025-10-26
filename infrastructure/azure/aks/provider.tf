terraform {
  required_version = "~> 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.41.0"
    }
  }
}
/*
provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  use_cli                         = true
  subscription_id                 = var.subscription_id
}
*/
