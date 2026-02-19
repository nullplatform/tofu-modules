terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
    nullplatform = {
      source  = "nullplatform/nullplatform"
      version = "~> 0.0.74"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

provider "kubernetes" {
  host                   = module.eks.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.eks_cluster_ca)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = var.aws_profile != null ? [
      "eks", "get-token",
      "--cluster-name", module.eks.eks_cluster_name,
      "--profile", var.aws_profile
      ] : [
      "eks", "get-token",
      "--cluster-name", module.eks.eks_cluster_name
    ]
  }
}

provider "helm" {
  kubernetes = {
    host                   = module.eks.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.eks_cluster_ca)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = var.aws_profile != null ? [
        "eks", "get-token",
        "--cluster-name", module.eks.eks_cluster_name,
        "--profile", var.aws_profile
        ] : [
        "eks", "get-token",
        "--cluster-name", module.eks.eks_cluster_name
      ]
    }
  }
}

provider "nullplatform" {
  api_key = var.np_api_key
}
