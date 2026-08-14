# Module: cert_manager

## Description

Provisions IAM roles and policies for cert-manager on EKS, supporting both IRSA (OIDC federation) and Pod Identity authentication modes with Route53 DNS01 challenge permissions

## Architecture

An aws_iam_policy resource is always created granting route53:GetChange, route53:ChangeResourceRecordSets, route53:ListResourceRecordSets, and route53:ListHostedZonesByName permissions scoped to the provided hosted zone ARNs. In IRSA mode, the community terraform-aws-modules/iam module creates an aws_iam_role with an OIDC trust policy and attaches the policy via the module's internal aws_iam_role_policy_attachment. In Pod Identity mode, a standalone aws_iam_role is created with a trust policy for pods.eks.amazonaws.com, an aws_iam_role_policy_attachment links the cert-manager policy, and an aws_eks_pod_identity_association binds the role to the cert-manager Kubernetes service account in the cert-manager namespace. The resulting role ARN is surfaced via an output that conditionally selects between the IRSA module output and the Pod Identity resource.

## Features

- Creates aws_iam_policy granting Route53 DNS01 challenge permissions scoped to specified public and/or private hosted zones
- Configures IRSA mode using the community iam-role-for-service-accounts module with OIDC provider trust for the cert-manager service account
- Creates native aws_iam_role trusted by pods.eks.amazonaws.com and aws_eks_pod_identity_association for EKS Pod Identity mode
- Supports both public and private Route53 hosted zones simultaneously via hosted_zone_public_id and hosted_zone_private_id inputs
- Includes a moved block for backward-compatible state migration when upgrading from pre-v4.6.0 deployments using IRSA mode

## Basic Usage

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/cert_manager?ref=v6.16.0"

  cluster_name = "your-cluster-name"
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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.52.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_nullplatform_cert_manager_role"></a> [nullplatform\_cert\_manager\_role](#module\_nullplatform\_cert\_manager\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_eks_pod_identity_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_iam_policy.nullplatform_cert_manager_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_iam_openid_connect_provider_arn"></a> [aws\_iam\_openid\_connect\_provider\_arn](#input\_aws\_iam\_openid\_connect\_provider\_arn) | ARN of the AWS IAM OIDC provider. Required when identity\_mode is 'irsa'; ignored when identity\_mode is 'pod\_identity'. | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster where the policy runs | `string` | n/a | yes |
| <a name="input_hosted_zone_private_id"></a> [hosted\_zone\_private\_id](#input\_hosted\_zone\_private\_id) | ID of the private Route53 hosted zone for DNS validation. Set to null or an empty string to omit it from the IAM policy. At least one of hosted\_zone\_public\_id or hosted\_zone\_private\_id must be provided. | `string` | `null` | no |
| <a name="input_hosted_zone_public_id"></a> [hosted\_zone\_public\_id](#input\_hosted\_zone\_public\_id) | ID of the public Route53 hosted zone for DNS validation. Set to null or an empty string to omit it from the IAM policy. At least one of hosted\_zone\_public\_id or hosted\_zone\_private\_id must be provided. | `string` | `null` | no |
| <a name="input_identity_mode"></a> [identity\_mode](#input\_identity\_mode) | IAM identity mode: 'irsa' uses OIDC federation via the community iam-role-for-service-accounts module; 'pod\_identity' creates a native IAM role trusted by pods.eks.amazonaws.com with an EKS Pod Identity association. Default 'irsa' is backward compatible with v4.5.x — no state changes required on upgrade. Note: switching between modes on an existing deployment replaces the IAM role; cert-manager will lose permissions during the transition until apply completes. | `string` | `"irsa"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nullplatform_cert_manager_role_arn"></a> [nullplatform\_cert\_manager\_role\_arn](#output\_nullplatform\_cert\_manager\_role\_arn) | ARN of the cert-manager role |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "cert_manager",
  "description": "Provisions IAM roles and policies for cert-manager on EKS, supporting both IRSA (OIDC federation) and Pod Identity authentication modes with Route53 DNS01 challenge permissions",
  "architecture": "An aws_iam_policy resource is always created granting route53:GetChange, route53:ChangeResourceRecordSets, route53:ListResourceRecordSets, and route53:ListHostedZonesByName permissions scoped to the provided hosted zone ARNs. In IRSA mode, the community terraform-aws-modules/iam module creates an aws_iam_role with an OIDC trust policy and attaches the policy via the module's internal aws_iam_role_policy_attachment. In Pod Identity mode, a standalone aws_iam_role is created with a trust policy for pods.eks.amazonaws.com, an aws_iam_role_policy_attachment links the cert-manager policy, and an aws_eks_pod_identity_association binds the role to the cert-manager Kubernetes service account in the cert-manager namespace. The resulting role ARN is surfaced via an output that conditionally selects between the IRSA module output and the Pod Identity resource.",
  "features": [
    "Creates aws_iam_policy granting Route53 DNS01 challenge permissions scoped to specified public and/or private hosted zones",
    "Configures IRSA mode using the community iam-role-for-service-accounts module with OIDC provider trust for the cert-manager service account",
    "Creates native aws_iam_role trusted by pods.eks.amazonaws.com and aws_eks_pod_identity_association for EKS Pod Identity mode",
    "Supports both public and private Route53 hosted zones simultaneously via hosted_zone_public_id and hosted_zone_private_id inputs",
    "Includes a moved block for backward-compatible state migration when upgrading from pre-v4.6.0 deployments using IRSA mode"
  ],
  "inputs": [
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
      "name": "aws_iam_openid_connect_provider_arn",
      "description": "ARN of the AWS IAM OIDC provider. Required when identity_mode is 'irsa'; ignored when identity_mode is 'pod_identity'.",
      "required": false
    },
    {
      "name": "identity_mode",
      "description": "IAM identity mode: 'irsa' uses OIDC federation via the community iam-role-for-service-accounts module; 'pod_identity' creates a native IAM role trusted by pods.eks.amazonaws.com with an EKS Pod Identity association. Default 'irsa' is backward compatible with v4.5.x — no state changes required on upgrade. Note: switching between modes on an existing deployment replaces the IAM role; cert-manager will lose permissions during the transition until apply completes.",
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
  "hash": "be91542baeec9d99fd34d89276b4263a"
}
END_AI_METADATA -->
