# Module: agent

## Description

Creates an IAM role for the Nullplatform agent service account in EKS with policies for managing Route53, ELB, EKS, and AVP resources

## Features

- Creates an IAM role for service accounts (IRSA) with OIDC provider trust for Kubernetes
- Configures Route53 permissions for DNS record management and service discovery
- Grants Elastic Load Balancing permissions for describing load balancers and target groups
- Provides EKS cluster permissions for describing clusters, node groups, and addons
- Enables AWS Verified Permissions (AVP) resource management
- Supports additional custom IAM policies through configurable policy attachments

## Basic Usage

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/agent?ref=v1.40.0"

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
| <a name="input_agent_namespace"></a> [agent\_namespace](#input\_agent\_namespace) | Namespace where the agent runs | `string` | n/a | yes |
| <a name="input_aws_iam_openid_connect_provider_arn"></a> [aws\_iam\_openid\_connect\_provider\_arn](#input\_aws\_iam\_openid\_connect\_provider\_arn) | ARN of the AWS IAM OIDC provider for EKS service account authentication | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster where the policy runs | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nullplatform_agent_role_arn"></a> [nullplatform\_agent\_role\_arn](#output\_nullplatform\_agent\_role\_arn) | ARN of the agent role |
<!-- END_TF_DOCS -->
