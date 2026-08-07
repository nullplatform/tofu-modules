variable "nrn" {
  description = "Nullplatform Resource Name (NRN) — unique identifier for the target resource."
  type        = string
}

variable "type" {
  description = "Provider specification slug this scope configuration targets. Determines which set of variables below applies — see README for each type's payload."
  type        = string

  validation {
    condition     = contains(["static-files", "aws-lambda-configuration"], var.type)
    error_message = "type must be one of: static-files, aws-lambda-configuration."
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
# aws-lambda-configuration
################################################################################
# Schema verified via `np provider specification list --name "AWS Lambda"`
# (slug: aws-lambda-configuration).

variable "lambda_role_arn" {
  description = "aws-lambda-configuration only. ARN of the IAM role to use for the function."
  type        = string
  default     = ""

  validation {
    condition     = var.type == "aws-lambda-configuration" || var.lambda_role_arn == ""
    error_message = "lambda_role_arn only applies when type is 'aws-lambda-configuration'."
  }
}

variable "lambda_enable_endpoint" {
  description = "aws-lambda-configuration only. Whether to create an endpoint domain. If true, lambda_certificate_arn is required."
  type        = bool
  default     = true

  validation {
    condition     = var.type == "aws-lambda-configuration" || var.lambda_enable_endpoint == true
    error_message = "lambda_enable_endpoint only applies when type is 'aws-lambda-configuration'."
  }
}

variable "lambda_certificate_arn" {
  description = "aws-lambda-configuration only. ARN of the certificate to use for the function. Required when lambda_enable_endpoint is true (the default)."
  type        = string
  default     = null

  validation {
    condition     = var.type != "aws-lambda-configuration" || var.lambda_enable_endpoint != true || var.lambda_certificate_arn != null
    error_message = "lambda_certificate_arn is required when type is 'aws-lambda-configuration' and lambda_enable_endpoint is true."
  }

  validation {
    condition     = var.type == "aws-lambda-configuration" || var.lambda_certificate_arn == null
    error_message = "lambda_certificate_arn only applies when type is 'aws-lambda-configuration'."
  }
}

variable "lambda_available_layers" {
  description = "aws-lambda-configuration only. Lambda layer ARNs made available for developers to select when creating scopes."
  type        = list(string)
  default     = []

  validation {
    condition     = var.type == "aws-lambda-configuration" || length(var.lambda_available_layers) == 0
    error_message = "lambda_available_layers only applies when type is 'aws-lambda-configuration'."
  }
}

variable "lambda_reserved_concurrency_type" {
  description = "aws-lambda-configuration only. 'unreserved' (default AWS behavior) or 'reserved' (set a specific limit via lambda_reserved_concurrency_value)."
  type        = string
  default     = "unreserved"

  validation {
    condition     = contains(["unreserved", "reserved"], var.lambda_reserved_concurrency_type)
    error_message = "lambda_reserved_concurrency_type must be one of: unreserved, reserved."
  }

  validation {
    condition     = var.type == "aws-lambda-configuration" || var.lambda_reserved_concurrency_type == "unreserved"
    error_message = "lambda_reserved_concurrency_type only applies when type is 'aws-lambda-configuration'."
  }
}

variable "lambda_reserved_concurrency_value" {
  description = "aws-lambda-configuration only. Number of concurrent executions to reserve (1-1000). Required when lambda_reserved_concurrency_type is 'reserved'."
  type        = number
  default     = null

  validation {
    condition     = var.lambda_reserved_concurrency_value == null || (var.lambda_reserved_concurrency_value >= 1 && var.lambda_reserved_concurrency_value <= 1000)
    error_message = "lambda_reserved_concurrency_value must be between 1 and 1000."
  }

  validation {
    condition     = var.lambda_reserved_concurrency_type != "reserved" || var.lambda_reserved_concurrency_value != null
    error_message = "lambda_reserved_concurrency_value is required when lambda_reserved_concurrency_type is 'reserved'."
  }
}

variable "lambda_provisioned_concurrency_type" {
  description = "aws-lambda-configuration only. 'unprovisioned' (default AWS behavior) or 'provisioned' (set a specific limit via lambda_provisioned_concurrency_value)."
  type        = string
  default     = "unprovisioned"

  validation {
    condition     = contains(["unprovisioned", "provisioned"], var.lambda_provisioned_concurrency_type)
    error_message = "lambda_provisioned_concurrency_type must be one of: unprovisioned, provisioned."
  }

  validation {
    condition     = var.type == "aws-lambda-configuration" || var.lambda_provisioned_concurrency_type == "unprovisioned"
    error_message = "lambda_provisioned_concurrency_type only applies when type is 'aws-lambda-configuration'."
  }
}

variable "lambda_provisioned_concurrency_value" {
  description = "aws-lambda-configuration only. Provisioned concurrency for this function. Required when lambda_provisioned_concurrency_type is 'provisioned'."
  type        = number
  default     = null

  validation {
    condition     = var.lambda_provisioned_concurrency_type != "provisioned" || var.lambda_provisioned_concurrency_value != null
    error_message = "lambda_provisioned_concurrency_value is required when lambda_provisioned_concurrency_type is 'provisioned'."
  }
}


