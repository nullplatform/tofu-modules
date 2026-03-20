# Module: cert_manager

## Description

Manages Route 53 DNS records and creates an IAM role with OIDC provider trust for Kubernetes service account

## Architecture

This module creates an IAM role for a Kubernetes service account using the terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts module, and grants permissions to manage Route 53 DNS records for DNS01 challenge using an aws_iam_policy resource. The IAM role is configured with an OIDC provider trust for the specified AWS IAM OIDC provider ARN. The module also outputs the ARN of the created IAM role. The inputs for the module include the IDs of the public and private Route53 hosted zones, the ARN of the AWS IAM OIDC provider, and the name of the cluster where the policy runs. These inputs are used to configure the IAM role and the permissions for managing Route 53 DNS records.

## Features

- Creates IAM role with OIDC provider trust for Kubernetes service account
- Configures permissions to manage Route 53 DNS records for DNS01 challenge
- Supports DNS validation in public and private Route53 hosted zones

## Basic Usage

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/cert_manager?ref=v1.46.0"

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
  example_attribute = module.cert_manager.nullplatform_cert_manager_role_arn
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
| <a name="module_nullplatform_cert_manager_role"></a> [nullplatform\_cert\_manager\_role](#module\_nullplatform\_cert\_manager\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.nullplatform_cert_manager_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_iam_openid_connect_provider_arn"></a> [aws\_iam\_openid\_connect\_provider\_arn](#input\_aws\_iam\_openid\_connect\_provider\_arn) | ARN of the AWS IAM OIDC provider for EKS service account authentication | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster where the policy runs | `string` | n/a | yes |
| <a name="input_hosted_zone_private_id"></a> [hosted\_zone\_private\_id](#input\_hosted\_zone\_private\_id) | ID of the private Route53 hosted zone for DNS validation | `string` | n/a | yes |
| <a name="input_hosted_zone_public_id"></a> [hosted\_zone\_public\_id](#input\_hosted\_zone\_public\_id) | ID of the public Route53 hosted zone for DNS validation | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nullplatform_cert_manager_role_arn"></a> [nullplatform\_cert\_manager\_role\_arn](#output\_nullplatform\_cert\_manager\_role\_arn) | ARN of the cert-manager role |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "cert_manager",
  "description": "Manages Route 53 DNS records and creates an IAM role with OIDC provider trust for Kubernetes service account",
  "architecture": "This module creates an IAM role for a Kubernetes service account using the terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts module, and grants permissions to manage Route 53 DNS records for DNS01 challenge using an aws_iam_policy resource. The IAM role is configured with an OIDC provider trust for the specified AWS IAM OIDC provider ARN. The module also outputs the ARN of the created IAM role. The inputs for the module include the IDs of the public and private Route53 hosted zones, the ARN of the AWS IAM OIDC provider, and the name of the cluster where the policy runs. These inputs are used to configure the IAM role and the permissions for managing Route 53 DNS records.",
  "features": [
    "Creates IAM role with OIDC provider trust for Kubernetes service account",
    "Configures permissions to manage Route 53 DNS records for DNS01 challenge",
    "Supports DNS validation in public and private Route53 hosted zones"
  ],
  "inputs": [
    {
      "name": "hosted_zone_public_id",
      "description": "ID of the public Route53 hosted zone for DNS validation",
      "required": true
    },
    {
      "name": "hosted_zone_private_id",
      "description": "ID of the private Route53 hosted zone for DNS validation",
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
    "nullplatform_cert_manager_role_arn"
  ],
  "hash": "813cb98b4be418f6b56f8885d6ecc26b"
}
END_AI_METADATA -->
