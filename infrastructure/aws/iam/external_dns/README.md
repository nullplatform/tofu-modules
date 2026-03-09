# Module: external_dns

## Description

Creates IAM roles and policies for external-dns to manage Route53 DNS records in both public and private hosted zones using IRSA (IAM Roles for Service Accounts)

## Features

- Creates IAM role with OIDC provider trust for Kubernetes service accounts
- Configures IAM policies for managing Route53 DNS records
- Supports both public and private hosted zones for DNS management
- Enables external-dns to automatically update DNS records for Kubernetes services
- Implements least-privilege access with scoped Route53 permissions
- Integrates with EKS IRSA for secure authentication without static credentials

## Basic Usage

```hcl
module "external_dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/external_dns?ref=v1.43.0"

  aws_iam_openid_connect_provider_arn = "your-aws-iam-openid-connect-provider-arn"
  cluster_name                        = "your-cluster-name"
  hosted_zone_private_id              = "your-hosted-zone-private-id"
  hosted_zone_public_id               = "your-hosted-zone-public-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.external_dns.nullplatform_external_dns_role_arn
}
```

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_nullplatform_external_dns_role"></a> [nullplatform\_external\_dns\_role](#module\_nullplatform\_external\_dns\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.nullplatform_external_dns_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_iam_openid_connect_provider_arn"></a> [aws\_iam\_openid\_connect\_provider\_arn](#input\_aws\_iam\_openid\_connect\_provider\_arn) | ARN of the AWS IAM OIDC provider for EKS service account authentication | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster where the policy runs | `string` | n/a | yes |
| <a name="input_hosted_zone_private_id"></a> [hosted\_zone\_private\_id](#input\_hosted\_zone\_private\_id) | ID of the private Route53 hosted zone for DNS management | `string` | n/a | yes |
| <a name="input_hosted_zone_public_id"></a> [hosted\_zone\_public\_id](#input\_hosted\_zone\_public\_id) | ID of the public Route53 hosted zone for DNS management | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nullplatform_external_dns_role_arn"></a> [nullplatform\_external\_dns\_role\_arn](#output\_nullplatform\_external\_dns\_role\_arn) | ARN of the external-dns role |
<!-- END_TF_DOCS -->
