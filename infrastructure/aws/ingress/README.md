# Module: ingress

## Description

Configures Kubernetes ingress resources with ALB annotations for internal and public load balancers

## Architecture

This module creates two Kubernetes ingress resources, `kubernetes_ingress_v1`, one for internal and one for public load balancers, with annotations for ALB configuration, including certificate ARN, load balancer name, and target group attributes. The ingress resources are configured with a single rule for the host `setup.nullapps.io` and a fixed-response backend for 404 errors. The module uses the `alb` ingress class and sets up the load balancers with deletion protection disabled and a deregistration delay of 10 seconds.

## Features

- Creates Kubernetes ingress resources with ALB annotations
- Configures internal and public load balancers with certificate ARN and target group attributes
- Sets up fixed-response backend for 404 errors

## Basic Usage

```hcl
module "ingress" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/ingress?ref=v1.52.2"

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

<!-- BEGIN_AI_METADATA
{
  "name": "ingress",
  "description": "Configures Kubernetes ingress resources with ALB annotations for internal and public load balancers",
  "architecture": "This module creates two Kubernetes ingress resources, `kubernetes_ingress_v1`, one for internal and one for public load balancers, with annotations for ALB configuration, including certificate ARN, load balancer name, and target group attributes. The ingress resources are configured with a single rule for the host `setup.nullapps.io` and a fixed-response backend for 404 errors. The module uses the `alb` ingress class and sets up the load balancers with deletion protection disabled and a deregistration delay of 10 seconds.",
  "features": [
    "Creates Kubernetes ingress resources with ALB annotations",
    "Configures internal and public load balancers with certificate ARN and target group attributes",
    "Sets up fixed-response backend for 404 errors"
  ],
  "inputs": [
    {
      "name": "certificate_arn",
      "description": "ARN of the SSL/TLS certificate for the network configuration",
      "required": true
    }
  ],
  "outputs": [],
  "hash": "8a335c44fe70c7c4c31a4aca90e97e2f"
}
END_AI_METADATA -->
