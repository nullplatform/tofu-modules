# Module: agent

## Description

Creates an IRSA-enabled IAM role with scoped policies for the nullplatform agent Kubernetes service account on EKS

## Architecture

The module uses the terraform-aws-modules/iam//modules/iam-role-for-service-accounts submodule to create an aws_iam_role with an OIDC trust policy bound to a specific Kubernetes namespace and service account. Four aws_iam_policy resources are created for Route53, ELB, EKS, and Amazon Verified Permissions, and conditionally a fifth for sts:AssumeRole when assume_role_arns is non-empty. All policies are attached to the IAM role via the submodule's policies map, and the resulting role ARN is exposed as an output.

## Features

- Creates an IRSA IAM role scoped to a specific Kubernetes namespace and service account via OIDC provider trust
- Attaches a Route53 policy granting DNS record management permissions for hosted zones
- Attaches an ELB policy granting describe permissions for load balancers and target groups
- Attaches an EKS policy granting read access to clusters, node groups, and addons
- Attaches an Amazon Verified Permissions (AVP) policy granting full verifiedpermissions access
- Conditionally creates and attaches an sts:AssumeRole policy when assume_role_arns is provided
- Supports attaching additional custom IAM policies via the additional_policies map

## Basic Usage

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/agent?ref=v4.4.0"

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
| [aws_iam_policy.nullplatform_avp_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.nullplatform_eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.nullplatform_elb_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.nullplatform_route53_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_policies"></a> [additional\_policies](#input\_additional\_policies) | Additional policy ARNs to attach to the agent role | `map(string)` | `{}` | no |
| <a name="input_agent_namespace"></a> [agent\_namespace](#input\_agent\_namespace) | Namespace where the agent runs | `string` | n/a | yes |
| <a name="input_assume_role_arns"></a> [assume\_role\_arns](#input\_assume\_role\_arns) | List of IAM role ARNs the agent is allowed to assume via sts:AssumeRole | `list(string)` | `[]` | no |
| <a name="input_aws_iam_openid_connect_provider_arn"></a> [aws\_iam\_openid\_connect\_provider\_arn](#input\_aws\_iam\_openid\_connect\_provider\_arn) | ARN of the AWS IAM OIDC provider for EKS service account authentication | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster where the policy runs | `string` | n/a | yes |
| <a name="input_policies_name_prefix"></a> [policies\_name\_prefix](#input\_policies\_name\_prefix) | Override for IAM policy name prefix. Defaults to nullplatform\_{cluster\_name} | `string` | `""` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Override for the IAM role name. Defaults to nullplatform-{cluster\_name}-agent-role | `string` | `""` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Kubernetes service account name trusted by the IRSA role | `string` | `"nullplatform-agent"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nullplatform_agent_role_arn"></a> [nullplatform\_agent\_role\_arn](#output\_nullplatform\_agent\_role\_arn) | ARN of the agent role |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "agent",
  "description": "Creates an IRSA-enabled IAM role with scoped policies for the nullplatform agent Kubernetes service account on EKS",
  "architecture": "The module uses the terraform-aws-modules/iam//modules/iam-role-for-service-accounts submodule to create an aws_iam_role with an OIDC trust policy bound to a specific Kubernetes namespace and service account. Four aws_iam_policy resources are created for Route53, ELB, EKS, and Amazon Verified Permissions, and conditionally a fifth for sts:AssumeRole when assume_role_arns is non-empty. All policies are attached to the IAM role via the submodule's policies map, and the resulting role ARN is exposed as an output.",
  "features": [
    "Creates an IRSA IAM role scoped to a specific Kubernetes namespace and service account via OIDC provider trust",
    "Attaches a Route53 policy granting DNS record management permissions for hosted zones",
    "Attaches an ELB policy granting describe permissions for load balancers and target groups",
    "Attaches an EKS policy granting read access to clusters, node groups, and addons",
    "Attaches an Amazon Verified Permissions (AVP) policy granting full verifiedpermissions access",
    "Conditionally creates and attaches an sts:AssumeRole policy when assume_role_arns is provided",
    "Supports attaching additional custom IAM policies via the additional_policies map"
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
    "nullplatform_agent_role_arn"
  ],
  "hash": "5142461751e55436dbc95fa82a376955"
}
END_AI_METADATA -->
