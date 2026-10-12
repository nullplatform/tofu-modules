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

variable "aws_lambda_associations" {
  description = "Lambda@Edge functions attached to the CloudFront default cache behavior, one entry per CloudFront event. function_arn must include a published version. Empty (the default) leaves distribution.lambda_associations out of the payload, matching a spec that never declared it."
  type = list(object({
    event_type   = string
    function_arn = string
  }))
  default = []

  validation {
    condition = alltrue([
      for a in var.aws_lambda_associations :
      contains(["viewer-request", "viewer-response", "origin-request", "origin-response"], a.event_type)
    ])
    error_message = "aws_lambda_associations[*].event_type must be one of: viewer-request, viewer-response, origin-request, origin-response."
  }

  validation {
    condition     = length(distinct([for a in var.aws_lambda_associations : a.event_type])) == length(var.aws_lambda_associations)
    error_message = "aws_lambda_associations must not repeat an event_type: CloudFront accepts one function per event on the default cache behavior."
  }

  validation {
    condition     = var.cloud_provider == "aws" || length(var.aws_lambda_associations) == 0
    error_message = "aws_lambda_associations only applies when cloud_provider is 'aws'."
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

variable "aws_default_viewer_protocol_policy" {
  description = "How CloudFront answers HTTP requests on the default cache behavior."
  type        = string
  default     = "redirect-to-https"

  validation {
    condition     = contains(["redirect-to-https", "https-only", "allow-all"], var.aws_default_viewer_protocol_policy)
    error_message = "aws_default_viewer_protocol_policy must be one of: redirect-to-https, https-only, allow-all."
  }
}

variable "aws_default_compress" {
  description = "Let CloudFront gzip or brotli text responses on the default cache behavior when the viewer accepts it."
  type        = bool
  default     = true
}

variable "aws_default_invocations" {
  description = "Functions attached to the default cache behavior. A behavior runs CloudFront Functions or Lambda@Edge, never both, and Functions run on viewer events only. A Lambda ARN must include a published version. Supersedes aws_lambda_associations."
  type = list(object({
    event_type   = string
    function_arn = string
  }))
  default = []

  validation {
    condition = alltrue([
      for i in var.aws_default_invocations : contains([
        "CloudFront Function - viewer request",
        "CloudFront Function - viewer response",
        "Lambda@Edge - viewer request",
        "Lambda@Edge - viewer response",
        "Lambda@Edge - origin request",
        "Lambda@Edge - origin response",
      ], i.event_type)
    ])
    error_message = "aws_default_invocations[*].event_type must be one of the spec's six values, e.g. \"Lambda@Edge - viewer response\"."
  }

  validation {
    condition     = length(distinct([for i in var.aws_default_invocations : i.event_type])) == length(var.aws_default_invocations)
    error_message = "aws_default_invocations must not repeat an event_type: CloudFront accepts one function per event on a behavior."
  }
}

variable "aws_default_cache_mode" {
  description = "Cache key and origin requests on the default cache behavior. \"legacy\" forwards nothing and caches for an hour; \"policy\" hands both over to the cache and origin request policies."
  type        = string
  default     = "legacy"

  validation {
    condition     = contains(["legacy", "policy"], var.aws_default_cache_mode)
    error_message = "aws_default_cache_mode must be one of: legacy, policy."
  }
}

variable "aws_default_cache_policy" {
  description = "Managed cache policy for the default cache behavior. Only read when aws_default_cache_mode = \"policy\"."
  type        = string
  default     = "CachingOptimized"

  validation {
    condition     = contains(["CachingOptimized", "CachingDisabled", "CachingOptimizedForUncompressedObjects", "Amplify"], var.aws_default_cache_policy)
    error_message = "aws_default_cache_policy must be one of: CachingOptimized, CachingDisabled, CachingOptimizedForUncompressedObjects, Amplify."
  }
}

variable "aws_default_origin_request_policy" {
  description = "Managed origin request policy for the default cache behavior. Only read when aws_default_cache_mode = \"policy\"."
  type        = string
  default     = "AllViewerExceptHostHeader"

  validation {
    condition     = contains(["AllViewerExceptHostHeader", "AllViewer", "CORS-S3Origin", "CORS-CustomOrigin", "UserAgentRefererHeaders"], var.aws_default_origin_request_policy)
    error_message = "aws_default_origin_request_policy must be one of: AllViewerExceptHostHeader, AllViewer, CORS-S3Origin, CORS-CustomOrigin, UserAgentRefererHeaders."
  }
}

variable "aws_default_response_headers_policy" {
  description = "Managed response headers policy for the default cache behavior. Empty attaches none."
  type        = string
  default     = ""

  validation {
    condition     = contains(["", "SecurityHeadersPolicy", "CORS-and-SecurityHeadersPolicy", "SimpleCORS"], var.aws_default_response_headers_policy)
    error_message = "aws_default_response_headers_policy must be empty or one of: SecurityHeadersPolicy, CORS-and-SecurityHeadersPolicy, SimpleCORS."
  }
}

variable "aws_behaviors" {
  description = "Ordered cache behaviors, each matching a path pattern. List order is the precedence CloudFront evaluates, and the first match wins, so put the most specific pattern first. Every field but path_pattern mirrors its default_* counterpart."
  type = list(object({
    path_pattern            = string
    viewer_protocol_policy  = optional(string, "redirect-to-https")
    compress                = optional(bool, true)
    cache_mode              = optional(string, "legacy")
    cache_policy            = optional(string, "CachingOptimized")
    origin_request_policy   = optional(string, "AllViewerExceptHostHeader")
    response_headers_policy = optional(string, "")
    invocations = optional(list(object({
      event_type   = string
      function_arn = string
    })), [])
  }))
  default = []

  validation {
    condition     = length(distinct([for b in var.aws_behaviors : b.path_pattern])) == length(var.aws_behaviors)
    error_message = "aws_behaviors must not repeat a path_pattern: CloudFront rejects a distribution with duplicates."
  }

  validation {
    condition = alltrue([
      for b in var.aws_behaviors : contains(["legacy", "policy"], b.cache_mode)
    ])
    error_message = "aws_behaviors[*].cache_mode must be one of: legacy, policy."
  }

  validation {
    condition = alltrue(flatten([
      for b in var.aws_behaviors : [
        for i in b.invocations : contains([
          "CloudFront Function - viewer request",
          "CloudFront Function - viewer response",
          "Lambda@Edge - viewer request",
          "Lambda@Edge - viewer response",
          "Lambda@Edge - origin request",
          "Lambda@Edge - origin response",
        ], i.event_type)
      ]
    ]))
    error_message = "aws_behaviors[*].invocations[*].event_type must be one of the spec's six values."
  }
}

variable "aws_custom_error_responses" {
  description = "How CloudFront answers origin errors. A single-page app serves its entry document on 403 and 404 with response_code 200, so the client router can take over. Empty creates none."
  type = list(object({
    error_code         = number
    response_code      = optional(number)
    response_page_path = optional(string)
  }))
  default = []

  validation {
    condition     = length(distinct([for e in var.aws_custom_error_responses : e.error_code])) == length(var.aws_custom_error_responses)
    error_message = "aws_custom_error_responses must not repeat an error_code."
  }
}

variable "aws_price_class" {
  description = "Edge locations the distribution is served from."
  type        = string
  default     = "PriceClass_100"

  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.aws_price_class)
    error_message = "aws_price_class must be one of: PriceClass_100, PriceClass_200, PriceClass_All."
  }
}

variable "aws_default_root_object" {
  description = "Object returned when the request is for the site root."
  type        = string
  default     = "index.html"
}

variable "aws_geo_restriction" {
  description = "Countries allowed or denied, by ISO 3166-1 alpha-2 code. restriction_type \"none\" serves everywhere and ignores locations."
  type = object({
    restriction_type = optional(string, "none")
    locations        = optional(list(string), [])
  })
  default = {}

  validation {
    condition     = contains(["none", "whitelist", "blacklist"], var.aws_geo_restriction.restriction_type)
    error_message = "aws_geo_restriction.restriction_type must be one of: none, whitelist, blacklist."
  }

  validation {
    condition     = var.aws_geo_restriction.restriction_type == "none" || length(var.aws_geo_restriction.locations) > 0
    error_message = "aws_geo_restriction.locations is required when restriction_type is whitelist or blacklist."
  }
}
