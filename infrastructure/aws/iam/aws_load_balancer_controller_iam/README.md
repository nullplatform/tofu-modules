# Module: aws_load_balancer_controller_iam

## Description

Configures AWS Load Balancer Controller with IAM role and Kubernetes service account

## Architecture

This module creates an IAM role for the AWS Load Balancer Controller using the terraform-aws-modules/iam/aws module, and a Kubernetes service account in the specified namespace. The IAM role is attached to the service account using the eks.amazonaws.com/role-arn annotation. The module also creates an IAM policy for the Load Balancer Controller and attaches it to the IAM role. The policy grants permissions for the Load Balancer Controller to manage Elastic Load Balancers, target groups, and security groups. The module uses the aws_iam_openid_connect_provider_arn variable to authenticate the service account with the AWS IAM OIDC provider.

## Features

- Creates IAM role for AWS Load Balancer Controller with custom policy
- Configures Kubernetes service account with IAM role annotation
- Attaches IAM policy to IAM role for Load Balancer Controller permissions
- Supports EKS cluster integration with AWS Load Balancer Controller

## Basic Usage

```hcl
module "aws_load_balancer_controller_iam" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/aws_load_balancer_controller_iam?ref=v6.1.0"

  aws_iam_openid_connect_provider_arn = "your-aws-iam-openid-connect-provider-arn"
  cluster_name                        = "your-cluster-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.aws_load_balancer_controller_iam.role_arn
}
```

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_load_balancer_controller_role"></a> [aws\_load\_balancer\_controller\_role](#module\_aws\_load\_balancer\_controller\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | ~> 6.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.lb_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [kubernetes_service_account_v1.aws_load_balancer_controller_sa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_iam_openid_connect_provider_arn"></a> [aws\_iam\_openid\_connect\_provider\_arn](#input\_aws\_iam\_openid\_connect\_provider\_arn) | ARN of the AWS IAM OIDC provider for EKS service account authentication | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Name of the Kubernetes service account for the AWS Load Balancer Controller | `string` | `"aws-load-balancer-controller"` | no |
| <a name="input_service_account_namespace"></a> [service\_account\_namespace](#input\_service\_account\_namespace) | Kubernetes namespace where the AWS Load Balancer Controller service account will be created | `string` | `"kube-system"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of the AWS Load Balancer Controller IAM role |
| <a name="output_service_account_name"></a> [service\_account\_name](#output\_service\_account\_name) | Name of the Kubernetes service account for the AWS Load Balancer Controller |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "aws_load_balancer_controller_iam",
  "description": "Configures AWS Load Balancer Controller with IAM role and Kubernetes service account",
  "architecture": "This module creates an IAM role for the AWS Load Balancer Controller using the terraform-aws-modules/iam/aws module, and a Kubernetes service account in the specified namespace. The IAM role is attached to the service account using the eks.amazonaws.com/role-arn annotation. The module also creates an IAM policy for the Load Balancer Controller and attaches it to the IAM role. The policy grants permissions for the Load Balancer Controller to manage Elastic Load Balancers, target groups, and security groups. The module uses the aws_iam_openid_connect_provider_arn variable to authenticate the service account with the AWS IAM OIDC provider.",
  "features": [
    "Creates IAM role for AWS Load Balancer Controller with custom policy",
    "Configures Kubernetes service account with IAM role annotation",
    "Attaches IAM policy to IAM role for Load Balancer Controller permissions",
    "Supports EKS cluster integration with AWS Load Balancer Controller"
  ],
  "inputs": [
    {
      "name": "cluster_name",
      "description": "Name of the EKS cluster",
      "required": true
    },
    {
      "name": "aws_iam_openid_connect_provider_arn",
      "description": "ARN of the AWS IAM OIDC provider for EKS service account authentication",
      "required": true
    },
    {
      "name": "service_account_namespace",
      "description": "Kubernetes namespace where the AWS Load Balancer Controller service account will be created",
      "required": false
    },
    {
      "name": "service_account_name",
      "description": "Name of the Kubernetes service account for the AWS Load Balancer Controller",
      "required": false
    }
  ],
  "outputs": [
    "role_arn",
    "service_account_name"
  ],
  "hash": "b444ed64e26a2be2b19521629e4fa195"
}
END_AI_METADATA -->
