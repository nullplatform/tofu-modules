# Module: agent

## Description

Creates and configures IAM roles and policies for a Kubernetes cluster

## Architecture

This module creates an IAM role for a Kubernetes service account using the terraform-aws-modules/iam/aws module, and attaches policies for managing Route 53 DNS records, Elastic Load Balancing resources, EKS cluster resources, and AVP resources. The policies are created using the aws_iam_policy resource and are attached to the IAM role using the policies attribute of the iam-role-for-service-accounts module. The module also outputs the ARN of the created IAM role.

## Features

- Creates IAM role with OIDC provider trust for Kubernetes service account
- Configures policies for managing Route 53 DNS records and Elastic Load Balancing resources
- Supports EKS cluster resource management and AVP resource management
- Attaches additional policies to the IAM role using the additional_policies variable

## Basic Usage

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/agent?ref=v4.1.0"

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_nullplatform_agent_role"></a> [nullplatform\_agent\_role](#module\_nullplatform\_agent\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.nullplatform_avp_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.nullplatform_eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.nullplatform_elb_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.nullplatform_route53_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_policies"></a> [additional\_policies](#input\_additional\_policies) | Additional policy ARNs to attach to the agent role | `map(string)` | `{}` | no |
| <a name="input_agent_namespace"></a> [agent\_namespace](#input\_agent\_namespace) | Namespace where the agent runs | `string` | n/a | yes |
| <a name="input_aws_iam_openid_connect_provider_arn"></a> [aws\_iam\_openid\_connect\_provider\_arn](#input\_aws\_iam\_openid\_connect\_provider\_arn) | ARN of the AWS IAM OIDC provider for EKS service account authentication | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster where the policy runs | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nullplatform_agent_role_arn"></a> [nullplatform\_agent\_role\_arn](#output\_nullplatform\_agent\_role\_arn) | ARN of the agent role |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "agent",
  "description": "Creates and configures IAM roles and policies for a Kubernetes cluster",
  "architecture": "This module creates an IAM role for a Kubernetes service account using the terraform-aws-modules/iam/aws module, and attaches policies for managing Route 53 DNS records, Elastic Load Balancing resources, EKS cluster resources, and AVP resources. The policies are created using the aws_iam_policy resource and are attached to the IAM role using the policies attribute of the iam-role-for-service-accounts module. The module also outputs the ARN of the created IAM role.",
  "features": [
    "Creates IAM role with OIDC provider trust for Kubernetes service account",
    "Configures policies for managing Route 53 DNS records and Elastic Load Balancing resources",
    "Supports EKS cluster resource management and AVP resource management",
    "Attaches additional policies to the IAM role using the additional_policies variable"
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
      "name": "additional_policies",
      "description": "Additional policy ARNs to attach to the agent role",
      "required": false
    }
  ],
  "outputs": [
    "nullplatform_agent_role_arn"
  ],
  "hash": "7e0c149a7a37463a4040cfb993cbb71f"
}
END_AI_METADATA -->
