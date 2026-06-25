# Module: agent

## Description

Creates an IRSA (IAM Roles for Service Accounts) IAM role for the nullplatform agent Kubernetes service account, with an assume-role policy allowing it to assume a conventionally-named permissions role and any additional roles

## Architecture

The module uses the terraform-aws-modules/iam//modules/iam-role-for-service-accounts submodule to create an aws_iam_role (agent role) trusted by a specific OIDC provider and Kubernetes service account namespace pair. An aws_iam_policy (nullplatform_assume_role_policy) is created to allow sts:AssumeRole on the externally-managed permissions role ARN, any extra permissions role ARNs, and any caller-supplied assume_role_arns, then attached to the agent role. Optionally, aws_iam_role resources are created for each entry in var.permissions_roles with the agent role as their trusted principal, and aws_iam_role_policy_attachment resources bind the specified policy ARNs to each of those roles. The module outputs the agent role ARN, the conventional permissions role ARN (constructed deterministically from account ID and cluster name), and a map of extra permissions role ARNs.

## Features

- Creates an IRSA-enabled aws_iam_role scoped to a specific Kubernetes namespace and service account via OIDC provider trust
- Creates an aws_iam_policy granting sts:AssumeRole on a conventionally-named permissions role, extra permissions roles, and caller-supplied role ARNs
- Creates optional extra aws_iam_role resources per var.permissions_roles entry, each trusting only the agent role
- Attaches caller-specified policy ARNs to each extra permissions role via aws_iam_role_policy_attachment
- Supports attaching additional arbitrary IAM policies directly to the agent role via var.additional_policies
- Derives all role and policy names from cluster_name with optional overrides to avoid naming conflicts across clusters
- Validates all IAM role and policy ARN inputs with regex to enforce correct ARN format before applying

