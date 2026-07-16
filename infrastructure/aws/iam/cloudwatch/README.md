# Module: cloudwatch

## Description

Deploys IAM resources that let the nullplatform logs controller (base chart) ship logs and metrics to CloudWatch, supporting both IRSA (OIDC federation) and EKS Pod Identity authentication modes.

## Architecture

An aws_iam_policy resource named nullplatform_cloudwatch_policy is always created, granting CloudWatch Logs write/describe permissions scoped to the provided log group ARN patterns plus cloudwatch:PutMetricData. In 'irsa' mode, the community iam-role-for-service-accounts module creates an aws_iam_role with an OIDC trust policy for the logs controller service account, attaching the policy via the module's policies map. In 'pod_identity' mode, an aws_iam_role with a pods.eks.amazonaws.com trust principal is created alongside an aws_iam_role_policy_attachment and an aws_eks_pod_identity_association for the logs controller service account. The module outputs the resulting IAM role ARN regardless of which identity mode is active.

## Features

- Creates aws_iam_policy granting CloudWatch Logs (CreateLogGroup/CreateLogStream/PutLogEvents/PutRetentionPolicy) and cloudwatch:PutMetricData permissions
- Scopes log group/stream actions to configurable ARN patterns (defaults to any log group in the account/region; tighten via log_group_arn_patterns)
- Configures IRSA identity mode using the community iam-role-for-service-accounts module with OIDC provider trust for the logs controller service account
- Configures Pod Identity mode by creating an aws_iam_role trusted by pods.eks.amazonaws.com and an aws_eks_pod_identity_association for the logs controller service account
- Service account namespace and name are configurable to match the base chart's namespaces.nullplatformTools

## Basic Usage

```hcl
module "cloudwatch_iam" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/cloudwatch?ref=v6.5.0"

  cluster_name                        = "your-cluster-name"
  aws_iam_openid_connect_provider_arn = module.eks.eks_oidc_provider_arn
}
```

## Using Outputs

```hcl
# Feed the role ARN into the base chart's cloudwatch.serviceAccount.annotations
module "base" {
  # ...
  cloudwatch_enabled = true
  cloudwatch_service_account_annotations = {
    "eks.amazonaws.com/role-arn" = module.cloudwatch_iam.nullplatform_cloudwatch_role_arn
  }
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
| <a name="module_nullplatform_cloudwatch_role"></a> [nullplatform\_cloudwatch\_role](#module\_nullplatform\_cloudwatch\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_eks_pod_identity_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_iam_policy.nullplatform_cloudwatch_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.pod_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_iam_openid_connect_provider_arn"></a> [aws\_iam\_openid\_connect\_provider\_arn](#input\_aws\_iam\_openid\_connect\_provider\_arn) | ARN of the AWS IAM OIDC provider. Required when identity\_mode is 'irsa'; ignored when identity\_mode is 'pod\_identity'. | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster the role belongs to. Used to build the role and policy names. | `string` | n/a | yes |
| <a name="input_identity_mode"></a> [identity\_mode](#input\_identity\_mode) | IAM identity mode: 'irsa' uses OIDC federation via the community iam-role-for-service-accounts module; 'pod\_identity' creates a native IAM role trusted by pods.eks.amazonaws.com with an EKS Pod Identity association. Note: switching modes on an existing deployment replaces the IAM role; the logs controller loses permissions during the transition until apply completes. | `string` | `"irsa"` | no |
| <a name="input_log_group_arn_patterns"></a> [log\_group\_arn\_patterns](#input\_log\_group\_arn\_patterns) | Resource ARN patterns the logs controller may write log groups/streams to. Defaults to any CloudWatch log group in the account/region; tighten to a prefix (e.g. arn:aws:logs:\*:\*:log-group:/nullplatform/\*) to restrict. | `list(string)` | <pre>[<br/>  "arn:aws:logs:*:*:log-group:*",<br/>  "arn:aws:logs:*:*:log-group:*:*"<br/>]</pre> | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Name of the logs controller ServiceAccount that assumes this role. | `string` | `"nullplatform-pod-metadata-reader-sa"` | no |
| <a name="input_service_account_namespace"></a> [service\_account\_namespace](#input\_service\_account\_namespace) | Namespace of the logs controller ServiceAccount. Must match the base chart's namespaces.nullplatformTools. | `string` | `"nullplatform-tools"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nullplatform_cloudwatch_role_arn"></a> [nullplatform\_cloudwatch\_role\_arn](#output\_nullplatform\_cloudwatch\_role\_arn) | ARN of the CloudWatch logs controller role |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "cloudwatch",
  "description": "Deploys IAM resources that let the nullplatform logs controller ship logs and metrics to CloudWatch, supporting both IRSA (OIDC federation) and EKS Pod Identity authentication modes.",
  "architecture": "An aws_iam_policy resource named nullplatform_cloudwatch_policy is always created, granting CloudWatch Logs write/describe permissions scoped to the provided log group ARN patterns plus cloudwatch:PutMetricData. In 'irsa' mode, the community iam-role-for-service-accounts module creates an aws_iam_role with an OIDC trust policy for the logs controller service account. In 'pod_identity' mode, an aws_iam_role with a pods.eks.amazonaws.com trust principal is created alongside an aws_iam_role_policy_attachment and an aws_eks_pod_identity_association for the logs controller service account. The module outputs the resulting IAM role ARN regardless of which identity mode is active.",
  "features": [
    "Creates aws_iam_policy granting CloudWatch Logs and cloudwatch:PutMetricData permissions",
    "Scopes log group/stream actions to configurable ARN patterns via log_group_arn_patterns",
    "Configures IRSA identity mode using the community iam-role-for-service-accounts module with OIDC provider trust for the logs controller service account",
    "Configures Pod Identity mode by creating an aws_iam_role trusted by pods.eks.amazonaws.com and an aws_eks_pod_identity_association for the logs controller service account",
    "Service account namespace and name are configurable to match the base chart's namespaces.nullplatformTools"
  ],
  "inputs": [
    {
      "name": "cluster_name",
      "description": "Name of the cluster the role belongs to. Used to build the role and policy names.",
      "required": true
    },
    {
      "name": "identity_mode",
      "description": "IAM identity mode: 'irsa' uses OIDC federation via the community iam-role-for-service-accounts module; 'pod_identity' creates a native IAM role trusted by pods.eks.amazonaws.com with an EKS Pod Identity association.",
      "required": false
    },
    {
      "name": "aws_iam_openid_connect_provider_arn",
      "description": "ARN of the AWS IAM OIDC provider. Required when identity_mode is 'irsa'; ignored when identity_mode is 'pod_identity'.",
      "required": false
    },
    {
      "name": "service_account_namespace",
      "description": "Namespace of the logs controller ServiceAccount. Must match the base chart's namespaces.nullplatformTools.",
      "required": false
    },
    {
      "name": "service_account_name",
      "description": "Name of the logs controller ServiceAccount that assumes this role.",
      "required": false
    },
    {
      "name": "log_group_arn_patterns",
      "description": "Resource ARN patterns the logs controller may write log groups/streams to. Defaults to any CloudWatch log group in the account/region; tighten to a prefix to restrict.",
      "required": false
    }
  ],
  "outputs": [
    "nullplatform_cloudwatch_role_arn"
  ]
}
END_AI_METADATA -->
