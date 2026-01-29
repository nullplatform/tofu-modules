terraform {
  required_providers {
    nullplatform = {
      source  = "nullplatform/nullplatform"
      version = "~> 0.0.76"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }

    aws = {
      source                = "hashicorp/aws"
      version               = "~> 6.0"
      configuration_aliases = [aws]
    }

    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "~> 4.0"
      configuration_aliases = [azurerm]
    }

    google = {
      source                = "hashicorp/google"
      version               = "~> 5.0"
      configuration_aliases = [google]
    }
  }
}