## Basic Usage

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/agent?ref=v6.0.0"

  agent_namespace                     = "your-agent-namespace"
  aws_iam_openid_connect_provider_arn = "your-aws-iam-openid-connect-provider-arn"
  cluster_name                        = "your-cluster-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.agent.nullplatform_agent_role_arn
}
```

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.47.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_nullplatform_agent_role"></a> [nullplatform\_agent\_role](#module\_nullplatform\_agent\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.nullplatform_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.extra_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.extra_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_policies"></a> [additional\_policies](#input\_additional\_policies) | Additional policy ARNs to attach to the agent role | `map(string)` | `{}` | no |
| <a name="input_agent_namespace"></a> [agent\_namespace](#input\_agent\_namespace) | Namespace where the agent runs | `string` | n/a | yes |
| <a name="input_assume_role_arns"></a> [assume\_role\_arns](#input\_assume\_role\_arns) | List of IAM role ARNs the agent is allowed to assume via sts:AssumeRole | `list(string)` | `[]` | no |
| <a name="input_aws_iam_openid_connect_provider_arn"></a> [aws\_iam\_openid\_connect\_provider\_arn](#input\_aws\_iam\_openid\_connect\_provider\_arn) | ARN of the AWS IAM OIDC provider for EKS service account authentication | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster where the policy runs | `string` | n/a | yes |
| <a name="input_permissions_role_name"></a> [permissions\_role\_name](#input\_permissions\_role\_name) | Override for the permissions IAM role name. Defaults to nullplatform-{cluster\_name}-agent-permissions-role | `string` | `""` | no |
| <a name="input_permissions_roles"></a> [permissions\_roles](#input\_permissions\_roles) | Additional permissions roles created by this module and assumable by the agent role. Map key is a logical name; name overrides the role name (defaults to nullplatform-{cluster\_name}-{key}); policy\_arns are the policy ARNs attached to the role. | <pre>map(object({<br/>    name        = optional(string)<br/>    policy_arns = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_policies_name_prefix"></a> [policies\_name\_prefix](#input\_policies\_name\_prefix) | Override for IAM policy name prefix. Defaults to nullplatform\_{cluster\_name} | `string` | `""` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Override for the IAM role name. Defaults to nullplatform-{cluster\_name}-agent-role | `string` | `""` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Kubernetes service account name trusted by the IRSA role | `string` | `"nullplatform-agent"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nullplatform_agent_extra_permissions_role_arns"></a> [nullplatform\_agent\_extra\_permissions\_role\_arns](#output\_nullplatform\_agent\_extra\_permissions\_role\_arns) | Map of logical name to ARN for each additional permissions role created via permissions\_roles |
| <a name="output_nullplatform_agent_permissions_role_arn"></a> [nullplatform\_agent\_permissions\_role\_arn](#output\_nullplatform\_agent\_permissions\_role\_arn) | Conventional ARN of the permissions role the agent role is allowed to assume. The role itself is created externally (k8s scope tofu module), not by this module. |
| <a name="output_nullplatform_agent_role_arn"></a> [nullplatform\_agent\_role\_arn](#output\_nullplatform\_agent\_role\_arn) | ARN of the agent role |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "agent",
  "description": "Creates an IRSA (IAM Roles for Service Accounts) IAM role for the nullplatform agent Kubernetes service account, with an assume-role policy allowing it to assume a conventionally-named permissions role and any additional roles",
  "architecture": "The module uses the terraform-aws-modules/iam//modules/iam-role-for-service-accounts submodule to create an aws_iam_role (agent role) trusted by a specific OIDC provider and Kubernetes service account namespace pair. An aws_iam_policy (nullplatform_assume_role_policy) is created to allow sts:AssumeRole on the externally-managed permissions role ARN, any extra permissions role ARNs, and any caller-supplied assume_role_arns, then attached to the agent role. Optionally, aws_iam_role resources are created for each entry in var.permissions_roles with the agent role as their trusted principal, and aws_iam_role_policy_attachment resources bind the specified policy ARNs to each of those roles. The module outputs the agent role ARN, the conventional permissions role ARN (constructed deterministically from account ID and cluster name), and a map of extra permissions role ARNs.",
  "features": [
    "Creates an IRSA-enabled aws_iam_role scoped to a specific Kubernetes namespace and service account via OIDC provider trust",
    "Creates an aws_iam_policy granting sts:AssumeRole on a conventionally-named permissions role, extra permissions roles, and caller-supplied role ARNs",
    "Creates optional extra aws_iam_role resources per var.permissions_roles entry, each trusting only the agent role",
    "Attaches caller-specified policy ARNs to each extra permissions role via aws_iam_role_policy_attachment",
    "Supports attaching additional arbitrary IAM policies directly to the agent role via var.additional_policies",
    "Derives all role and policy names from cluster_name with optional overrides to avoid naming conflicts across clusters",
    "Validates all IAM role and policy ARN inputs with regex to enforce correct ARN format before applying"
  ],
  "inputs": [
    {
      "name": "aws_iam_openid_connect_provider_arn",
      "description": "ARN of the AWS IAM OIDC provider for EKS service account authentication",
      "required": true
    },
    {
      "name": "agent_namespace",
      "description": "Namespace where the agent runs",
      "required": true
    },
    {
      "name": "cluster_name",
      "description": "Name of the cluster where the policy runs",
      "required": true
    },
    {
      "name": "assume_role_arns",
      "description": "List of IAM role ARNs the agent is allowed to assume via sts:AssumeRole",
      "required": false
    },
    {
      "name": "permissions_roles",
      "description": "Additional permissions roles created by this module and assumable by the agent role. Map key is a logical name; name overrides the role name (defaults to nullplatform-{cluster_name}-{key}); policy_arns are the policy ARNs attached to the role.",
      "required": false
    },
    {
      "name": "additional_policies",
      "description": "Additional policy ARNs to attach to the agent role",
      "required": false
    },
    {
      "name": "service_account_name",
      "description": "Kubernetes service account name trusted by the IRSA role",
      "required": false
    },
    {
      "name": "role_name",
      "description": "Override for the IAM role name. Defaults to nullplatform-{cluster_name}-agent-role",
      "required": false
    },
    {
      "name": "permissions_role_name",
      "description": "Override for the permissions IAM role name. Defaults to nullplatform-{cluster_name}-agent-permissions-role",
      "required": false
    },
    {
      "name": "policies_name_prefix",
      "description": "Override for IAM policy name prefix. Defaults to nullplatform_{cluster_name}",
      "required": false
    }
  ],
  "outputs": [
    "nullplatform_agent_role_arn",
    "nullplatform_agent_permissions_role_arn",
    "nullplatform_agent_extra_permissions_role_arns"
  ],
  "hash": "080cc2f1402698f5884c98e39f0ef01a"
}
END_AI_METADATA -->
