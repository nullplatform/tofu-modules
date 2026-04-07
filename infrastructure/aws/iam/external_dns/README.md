# Module: external_dns

## Description

Manages Route 53 DNS records for Kubernetes service discovery

## Architecture

This module creates an IAM role with OIDC provider trust for a Kubernetes service account using the terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts module, and grants permissions to manage Route 53 DNS records for service discovery using an aws_iam_policy resource. The IAM role is connected to the OIDC provider using the aws_iam_openid_connect_provider_arn variable, and the policy is attached to the role using the policies attribute of the iam-role-for-service-accounts module. The hosted zone IDs are used to restrict the permissions of the policy to the specified public and private hosted zones. The module also outputs the ARN of the created IAM role using an output resource.

## Features

- Creates IAM role with OIDC provider trust for Kubernetes service account
- Configures IAM policy for managing Route 53 DNS records
- Supports service discovery using Route 53 hosted zones

## Basic Usage

```hcl
module "external_dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/external_dns?ref=v1.52.0"

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

<!-- BEGIN_AI_METADATA
{
  "name": "external_dns",
  "description": "Manages Route 53 DNS records for Kubernetes service discovery",
  "architecture": "This module creates an IAM role with OIDC provider trust for a Kubernetes service account using the terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts module, and grants permissions to manage Route 53 DNS records for service discovery using an aws_iam_policy resource. The IAM role is connected to the OIDC provider using the aws_iam_openid_connect_provider_arn variable, and the policy is attached to the role using the policies attribute of the iam-role-for-service-accounts module. The hosted zone IDs are used to restrict the permissions of the policy to the specified public and private hosted zones. The module also outputs the ARN of the created IAM role using an output resource.",
  "features": [
    "Creates IAM role with OIDC provider trust for Kubernetes service account",
    "Configures IAM policy for managing Route 53 DNS records",
    "Supports service discovery using Route 53 hosted zones"
  ],
  "inputs": [
    {
      "name": "hosted_zone_public_id",
      "description": "ID of the public Route53 hosted zone for DNS management",
      "required": true
    },
    {
      "name": "hosted_zone_private_id",
      "description": "ID of the private Route53 hosted zone for DNS management",
      "required": true
    },
    {
      "name": "aws_iam_openid_connect_provider_arn",
      "description": "ARN of the AWS IAM OIDC provider for EKS service account authentication",
      "required": true
    },
    {
      "name": "cluster_name",
      "description": "Name of the cluster where the policy runs",
      "required": true
    }
  ],
  "outputs": [
    "nullplatform_external_dns_role_arn"
  ],
  "hash": "daf411ed2a298b8afefaace481244f6e"
}
END_AI_METADATA -->
