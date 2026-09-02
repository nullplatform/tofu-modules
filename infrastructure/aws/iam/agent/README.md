# Module: agent

## Description

Creates an IRSA (IAM Roles for Service Accounts) role for the nullplatform agent on EKS, with an sts:AssumeRole policy allowing the agent to assume additional permissions roles

## Architecture

The module uses the terraform-aws-modules/iam//modules/iam-role-for-service-accounts module to create an aws_iam_role (via the submodule) that trusts the provided OIDC provider ARN scoped to a specific Kubernetes namespace and service account. An aws_iam_policy named nullplatform_assume_role_policy is created and attached to the agent role, granting sts:AssumeRole on all target role ARNs derived from var.assume_role_arns and var.permissions_roles. Optionally, additional aws_iam_role resources are created for each entry in var.permissions_roles, each trusting only the agent role ARN (computed deterministically to avoid circular dependencies), with aws_iam_role_policy_attachment resources binding the specified managed policy ARNs to those roles.

## Features

- Creates an IRSA-enabled IAM role scoped to a specific Kubernetes namespace and service account via OIDC provider trust
- Creates an sts:AssumeRole IAM policy attaching all target role ARNs from both var.assume_role_arns and var.permissions_roles to the agent role
- Creates additional aws_iam_role resources per var.permissions_roles entry, each trusting only the agent role with configurable managed policy attachments
- Attaches additional caller-supplied policy ARNs to the agent role via var.additional_policies
- Supports overriding the agent IAM role name and policy name prefix for multi-cluster deployments
- Enforces ARN format validation on assume_role_arns and permissions_roles policy ARNs via Terraform variable validations

## Basic Usage

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/agent?ref=v6.23.0"

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
| <a name="input_permissions_roles"></a> [permissions\_roles](#input\_permissions\_roles) | Additional permissions roles created by this module and assumable by the agent role. Map key is a logical name; name overrides the role name (defaults to nullplatform-{cluster\_name}-{key}); policy\_arns are the policy ARNs attached to the role. | <pre>map(object({<br/>    name        = optional(string)<br/>    policy_arns = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_policies_name_prefix"></a> [policies\_name\_prefix](#input\_policies\_name\_prefix) | Override for IAM policy name prefix. Defaults to nullplatform\_{cluster\_name} | `string` | `""` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Override for the IAM role name. Defaults to nullplatform-{cluster\_name}-agent-role | `string` | `""` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Kubernetes service account name trusted by the IRSA role | `string` | `"nullplatform-agent"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nullplatform_agent_extra_permissions_role_arns"></a> [nullplatform\_agent\_extra\_permissions\_role\_arns](#output\_nullplatform\_agent\_extra\_permissions\_role\_arns) | Map of logical name to ARN for each additional permissions role created via permissions\_roles |
| <a name="output_nullplatform_agent_role_arn"></a> [nullplatform\_agent\_role\_arn](#output\_nullplatform\_agent\_role\_arn) | ARN of the agent role |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "agent",
  "description": "Creates an IRSA (IAM Roles for Service Accounts) role for the nullplatform agent on EKS, with an sts:AssumeRole policy allowing the agent to assume additional permissions roles",
  "architecture": "The module uses the terraform-aws-modules/iam//modules/iam-role-for-service-accounts module to create an aws_iam_role (via the submodule) that trusts the provided OIDC provider ARN scoped to a specific Kubernetes namespace and service account. An aws_iam_policy named nullplatform_assume_role_policy is created and attached to the agent role, granting sts:AssumeRole on all target role ARNs derived from var.assume_role_arns and var.permissions_roles. Optionally, additional aws_iam_role resources are created for each entry in var.permissions_roles, each trusting only the agent role ARN (computed deterministically to avoid circular dependencies), with aws_iam_role_policy_attachment resources binding the specified managed policy ARNs to those roles.",
  "features": [
    "Creates an IRSA-enabled IAM role scoped to a specific Kubernetes namespace and service account via OIDC provider trust",
    "Creates an sts:AssumeRole IAM policy attaching all target role ARNs from both var.assume_role_arns and var.permissions_roles to the agent role",
    "Creates additional aws_iam_role resources per var.permissions_roles entry, each trusting only the agent role with configurable managed policy attachments",
    "Attaches additional caller-supplied policy ARNs to the agent role via var.additional_policies",
    "Supports overriding the agent IAM role name and policy name prefix for multi-cluster deployments",
    "Enforces ARN format validation on assume_role_arns and permissions_roles policy ARNs via Terraform variable validations"
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
      "name": "policies_name_prefix",
      "description": "Override for IAM policy name prefix. Defaults to nullplatform_{cluster_name}",
      "required": false
    }
  ],
  "outputs": [
    "nullplatform_agent_role_arn",
    "nullplatform_agent_extra_permissions_role_arns"
  ],
  "hash": "88704c22b8d9b0c8ffcd9d22b364c672"
}
END_AI_METADATA -->
