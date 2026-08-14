# Module: cloudwatch

## Description

Provisions an IAM role and policy for a Kubernetes logs controller to ship logs and metrics to CloudWatch, supporting both IRSA (OIDC federation) and EKS Pod Identity authentication modes

## Architecture

The module creates an aws_iam_policy granting CloudWatch Logs and Metrics write permissions, then conditionally wires it to one of two identity paths: when identity_mode is 'irsa', it instantiates the community iam-role-for-service-accounts module which creates an aws_iam_role with an OIDC trust policy bound to the specified service account; when identity_mode is 'pod_identity', it creates an aws_iam_role trusted by pods.eks.amazonaws.com, attaches the policy via aws_iam_role_policy_attachment, and binds the role to the Kubernetes service account through an aws_eks_pod_identity_association. The resulting role ARN is exposed as an output regardless of which path is taken.

## Features

- Creates an aws_iam_policy scoped to CloudWatch log group ARN patterns with write permissions for log groups, log streams, and metric data
- Configures IRSA authentication using the community iam-role-for-service-accounts module with OIDC provider trust for a Kubernetes service account
- Provisions a native EKS Pod Identity IAM role trusted by pods.eks.amazonaws.com with an aws_eks_pod_identity_association binding
- Supports restricting CloudWatch log group access via configurable ARN pattern list
- Outputs a unified role ARN regardless of the identity mode selected

## Basic Usage

```hcl
module "cloudwatch" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/cloudwatch?ref=v6.15.0"

  cluster_name = "your-cluster-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.cloudwatch.nullplatform_cloudwatch_role_arn
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
| <a name="input_log_group_arn_patterns"></a> [log\_group\_arn\_patterns](#input\_log\_group\_arn\_patterns) | Resource ARN patterns the logs controller may write log groups/streams to. Defaults to any CloudWatch log group in the account/region; tighten to a prefix (e.g. arn:aws:logs:*:*:log-group:/nullplatform/*) to restrict. | `list(string)` | <pre>[<br/>  "arn:aws:logs:*:*:log-group:*",<br/>  "arn:aws:logs:*:*:log-group:*:*"<br/>]</pre> | no |
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
  "description": "Provisions an IAM role and policy for a Kubernetes logs controller to ship logs and metrics to CloudWatch, supporting both IRSA (OIDC federation) and EKS Pod Identity authentication modes",
  "architecture": "The module creates an aws_iam_policy granting CloudWatch Logs and Metrics write permissions, then conditionally wires it to one of two identity paths: when identity_mode is 'irsa', it instantiates the community iam-role-for-service-accounts module which creates an aws_iam_role with an OIDC trust policy bound to the specified service account; when identity_mode is 'pod_identity', it creates an aws_iam_role trusted by pods.eks.amazonaws.com, attaches the policy via aws_iam_role_policy_attachment, and binds the role to the Kubernetes service account through an aws_eks_pod_identity_association. The resulting role ARN is exposed as an output regardless of which path is taken.",
  "features": [
    "Creates an aws_iam_policy scoped to CloudWatch log group ARN patterns with write permissions for log groups, log streams, and metric data",
    "Configures IRSA authentication using the community iam-role-for-service-accounts module with OIDC provider trust for a Kubernetes service account",
    "Provisions a native EKS Pod Identity IAM role trusted by pods.eks.amazonaws.com with an aws_eks_pod_identity_association binding",
    "Supports restricting CloudWatch log group access via configurable ARN pattern list",
    "Outputs a unified role ARN regardless of the identity mode selected"
  ],
  "inputs": [
    {
      "name": "cluster_name",
      "description": "Name of the cluster the role belongs to. Used to build the role and policy names.",
      "required": true
    },
    {
      "name": "identity_mode",
      "description": "IAM identity mode: 'irsa' uses OIDC federation via the community iam-role-for-service-accounts module; 'pod_identity' creates a native IAM role trusted by pods.eks.amazonaws.com with an EKS Pod Identity association. Note: switching modes on an existing deployment replaces the IAM role; the logs controller loses permissions during the transition until apply completes.",
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
      "description": "Resource ARN patterns the logs controller may write log groups/streams to. Defaults to any CloudWatch log group in the account/region; tighten to a prefix (e.g. arn:aws:logs:*:*:log-group:/nullplatform/*) to restrict.",
      "required": false
    }
  ],
  "outputs": [
    "nullplatform_cloudwatch_role_arn"
  ],
  "hash": "413698e33352f93c8e72f05bf40eeb59"
}
END_AI_METADATA -->
