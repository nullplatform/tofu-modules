# Module: cert_manager

## Description

Creates an IAM role and policy for cert-manager on EKS, enabling DNS01 ACME challenge validation via Route53. Supports both IRSA (OIDC federation) and EKS Pod Identity as the identity mechanism.

## Architecture

An aws_iam_policy is created granting Route53 permissions (GetChange, ChangeResourceRecordSets, ListResourceRecordSets, ListHostedZonesByName) scoped to the provided public and/or private hosted zone ARNs. The `identity_mode` variable selects the authentication mechanism: in `irsa` mode the terraform-aws-modules/iam community module creates an aws_iam_role with an OIDC trust policy; in `pod_identity` mode a native aws_iam_role is created with a trust policy for `pods.eks.amazonaws.com` and an `aws_eks_pod_identity_association` binds it to the cert-manager service account. The role ARN is exposed as an output in both modes.

## Features

- Supports IRSA (OIDC) and EKS Pod Identity via `identity_mode` variable (default: `irsa`)
- Creates an IAM policy granting Route53 permissions required for DNS01 ACME challenge validation
- Supports both public and private Route53 hosted zones with dynamic ARN construction
- Enforces that at least one of public or private hosted zone IDs is provided via input validation
- Scopes Route53 ChangeResourceRecordSets and ListResourceRecordSets permissions to only the specified hosted zones
- Outputs the cert-manager IAM role ARN in both identity modes

## Basic Usage

### IRSA (default)

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/cert_manager?ref=v4.6.0"

  aws_iam_openid_connect_provider_arn = "your-aws-iam-openid-connect-provider-arn"
  cluster_name                        = "your-cluster-name"
}
```

### EKS Pod Identity

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/cert_manager?ref=v4.6.0"

  cluster_name  = "your-cluster-name"
  identity_mode = "pod_identity"
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
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.52.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_nullplatform_cert_manager_role"></a> [nullplatform\_cert\_manager\_role](#module\_nullplatform\_cert\_manager\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_eks_pod_identity_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_iam_policy.nullplatform_cert_manager_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_aws_iam_openid_connect_provider_arn"></a> [aws\_iam\_openid\_connect\_provider\_arn](#input\_aws\_iam\_openid\_connect\_provider\_arn) | ARN of the AWS IAM OIDC provider. Required when identity\_mode is 'irsa'; ignored when identity\_mode is 'pod\_identity'. | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster where the policy runs | `string` | n/a | yes |
| <a name="input_hosted_zone_private_id"></a> [hosted\_zone\_private\_id](#input\_hosted\_zone\_private\_id) | ID of the private Route53 hosted zone for DNS validation. Set to null or an empty string to omit it from the IAM policy. At least one of hosted\_zone\_public\_id or hosted\_zone\_private\_id must be provided. | `string` | `null` | no |
| <a name="input_hosted_zone_public_id"></a> [hosted\_zone\_public\_id](#input\_hosted\_zone\_public\_id) | ID of the public Route53 hosted zone for DNS validation. Set to null or an empty string to omit it from the IAM policy. At least one of hosted\_zone\_public\_id or hosted\_zone\_private\_id must be provided. | `string` | `null` | no |
| <a name="input_identity_mode"></a> [identity\_mode](#input\_identity\_mode) | IAM identity mode: 'irsa' uses OIDC federation via the community iam-role-for-service-accounts module; 'pod\_identity' creates a native IAM role trusted by pods.eks.amazonaws.com with an EKS Pod Identity association. WARNING: changing this value on an existing deployment destroys the current IAM role before creating a new one — cert-manager will lose permissions during the transition. | `string` | `"irsa"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_nullplatform_cert_manager_role_arn"></a> [nullplatform\_cert\_manager\_role\_arn](#output\_nullplatform\_cert\_manager\_role\_arn) | ARN of the cert-manager role |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "cert_manager",
  "description": "Creates an IAM role and policy for cert-manager on EKS, enabling DNS01 ACME challenge validation via Route53. Supports IRSA and EKS Pod Identity via identity_mode variable.",
  "architecture": "An aws_iam_policy is created granting Route53 permissions scoped to the provided hosted zone ARNs. The identity_mode variable selects the authentication mechanism: 'irsa' uses the terraform-aws-modules/iam community module to create a role with OIDC trust; 'pod_identity' creates a native IAM role trusted by pods.eks.amazonaws.com and an aws_eks_pod_identity_association binding it to the cert-manager service account. The role ARN is exposed as an output in both modes.",
  "features": [
    "Supports IRSA (OIDC) and EKS Pod Identity via identity_mode variable (default: irsa)",
    "Creates an IAM policy granting Route53 permissions required for DNS01 ACME challenge validation",
    "Supports both public and private Route53 hosted zones with dynamic ARN construction",
    "Enforces that at least one of public or private hosted zone IDs is provided via input validation",
    "Scopes Route53 ChangeResourceRecordSets and ListResourceRecordSets permissions to only the specified hosted zones",
    "Outputs the cert-manager IAM role ARN in both identity modes"
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
      "description": "ID of the public Route53 hosted zone for DNS validation.",
      "required": false
    },
    {
      "name": "hosted_zone_private_id",
      "description": "ID of the private Route53 hosted zone for DNS validation.",
      "required": false
    }
  ],
  "outputs": [
    "nullplatform_cert_manager_role_arn"
  ],
  "hash": "f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6"
}
END_AI_METADATA -->
