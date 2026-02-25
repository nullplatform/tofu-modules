# Module: ingress

## Description

Creates Kubernetes ingress resources with AWS ALB configuration for nullplatform namespace with both internal and internet-facing load balancers

## Features

- Creates a dedicated Kubernetes namespace for nullplatform
- Configures internal ALB ingress with SSL/TLS certificate support
- Configures internet-facing ALB ingress with SSL/TLS certificate support
- Implements automatic SSL redirect from HTTP to HTTPS
- Provides custom 404 responses for undefined scopes
- Configures target group deregistration delay for faster deployments
- Supports IP-based target type for container networking

## Basic Usage

```hcl
module "ingress" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/ingress?ref=v1.38.0"

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
