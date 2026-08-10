variable "nrn" {
  description = "Nullplatform Resource Name (NRN) — unique identifier for the target resource."
  type        = string
}

variable "type" {
  description = "Provider specification slug this scope configuration targets. Determines which set of variables below applies — see README for each type's payload."
  type        = string

  validation {
    condition     = contains(["static-files", "aws-lambda"], var.type)
    error_message = "type must be one of: static-files, aws-lambda."
  }
}

variable "dimensions" {
  description = "Dimension values for this configuration."
  type        = map(string)
  default     = {}
}

################################################################################
# static-files
################################################################################

variable "cloud_provider" {
  description = "static-files only. Cloud provider for this static-files scope configuration."
  type        = string
  default     = null

  validation {
    condition     = var.type != "static-files" || var.cloud_provider != null
    error_message = "cloud_provider is required when type is 'static-files'."
  }

  validation {
    condition     = var.cloud_provider == null || contains(["aws"], var.cloud_provider)
    error_message = "cloud_provider must be one of: aws."
  }

  validation {
    condition     = var.type == "static-files" || var.cloud_provider == null
    error_message = "cloud_provider only applies when type is 'static-files'."
  }
}

variable "aws_region" {
  description = "AWS region where resources will be deployed."
  type        = string
  default     = null

  validation {
    condition     = var.cloud_provider != "aws" || var.aws_region != null
    error_message = "aws_region is required when cloud_provider is 'aws'."
  }

  validation {
    condition     = var.cloud_provider == "aws" || var.aws_region == null
    error_message = "aws_region only applies when cloud_provider is 'aws'."
  }
}

variable "aws_state_bucket" {
  description = "S3 bucket name for storing OpenTofu state (also used for S3-native state locking)."
  type        = string
  default     = null

  validation {
    condition     = var.cloud_provider != "aws" || var.aws_state_bucket != null
    error_message = "aws_state_bucket is required when cloud_provider is 'aws'."
  }

  validation {
    condition     = var.cloud_provider == "aws" || var.aws_state_bucket == null
    error_message = "aws_state_bucket only applies when cloud_provider is 'aws'."
  }
}

variable "aws_distribution" {
  description = "CDN distribution for serving static files."
  type        = string
  default     = "cloudfront"

  validation {
    condition     = contains(["cloudfront"], var.aws_distribution)
    error_message = "aws_distribution must be: cloudfront."
  }

  validation {
    condition     = var.cloud_provider == "aws" || var.aws_distribution == "cloudfront"
    error_message = "aws_distribution only applies when cloud_provider is 'aws'."
  }
}

variable "aws_network" {
  description = "DNS provider for managing records."
  type        = string
  default     = "route53"

  validation {
    condition     = contains(["route53"], var.aws_network)
    error_message = "aws_network must be: route53."
  }

  validation {
    condition     = var.cloud_provider == "aws" || var.aws_network == "route53"
    error_message = "aws_network only applies when cloud_provider is 'aws'."
  }
}

variable "aws_hosted_public_zone_id" {
  description = "Public hosted zone ID for DNS records (e.g., Z1234567890ABC)."
  type        = string
  default     = null

  validation {
    condition     = var.cloud_provider != "aws" || var.aws_hosted_public_zone_id != null
    error_message = "aws_hosted_public_zone_id is required when cloud_provider is 'aws'."
  }

  validation {
    condition     = var.cloud_provider == "aws" || var.aws_hosted_public_zone_id == null
    error_message = "aws_hosted_public_zone_id only applies when cloud_provider is 'aws'."
  }
}

variable "aws_security" {
  description = "Optional WAF attachment for the CloudFront distribution. Choose 'none' to skip, or 'waf' to attach an existing AWS WAF WebACL."
  type        = string
  default     = "none"

  validation {
    condition     = contains(["none", "waf"], var.aws_security)
    error_message = "aws_security must be one of: none, waf."
  }

  validation {
    condition     = var.cloud_provider == "aws" || var.aws_security == "none"
    error_message = "aws_security only applies when cloud_provider is 'aws'."
  }
}

variable "aws_web_acl_name" {
  description = "Name of an existing AWS WAF WebACL with scope=CLOUDFRONT. Only used when aws_security = \"waf\"."
  type        = string
  default     = ""

  validation {
    condition     = var.cloud_provider == "aws" || var.aws_web_acl_name == ""
    error_message = "aws_web_acl_name only applies when cloud_provider is 'aws'."
  }
}

################################################################################
# aws-lambda
################################################################################
# The scope configuration declared by the scopes-lambda repo
# (specs/scope-configuration.json.tpl), created by the scope_definition module
# when create_scope_configuration is true. Category "scope-configurations",
# which is what the scope's create-scope workflow reads:
#
#   np provider list --categories "vpc,scope-configurations,cloud-providers"
#
# Not to be confused with "aws-lambda-configuration", the platform-wide provider
# spec that shares the display name "AWS Lambda" but holds runtime settings for
# the function itself.

variable "lambda_tofu_state_bucket" {
  description = "aws-lambda only. S3 bucket where each Lambda scope writes its OpenTofu state. Scopes use distinct key prefixes, so one bucket can be shared."
  type        = string
  default     = null

  validation {
    condition     = var.type != "aws-lambda" || var.lambda_tofu_state_bucket != null
    error_message = "lambda_tofu_state_bucket is required when type is 'aws-lambda'."
  }
}

variable "lambda_placeholder_image_uri" {
  description = "aws-lambda only. ECR URI of the placeholder image, without the architecture suffix — the workflow appends -arm64 or -amd64 from the scope's architecture."
  type        = string
  default     = null

  validation {
    condition     = var.type != "aws-lambda" || var.lambda_placeholder_image_uri != null
    error_message = "lambda_placeholder_image_uri is required when type is 'aws-lambda'."
  }
}

variable "lambda_null_agent_layer_arn" {
  description = "aws-lambda only. ARN of the nullplatform agent Lambda layer. Only needed when the scope sets USE_NULL_AGENT=true."
  type        = string
  default     = null

  validation {
    condition     = var.type == "aws-lambda" || var.lambda_null_agent_layer_arn == null
    error_message = "lambda_null_agent_layer_arn only applies when type is 'aws-lambda'."
  }
}
