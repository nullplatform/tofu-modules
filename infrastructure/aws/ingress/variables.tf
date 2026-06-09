variable "certificate_arn" {
  description = "ARN of the ACM certificate used to terminate TLS on both ingresses. The same certificate is attached to the internal and internet-facing ALBs."
  type        = string
}

variable "internal_alb" {
  description = "Configuration for the internal-scheme ALB ingress. Set `enabled = false` to skip creation. `ingress_name` is the Kubernetes Ingress resource name; `namespace` is the namespace it lives in; `alb_name` is used both as the AWS load balancer name and the ALB group name (consumers sharing the same group name land on the same ALB). At least one of internal_alb.enabled or internet_facing_alb.enabled must be true."
  type = object({
    enabled      = optional(bool, true)
    ingress_name = optional(string, "initial-ingress-setup-internal")
    namespace    = optional(string, "nullplatform")
    alb_name     = optional(string, "k8s-nullplatform-internal")
  })
  default = {}

  validation {
    condition     = var.internal_alb.enabled || var.internet_facing_alb.enabled
    error_message = "At least one of internal_alb.enabled or internet_facing_alb.enabled must be true."
  }
}

variable "internet_facing_alb" {
  description = "Configuration for the public/internet-facing ALB ingress. Set `enabled = false` to skip creation. `ingress_name` is the Kubernetes Ingress resource name; `namespace` is the namespace it lives in; `alb_name` is used both as the AWS load balancer name and the ALB group name (consumers sharing the same group name land on the same ALB)."
  type = object({
    enabled      = optional(bool, true)
    ingress_name = optional(string, "initial-ingress-setup-public")
    namespace    = optional(string, "nullplatform")
    alb_name     = optional(string, "k8s-nullplatform-internet-facing")
  })
  default = {}
}
