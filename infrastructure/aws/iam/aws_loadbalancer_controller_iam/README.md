# Module: aws_loadbalancer_controller_iam

## Description

Creates IAM roles and Kubernetes service accounts for the AWS Load Balancer Controller on EKS clusters

## Features

- Creates IAM role for service accounts (IRSA) with AWS Load Balancer Controller permissions
- Configures Kubernetes service account with proper annotations for AWS IAM integration
- Deploys comprehensive IAM policy covering ELB, EC2, WAF, Shield, ACM, and Cognito operations
- Supports condition-based permissions for security group and load balancer management
- Enables automatic load balancer provisioning and management in EKS clusters
- Integrates with OIDC provider for secure AWS credential management

## Basic Usage

```hcl
module "aws_loadbalancer_controller_iam" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/aws_loadbalancer_controller_iam?ref=v1.42.0"

  aws_iam_openid_connect_provider_arn = module.eks.eks_oidc_provider_arn
  cluster_name                        = module.eks.eks_cluster_name
}
```

## Using Outputs

```hcl
module "aws_load_balancer_controller" {
  service_account_name = module.aws_loadbalancer_controller_iam.service_account_name
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
