# Module: ingress

## Description

Creates initial Kubernetes ingress resources for nullplatform with internal and internet-facing AWS Application Load Balancers

## Features

- Creates a dedicated Kubernetes namespace for nullplatform resources
- Configures internal ALB ingress with SSL/TLS certificate support
- Configures internet-facing ALB ingress with SSL/TLS certificate support
- Implements automatic HTTP to HTTPS redirection on port 443
- Provides custom 404 error responses for non-existent scopes
- Configures target group deregistration delays for faster deployments
- Supports IP-based target type for ALB routing

## Basic Usage

```hcl
module "ingress" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/ingress?ref=v1.42.0"

  certificate_arn = module.acm.acm_certificate_arn
}
```

## Using Outputs

```hcl
# This module has no outputs. The ALB ingresses are ready
# to receive traffic once applied.
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
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ARN of the SSL/TLS certificate for the network configuration | `string` | n/a | yes |
<!-- END_TF_DOCS -->
