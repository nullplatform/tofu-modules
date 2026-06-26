# Module: external_dns

## Description

Creates an IAM role and policy for ExternalDNS on EKS, enabling Kubernetes service accounts to manage Route53 DNS records. Supports both IRSA (OIDC federation) and EKS Pod Identity as the identity mechanism.

## Architecture

The module creates an aws_iam_policy granting Route53 permissions scoped to the provided hosted zone ARNs, dynamically built from optional public and private zone IDs. The `identity_mode` variable selects the authentication mechanism: in `irsa` mode a community iam-role-for-service-accounts module creates an aws_iam_role with OIDC trust; in `pod_identity` mode a native aws_iam_role is created with trust for `pods.eks.amazonaws.com` and two `aws_eks_pod_identity_association` resources bind it to the `external-dns-private` and `external-dns-public` service accounts. The role ARN is exposed as an output in both modes.

## Features

- Supports IRSA (OIDC) and EKS Pod Identity via `identity_mode` variable (default: `irsa`)
- Creates an IAM policy scoped to specific Route53 hosted zone ARNs for least-privilege DNS management
- Supports both public and private Route53 hosted zones with dynamic ARN construction
- Binds IAM role to both external-dns-private and external-dns-public Kubernetes service accounts
- Grants route53:ChangeResourceRecordSets and listing permissions for automated DNS record management
- Outputs the IAM role ARN in both identity modes

## Basic Usage

### IRSA (default)

```hcl
module "external_dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/external_dns?ref=v5.2.0"

  aws_iam_openid_connect_provider_arn = "your-aws-iam-openid-connect-provider-arn"
  cluster_name                        = "your-cluster-name"
}
```

### EKS Pod Identity

```hcl
module "external_dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/external_dns?ref=v5.2.0"

  cluster_name  = "your-cluster-name"
  identity_mode = "pod_identity"
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
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.52.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_nullplatform_external_dns_role"></a> [nullplatform\_external\_dns\_role](#module\_nullplatform\_external\_dns\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_eks_pod_identity_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_iam_policy.nullplatform_external_dns_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_aws_iam_openid_connect_provider_arn"></a> [aws\_iam\_openid\_connect\_provider\_arn](#input\_aws\_iam\_openid\_connect\_provider\_arn) | ARN of the AWS IAM OIDC provider. Required when identity\_mode is 'irsa'; ignored when identity\_mode is 'pod\_identity'. | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster where the policy runs | `string` | n/a | yes |
| <a name="input_hosted_zone_private_id"></a> [hosted\_zone\_private\_id](#input\_hosted\_zone\_private\_id) | ID of the private Route53 hosted zone for DNS management. Set to null or an empty string to omit it from the IAM policy. At least one of hosted\_zone\_public\_id or hosted\_zone\_private\_id must be provided. | `string` | `null` | no |
| <a name="input_hosted_zone_public_id"></a> [hosted\_zone\_public\_id](#input\_hosted\_zone\_public\_id) | ID of the public Route53 hosted zone for DNS management. Set to null or an empty string to omit it from the IAM policy. At least one of hosted\_zone\_public\_id or hosted\_zone\_private\_id must be provided. | `string` | `null` | no |
| <a name="input_identity_mode"></a> [identity\_mode](#input\_identity\_mode) | IAM identity mode: 'irsa' uses OIDC federation via the community iam-role-for-service-accounts module; 'pod\_identity' creates a native IAM role trusted by pods.eks.amazonaws.com with EKS Pod Identity associations. Default 'irsa' is backward compatible with v4.5.x — no state changes required on upgrade. Note: switching between modes on an existing deployment replaces the IAM role; external-dns will lose permissions during the transition until apply completes. | `string` | `"irsa"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_nullplatform_external_dns_role_arn"></a> [nullplatform\_external\_dns\_role\_arn](#output\_nullplatform\_external\_dns\_role\_arn) | ARN of the external-dns role |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "external_dns",
  "description": "Creates an IAM role and policy for ExternalDNS on EKS, enabling Route53 DNS management. Supports IRSA and EKS Pod Identity via identity_mode variable.",
  "architecture": "The module creates an aws_iam_policy granting Route53 permissions scoped to the provided hosted zone ARNs. The identity_mode variable selects the authentication mechanism: 'irsa' uses the community iam-role-for-service-accounts module with OIDC trust; 'pod_identity' creates a native IAM role trusted by pods.eks.amazonaws.com and two aws_eks_pod_identity_association resources binding it to external-dns-private and external-dns-public service accounts. The role ARN is exposed as an output in both modes.",
  "features": [
    "Supports IRSA (OIDC) and EKS Pod Identity via identity_mode variable (default: irsa)",
    "Creates an IAM policy scoped to specific Route53 hosted zone ARNs for least-privilege DNS management",
    "Supports both public and private Route53 hosted zones with dynamic ARN construction",
    "Binds IAM role to both external-dns-private and external-dns-public Kubernetes service accounts",
    "Grants route53:ChangeResourceRecordSets and listing permissions for automated DNS record management",
    "Outputs the IAM role ARN in both identity modes"
  ],
  "inputs": [
    {
      "name": "cluster_name",
      "description": "Name of the cluster where the policy runs",
      "required": true
    },
    {
      "name": "aws_iam_openid_connect_provider_arn",
      "description": "ARN of the AWS IAM OIDC provider. Required when identity_mode is 'irsa'; ignored when identity_mode is 'pod_identity'.",
      "required": false
    },
    {
      "name": "identity_mode",
      "description": "IAM identity mode: 'irsa' or 'pod_identity'. Default: irsa.",
      "required": false
    },
    {
      "name": "hosted_zone_public_id",
      "description": "ID of the public Route53 hosted zone for DNS management.",
      "required": false
    },
    {
      "name": "hosted_zone_private_id",
      "description": "ID of the private Route53 hosted zone for DNS management.",
      "required": false
    }
  ],
  "outputs": [
    "nullplatform_external_dns_role_arn"
  ],
  "hash": "6919410eaa2347cfed3c8c4d64d61479"
}
END_AI_METADATA -->
