# Module: agent

## Description

Creates an IRSA-enabled IAM agent role for the nullplatform Kubernetes service account on EKS, using privilege separation: the agent role only carries an sts:AssumeRole policy and assumes a separate permissions role (provisioned outside this module) that holds the scoped workload policies

## Architecture

The module uses the terraform-aws-modules/iam//modules/iam-role-for-service-accounts submodule to create an aws_iam_role (the agent role) with an OIDC trust policy bound to a specific Kubernetes namespace and service account. The agent role only carries an sts:AssumeRole policy that allows it to assume a permissions role (and any additional assume_role_arns).

The default permissions role and its workload policies (Route53, ELB, EKS, AVP) are **no longer created by this module**: they are provisioned per-cluster by the k8s scope's OpenTofu module (`k8s/scope/tofu/iam/modules` in the scopes repo). This module still authorizes assuming that role by its conventional ARN (`nullplatform-{cluster_name}-agent-permissions-role`), derived from the role name and the caller account id, and exposes that ARN as an output. The scope module must create the permissions role with that same conventional name so the wiring matches.

## Features

- Creates an IRSA IAM agent role scoped to a specific Kubernetes namespace and service account via OIDC provider trust
- Keeps the agent role minimal: it only carries an sts:AssumeRole policy targeting the (externally-created) permissions role and any additional assume_role_arns
- Authorizes assuming the conventional permissions role ARN even though the role itself is created elsewhere (k8s scope tofu module)
- Supports attaching additional custom IAM policies to the agent role via the additional_policies map
- Supports creating additional permissions roles via the permissions_roles map, each trusting the agent role and assumable by it

## Basic Usage

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/agent?ref=v5.0.0"

  agent_namespace                     = "your-agent-namespace"
  aws_iam_openid_connect_provider_arn = "your-aws-iam-openid-connect-provider-arn"
  cluster_name                        = "your-cluster-name"
}
```

## Multiple permissions roles

The agent is always allowed to assume the default permissions role by its
conventional ARN (`nullplatform-{cluster_name}-agent-permissions-role`), which is
created externally by the k8s scope tofu module. To have the agent assume
additional, module-created roles with their own policies, use the
`permissions_roles` map. Each entry creates a role that trusts the agent role and
gets the given policy ARNs attached; the agent's assume policy is extended with
all of them.

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/agent?ref=v4.5.0"

  agent_namespace                     = "your-agent-namespace"
  aws_iam_openid_connect_provider_arn = "your-aws-iam-openid-connect-provider-arn"
  cluster_name                        = "your-cluster-name"

  permissions_roles = {
    data = {
      policy_arns = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
    }
    ops = {
      name        = "custom-ops-role"
      policy_arns = ["arn:aws:iam::123456789012:policy/ops-policy"]
    }
  }
}
```

For roles that already exist elsewhere (not created by this module), use
`assume_role_arns` instead — the agent will be allowed to assume them directly.

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
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_policies"></a> [additional\_policies](#input\_additional\_policies) | Additional policy ARNs to attach to the agent role | `map(string)` | `{}` | no |
| <a name="input_agent_namespace"></a> [agent\_namespace](#input\_agent\_namespace) | Namespace where the agent runs | `string` | n/a | yes |
| <a name="input_assume_role_arns"></a> [assume\_role\_arns](#input\_assume\_role\_arns) | List of IAM role ARNs the agent is allowed to assume via sts:AssumeRole | `list(string)` | `[]` | no |
| <a name="input_aws_iam_openid_connect_provider_arn"></a> [aws\_iam\_openid\_connect\_provider\_arn](#input\_aws\_iam\_openid\_connect\_provider\_arn) | ARN of the AWS IAM OIDC provider for EKS service account authentication | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster where the policy runs | `string` | n/a | yes |
| <a name="input_permissions_role_name"></a> [permissions\_role\_name](#input\_permissions\_role\_name) | Override for the permissions IAM role name. Defaults to nullplatform-{cluster\_name}-agent-permissions-role | `string` | `""` | no |
| <a name="input_permissions_roles"></a> [permissions\_roles](#input\_permissions\_roles) | Additional permissions roles created by this module and assumable by the agent role. Map key is a logical name; name overrides the role name (defaults to nullplatform-{cluster\_name}-{key}); policy\_arns are the policy ARNs attached to the role. | <pre>map(object({<br>    name        = optional(string)<br>    policy_arns = optional(list(string), [])<br>  }))</pre> | `{}` | no |
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
  "description": "Creates an IRSA-enabled IAM agent role for the nullplatform Kubernetes service account on EKS, using privilege separation: the agent role only carries an sts:AssumeRole policy and assumes a separate permissions role that holds the scoped workload policies",
  "architecture": "The module uses the terraform-aws-modules/iam//modules/iam-role-for-service-accounts submodule to create an aws_iam_role (the agent role) with an OIDC trust policy bound to a specific Kubernetes namespace and service account. The agent role only carries an sts:AssumeRole policy that allows it to assume a separate permissions role (and any additional assume_role_arns). The permissions role is a standalone aws_iam_role whose trust policy allows only the agent role to assume it, and the four aws_iam_policy resources (Route53, ELB, EKS, and Amazon Verified Permissions) are attached to it. ARNs are derived from role names and the caller account id to avoid a circular dependency between the two roles. Both role ARNs are exposed as outputs.",
  "features": [
    "Creates an IRSA IAM agent role scoped to a specific Kubernetes namespace and service account via OIDC provider trust",
    "Keeps the agent role minimal: it only carries an sts:AssumeRole policy targeting the permissions role and any additional assume_role_arns",
    "Creates a separate permissions role that trusts only the agent role and holds the workload policies",
    "Attaches a Route53 policy granting DNS record management permissions for hosted zones to the permissions role",
    "Attaches an ELB policy granting describe permissions for load balancers and target groups to the permissions role",
    "Attaches an EKS policy granting read access to clusters, node groups, and addons to the permissions role",
    "Attaches an Amazon Verified Permissions (AVP) policy granting full verifiedpermissions access to the permissions role",
    "Supports attaching additional custom IAM policies to the agent role via the additional_policies map",
    "Supports creating additional permissions roles via the permissions_roles map, each trusting the agent role and assumable by it"
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
      "name": "permissions_role_name",
      "description": "Override for the permissions IAM role name. Defaults to nullplatform-{cluster_name}-agent-permissions-role",
      "required": false
    },
    {
      "name": "permissions_roles",
      "description": "Additional permissions roles created by this module and assumable by the agent role. Map key is a logical name; name overrides the role name (defaults to nullplatform-{cluster_name}-{key}); policy_arns are the policy ARNs attached to the role.",
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
    "nullplatform_agent_permissions_role_arn",
    "nullplatform_agent_extra_permissions_role_arns"
  ],
  "hash": "5142461751e55436dbc95fa82a376955"
}
END_AI_METADATA -->
