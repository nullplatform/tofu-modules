# Module: Ingress

This module creates Kubernetes ingress resources for both internal and internet-facing Application Load Balancers. It sets up initial ingress configurations with SSL termination and custom 404 responses for the nullplatform environment.

Usage:

```hcl
module "agent-iam" {
  source          = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/aws/iam?ref=v1.0.0"
  aws_iam_openid_connect_provider_arn = var.aws_iam_openid_connect_provider_arn
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