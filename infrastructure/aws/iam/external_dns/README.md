# Module: external_dns

## Description

Deploys IAM resources to enable ExternalDNS on EKS to manage Route53 hosted zone records, supporting both IRSA (OIDC federation) and EKS Pod Identity authentication modes

## Architecture

An aws_iam_policy resource named nullplatform_external_dns_policy is always created, granting route53:ChangeResourceRecordSets and related permissions scoped to the provided hosted zone ARNs. In 'irsa' mode, the community iam-role-for-service-accounts module creates an aws_iam_role with an OIDC trust policy for the external-dns-private and external-dns-public service accounts, attaching the policy via the module's policies map. In 'pod_identity' mode, an aws_iam_role with a pods.eks.amazonaws.com trust principal is created alongside an aws_iam_role_policy_attachment and aws_eks_pod_identity_association resources for each of the two service accounts. The module outputs the resulting IAM role ARN regardless of which identity mode is active.

## Features

- Creates aws_iam_policy granting Route53 record management permissions scoped to provided public and/or private hosted zone ARNs
- Configures IRSA identity mode using the community iam-role-for-service-accounts module with OIDC provider trust for external-dns Kubernetes service accounts
- Configures Pod Identity mode by creating an aws_iam_role trusted by pods.eks.amazonaws.com and aws_eks_pod_identity_association resources for each external-dns service account
- Supports both public and private Route53 hosted zones simultaneously via optional hosted_zone_public_id and hosted_zone_private_id inputs
- Includes a moved block for backward-compatible state migration when upgrading from pre-v4.6.0 IRSA deployments

## Basic Usage

```hcl
module "external_dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/external_dns?ref=v6.14.0"

  cluster_name = "your-cluster-name"
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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.52.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_nullplatform_external_dns_role"></a> [nullplatform\_external\_dns\_role](#module\_nullplatform\_external\_dns\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_eks_pod_identity_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_iam_policy.nullplatform_external_dns_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_iam_openid_connect_provider_arn"></a> [aws\_iam\_openid\_connect\_provider\_arn](#input\_aws\_iam\_openid\_connect\_provider\_arn) | ARN of the AWS IAM OIDC provider. Required when identity\_mode is 'irsa'; ignored when identity\_mode is 'pod\_identity'. | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster where the policy runs | `string` | n/a | yes |
| <a name="input_hosted_zone_private_id"></a> [hosted\_zone\_private\_id](#input\_hosted\_zone\_private\_id) | ID of the private Route53 hosted zone for DNS management. Set to null or an empty string to omit it from the IAM policy. At least one of hosted\_zone\_public\_id or hosted\_zone\_private\_id must be provided. | `string` | `null` | no |
| <a name="input_hosted_zone_public_id"></a> [hosted\_zone\_public\_id](#input\_hosted\_zone\_public\_id) | ID of the public Route53 hosted zone for DNS management. Set to null or an empty string to omit it from the IAM policy. At least one of hosted\_zone\_public\_id or hosted\_zone\_private\_id must be provided. | `string` | `null` | no |
| <a name="input_identity_mode"></a> [identity\_mode](#input\_identity\_mode) | IAM identity mode: 'irsa' uses OIDC federation via the community iam-role-for-service-accounts module; 'pod\_identity' creates a native IAM role trusted by pods.eks.amazonaws.com with EKS Pod Identity associations. Default 'irsa' is backward compatible with v4.5.x — no state changes required on upgrade. Note: switching between modes on an existing deployment replaces the IAM role; external-dns will lose permissions during the transition until apply completes. | `string` | `"irsa"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nullplatform_external_dns_role_arn"></a> [nullplatform\_external\_dns\_role\_arn](#output\_nullplatform\_external\_dns\_role\_arn) | ARN of the external-dns role |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "external_dns",
  "description": "Deploys IAM resources to enable ExternalDNS on EKS to manage Route53 hosted zone records, supporting both IRSA (OIDC federation) and EKS Pod Identity authentication modes",
  "architecture": "An aws_iam_policy resource named nullplatform_external_dns_policy is always created, granting route53:ChangeResourceRecordSets and related permissions scoped to the provided hosted zone ARNs. In 'irsa' mode, the community iam-role-for-service-accounts module creates an aws_iam_role with an OIDC trust policy for the external-dns-private and external-dns-public service accounts, attaching the policy via the module's policies map. In 'pod_identity' mode, an aws_iam_role with a pods.eks.amazonaws.com trust principal is created alongside an aws_iam_role_policy_attachment and aws_eks_pod_identity_association resources for each of the two service accounts. The module outputs the resulting IAM role ARN regardless of which identity mode is active.",
  "features": [
    "Creates aws_iam_policy granting Route53 record management permissions scoped to provided public and/or private hosted zone ARNs",
    "Configures IRSA identity mode using the community iam-role-for-service-accounts module with OIDC provider trust for external-dns Kubernetes service accounts",
    "Configures Pod Identity mode by creating an aws_iam_role trusted by pods.eks.amazonaws.com and aws_eks_pod_identity_association resources for each external-dns service account",
    "Supports both public and private Route53 hosted zones simultaneously via optional hosted_zone_public_id and hosted_zone_private_id inputs",
    "Includes a moved block for backward-compatible state migration when upgrading from pre-v4.6.0 IRSA deployments"
  ],
  "inputs": [
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
      "name": "aws_iam_openid_connect_provider_arn",
      "description": "ARN of the AWS IAM OIDC provider. Required when identity_mode is 'irsa'; ignored when identity_mode is 'pod_identity'.",
      "required": false
    },
    {
      "name": "identity_mode",
      "description": "IAM identity mode: 'irsa' uses OIDC federation via the community iam-role-for-service-accounts module; 'pod_identity' creates a native IAM role trusted by pods.eks.amazonaws.com with EKS Pod Identity associations. Default 'irsa' is backward compatible with v4.5.x — no state changes required on upgrade. Note: switching between modes on an existing deployment replaces the IAM role; external-dns will lose permissions during the transition until apply completes.",
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
  "hash": "328cc85a491fe9712ca57b1a538ea2b0"
}
END_AI_METADATA -->
