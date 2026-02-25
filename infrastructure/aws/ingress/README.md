# Module: ingress

## Description

Creates Kubernetes ingress resources for internal and internet-facing Application Load Balancers with SSL certificates in the nullplatform namespace

## Features

- Creates a dedicated Kubernetes namespace for nullplatform resources
- Configures internal ALB ingress with IP-based target routing and SSL/TLS termination
- Configures internet-facing ALB ingress with IP-based target routing and SSL/TLS termination
- Implements automatic HTTP to HTTPS redirect on port 443
- Sets up custom 404 response for undefined scopes or undeployed applications
- Configures fast deregistration delay of 10 seconds for target groups
- Supports SSL certificate attachment via AWS Certificate Manager ARN

## Basic Usage

```hcl
module "ingress" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/ingress?ref=v1.36.0"

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
