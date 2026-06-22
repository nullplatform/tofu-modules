# Module: cert_manager

## Description

Creates an IAM role and policy for cert-manager on EKS, enabling DNS01 ACME challenge validation via Route53 hosted zones using IRSA

## Architecture

An aws_iam_policy is created granting Route53 permissions (GetChange, ChangeResourceRecordSets, ListResourceRecordSets, ListHostedZonesByName) scoped to the provided public and/or private hosted zone ARNs. The terraform-aws-modules/iam iam-role-for-service-accounts module creates an aws_iam_role with an OIDC trust policy bound to the cert-manager Kubernetes service account in the cert-manager namespace. The OIDC provider ARN and cluster name flow into the role naming and trust relationship, while the hosted zone IDs are dynamically filtered and converted to ARNs via a local for expression. The role ARN is exposed as an output for use by the cert-manager Helm release or Kubernetes service account annotation.

## Features

- Creates an IAM role with OIDC trust scoped to the cert-manager Kubernetes service account via IRSA
- Creates an IAM policy granting Route53 permissions required for DNS01 ACME challenge validation
- Supports both public and private Route53 hosted zones with dynamic ARN construction
- Enforces that at least one of public or private hosted zone IDs is provided via input validation
- Scopes Route53 ChangeResourceRecordSets and ListResourceRecordSets permissions to only the specified hosted zones
- Outputs the cert-manager IAM role ARN for use in service account annotations or Helm chart values

## Basic Usage

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/cert_manager?ref=v4.5.2"

  aws_iam_openid_connect_provider_arn = "your-aws-iam-openid-connect-provider-arn"
  cluster_name                        = "your-cluster-name"
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
| <a name="input_hosted_zone_private_id"></a> [hosted\_zone\_private\_id](#input\_hosted\_zone\_private\_id) | ID of the private Route53 hosted zone for DNS validation. Set to null or an empty string to omit it from the IAM policy. At least one of hosted\_zone\_public\_id or hosted\_zone\_private\_id must be provided. | `string` | `null` | no |
| <a name="input_hosted_zone_public_id"></a> [hosted\_zone\_public\_id](#input\_hosted\_zone\_public\_id) | ID of the public Route53 hosted zone for DNS validation. Set to null or an empty string to omit it from the IAM policy. At least one of hosted\_zone\_public\_id or hosted\_zone\_private\_id must be provided. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nullplatform_cert_manager_role_arn"></a> [nullplatform\_cert\_manager\_role\_arn](#output\_nullplatform\_cert\_manager\_role\_arn) | ARN of the cert-manager role |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "cert_manager",
  "description": "Creates an IAM role and policy for cert-manager on EKS, enabling DNS01 ACME challenge validation via Route53 hosted zones using IRSA",
  "architecture": "An aws_iam_policy is created granting Route53 permissions (GetChange, ChangeResourceRecordSets, ListResourceRecordSets, ListHostedZonesByName) scoped to the provided public and/or private hosted zone ARNs. The terraform-aws-modules/iam iam-role-for-service-accounts module creates an aws_iam_role with an OIDC trust policy bound to the cert-manager Kubernetes service account in the cert-manager namespace. The OIDC provider ARN and cluster name flow into the role naming and trust relationship, while the hosted zone IDs are dynamically filtered and converted to ARNs via a local for expression. The role ARN is exposed as an output for use by the cert-manager Helm release or Kubernetes service account annotation.",
  "features": [
    "Creates an IAM role with OIDC trust scoped to the cert-manager Kubernetes service account via IRSA",
    "Creates an IAM policy granting Route53 permissions required for DNS01 ACME challenge validation",
    "Supports both public and private Route53 hosted zones with dynamic ARN construction",
    "Enforces that at least one of public or private hosted zone IDs is provided via input validation",
    "Scopes Route53 ChangeResourceRecordSets and ListResourceRecordSets permissions to only the specified hosted zones",
    "Outputs the cert-manager IAM role ARN for use in service account annotations or Helm chart values"
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
      "description": "ID of the public Route53 hosted zone for DNS validation. Set to null or an empty string to omit it from the IAM policy. At least one of hosted_zone_public_id or hosted_zone_private_id must be provided.",
      "required": false
    },
    {
      "name": "hosted_zone_private_id",
      "description": "ID of the private Route53 hosted zone for DNS validation. Set to null or an empty string to omit it from the IAM policy. At least one of hosted_zone_public_id or hosted_zone_private_id must be provided.",
      "required": false
    }
  ],
  "outputs": [
    "nullplatform_cert_manager_role_arn"
  ],
  "hash": "e4578ab43eee3db215746d060099bc27"
}
END_AI_METADATA -->
