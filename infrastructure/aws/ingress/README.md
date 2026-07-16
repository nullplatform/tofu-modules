# Module: ingress

## Description

Provisions Kubernetes ALB ingress resources for internal and internet-facing AWS Application Load Balancers with TLS termination using an ACM certificate

## Architecture

The module creates up to two kubernetes_ingress_v1 resources — one for an internal-scheme ALB and one for an internet-facing ALB — each gated by its respective enabled flag. Both ingress resources are annotated with AWS ALB Ingress Controller annotations that wire the certificate_arn for TLS termination, configure HTTP-to-HTTPS redirect on port 443, set IP-mode target routing, and assign the ALB group name and load balancer name from their respective configuration objects. A default 404 fixed-response action is embedded in the annotations to handle unmatched requests, and deletion protection is explicitly disabled on both load balancers.

## Features

- Creates an internal-scheme kubernetes_ingress_v1 with AWS ALB Ingress Controller annotations for private network access
- Creates an internet-facing kubernetes_ingress_v1 with AWS ALB Ingress Controller annotations for public access
- Configures HTTP-to-HTTPS redirect on port 443 for both ALB ingresses
- Attaches an ACM certificate ARN to both ALBs for TLS termination
- Configures a fixed 404 response action for unmatched ingress rules on both ALBs
- Supports ALB group sharing by using alb_name as both the load balancer name and group name
- Allows independent enable/disable control of internal and internet-facing ingresses via enabled flags

## Basic Usage

```hcl
module "ingress" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/ingress?ref=v6.6.0"

  certificate_arn = "your-certificate-arn"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.ingress.id
}
```

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_ingress_v1.internal](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_ingress_v1.public](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_namespace_v1.namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ARN of the ACM certificate used to terminate TLS on both ingresses. The same certificate is attached to the internal and internet-facing ALBs. | `string` | n/a | yes |
| <a name="input_internal_alb"></a> [internal\_alb](#input\_internal\_alb) | Configuration for the internal-scheme ALB ingress. Set `enabled = false` to skip creation. `ingress_name` is the Kubernetes Ingress resource name; `namespace` is the namespace it lives in; `alb_name` is used both as the AWS load balancer name and the ALB group name (consumers sharing the same group name land on the same ALB). At least one of internal\_alb.enabled or internet\_facing\_alb.enabled must be true. | <pre>object({<br/>    enabled      = optional(bool, true)<br/>    ingress_name = optional(string, "initial-ingress-setup-internal")<br/>    namespace    = optional(string, "nullplatform")<br/>    alb_name     = optional(string, "k8s-nullplatform-internal")<br/>  })</pre> | `{}` | no |
| <a name="input_internet_facing_alb"></a> [internet\_facing\_alb](#input\_internet\_facing\_alb) | Configuration for the public/internet-facing ALB ingress. Set `enabled = false` to skip creation. `ingress_name` is the Kubernetes Ingress resource name; `namespace` is the namespace it lives in; `alb_name` is used both as the AWS load balancer name and the ALB group name (consumers sharing the same group name land on the same ALB). | <pre>object({<br/>    enabled      = optional(bool, true)<br/>    ingress_name = optional(string, "initial-ingress-setup-public")<br/>    namespace    = optional(string, "nullplatform")<br/>    alb_name     = optional(string, "k8s-nullplatform-internet-facing")<br/>  })</pre> | `{}` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "ingress",
  "description": "Provisions Kubernetes ALB ingress resources for internal and internet-facing AWS Application Load Balancers with TLS termination using an ACM certificate",
  "architecture": "The module creates up to two kubernetes_ingress_v1 resources — one for an internal-scheme ALB and one for an internet-facing ALB — each gated by its respective enabled flag. Both ingress resources are annotated with AWS ALB Ingress Controller annotations that wire the certificate_arn for TLS termination, configure HTTP-to-HTTPS redirect on port 443, set IP-mode target routing, and assign the ALB group name and load balancer name from their respective configuration objects. A default 404 fixed-response action is embedded in the annotations to handle unmatched requests, and deletion protection is explicitly disabled on both load balancers.",
  "features": [
    "Creates an internal-scheme kubernetes_ingress_v1 with AWS ALB Ingress Controller annotations for private network access",
    "Creates an internet-facing kubernetes_ingress_v1 with AWS ALB Ingress Controller annotations for public access",
    "Configures HTTP-to-HTTPS redirect on port 443 for both ALB ingresses",
    "Attaches an ACM certificate ARN to both ALBs for TLS termination",
    "Configures a fixed 404 response action for unmatched ingress rules on both ALBs",
    "Supports ALB group sharing by using alb_name as both the load balancer name and group name",
    "Allows independent enable/disable control of internal and internet-facing ingresses via enabled flags"
  ],
  "inputs": [
    {
      "name": "certificate_arn",
      "description": "ARN of the ACM certificate used to terminate TLS on both ingresses. The same certificate is attached to the internal and internet-facing ALBs.",
      "required": true
    },
    {
      "name": "internal_alb",
      "description": "Configuration for the internal-scheme ALB ingress. Set `enabled = false` to skip creation. `ingress_name` is the Kubernetes Ingress resource name; `namespace` is the namespace it lives in; `alb_name` is used both as the AWS load balancer name and the ALB group name (consumers sharing the same group name land on the same ALB). At least one of internal_alb.enabled or internet_facing_alb.enabled must be true.",
      "required": false
    },
    {
      "name": "internet_facing_alb",
      "description": "Configuration for the public/internet-facing ALB ingress. Set `enabled = false` to skip creation. `ingress_name` is the Kubernetes Ingress resource name; `namespace` is the namespace it lives in; `alb_name` is used both as the AWS load balancer name and the ALB group name (consumers sharing the same group name land on the same ALB).",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "902c6061771a681c065bcb3a0cfbc59d"
}
END_AI_METADATA -->
