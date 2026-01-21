terraform {
  required_providers {
    nullplatform = {
      source  = "nullplatform/nullplatform"
      version = "~> 0.0.63"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }

    # Cloud providers for gateway security resources
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }

    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }
}



