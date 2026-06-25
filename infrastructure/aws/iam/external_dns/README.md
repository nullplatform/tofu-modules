# Module: external_dns

## Description

Creates an IAM role and policy for ExternalDNS on EKS, enabling Kubernetes service accounts to manage Route53 DNS records via IRSA

## Architecture

The module creates an aws_iam_policy granting Route53 permissions scoped to the provided hosted zone ARNs, dynamically built from optional public and private zone IDs. A community iam-role-for-service-accounts module creates an aws_iam_role with an OIDC trust policy referencing the provided aws_iam_openid_connect_provider_arn, binding it to the external-dns Kubernetes service accounts in the external-dns namespace. The custom aws_iam_policy is attached to the role, and the role ARN is exposed as an output for use by the ExternalDNS deployment.

## Features

- Creates an aws_iam_role with OIDC provider trust for Kubernetes service accounts using IRSA
- Creates an aws_iam_policy scoped to specific Route53 hosted zone ARNs for least-privilege DNS management
- Supports both public and private Route53 hosted zones with dynamic ARN construction
- Binds IAM role to both external-dns-private and external-dns-public Kubernetes service accounts
- Grants route53:ChangeResourceRecordSets and listing permissions for automated DNS record management
- Outputs the IAM role ARN for use in ExternalDNS Helm chart or Kubernetes manifests

## Basic Usage

```hcl
module "external_dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/external_dns?ref=v6.0.0"

  aws_iam_openid_connect_provider_arn = "your-aws-iam-openid-connect-provider-arn"
  cluster_name                        = "your-cluster-name"
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
| <a name="input_hosted_zone_private_id"></a> [hosted\_zone\_private\_id](#input\_hosted\_zone\_private\_id) | ID of the private Route53 hosted zone for DNS management. Set to null or an empty string to omit it from the IAM policy. At least one of hosted\_zone\_public\_id or hosted\_zone\_private\_id must be provided. | `string` | `null` | no |
| <a name="input_hosted_zone_public_id"></a> [hosted\_zone\_public\_id](#input\_hosted\_zone\_public\_id) | ID of the public Route53 hosted zone for DNS management. Set to null or an empty string to omit it from the IAM policy. At least one of hosted\_zone\_public\_id or hosted\_zone\_private\_id must be provided. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nullplatform_external_dns_role_arn"></a> [nullplatform\_external\_dns\_role\_arn](#output\_nullplatform\_external\_dns\_role\_arn) | ARN of the external-dns role |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "external_dns",
  "description": "Creates an IAM role and policy for ExternalDNS on EKS, enabling Kubernetes service accounts to manage Route53 DNS records via IRSA",
  "architecture": "The module creates an aws_iam_policy granting Route53 permissions scoped to the provided hosted zone ARNs, dynamically built from optional public and private zone IDs. A community iam-role-for-service-accounts module creates an aws_iam_role with an OIDC trust policy referencing the provided aws_iam_openid_connect_provider_arn, binding it to the external-dns Kubernetes service accounts in the external-dns namespace. The custom aws_iam_policy is attached to the role, and the role ARN is exposed as an output for use by the ExternalDNS deployment.",
  "features": [
    "Creates an aws_iam_role with OIDC provider trust for Kubernetes service accounts using IRSA",
    "Creates an aws_iam_policy scoped to specific Route53 hosted zone ARNs for least-privilege DNS management",
    "Supports both public and private Route53 hosted zones with dynamic ARN construction",
    "Binds IAM role to both external-dns-private and external-dns-public Kubernetes service accounts",
    "Grants route53:ChangeResourceRecordSets and listing permissions for automated DNS record management",
    "Outputs the IAM role ARN for use in ExternalDNS Helm chart or Kubernetes manifests"
  ],
  "inputs": [
    {
      "name": "aws_iam_openid_connect_provider_arn",
      "description": "ARN of the AWS IAM OIDC provider for EKS service account authentication",
      "required": true
    },
    {
      "name": "cluster_name",
      "description": "Name of the cluster where the policy runs",
      "required": true
    },
    {
      "name": "hosted_zone_public_id",
      "description": "ID of the public Route53 hosted zone for DNS management. Set to null or an empty string to omit it from the IAM policy. At least one of hosted_zone_public_id or hosted_zone_private_id must be provided.",
      "required": false
    },
    {
      "name": "hosted_zone_private_id",
      "description": "ID of the private Route53 hosted zone for DNS management. Set to null or an empty string to omit it from the IAM policy. At least one of hosted_zone_public_id or hosted_zone_private_id must be provided.",
      "required": false
    }
  ],
  "outputs": [
    "nullplatform_external_dns_role_arn"
  ],
  "hash": "6919410eaa2347cfed3c8c4d64d61479"
}
END_AI_METADATA -->
