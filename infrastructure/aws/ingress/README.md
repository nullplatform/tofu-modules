# Module: ingress

## Description

Creates Kubernetes ingress resources for internal and internet-facing ALBs with SSL/TLS certificates in the nullplatform namespace

## Features

- Creates a dedicated nullplatform Kubernetes namespace
- Configures an internal ALB ingress with custom 404 response handling
- Configures an internet-facing ALB ingress with custom 404 response handling
- Enables SSL/TLS termination with automatic HTTP to HTTPS redirect
- Sets up target group attributes for fast deregistration delays
- Implements IP-based target type routing for both ALBs

## Basic Usage

```hcl
module "ingress" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/ingress?ref=v1.38.2"

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
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ARN of the SSL/TLS certificate for the network configuration | `string` | n/a | yes |
<!-- END_TF_DOCS -->
