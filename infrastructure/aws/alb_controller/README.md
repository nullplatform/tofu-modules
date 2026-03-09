# Module: alb_controller

## Description

Deploys the AWS Load Balancer Controller to an Amazon EKS cluster using Helm

## Features

- Installs AWS Load Balancer Controller via Helm chart from official AWS repository
- Configures controller with EKS cluster name and VPC ID for load balancer management
- Creates service account for AWS Load Balancer Controller with configurable name
- Deploys to kube-system namespace with automatic namespace creation
- Enables atomic deployment with automatic cleanup on failure and pod recreation
- Supports version pinning of the AWS Load Balancer Controller Helm chart
- Configures webhook support and dependency updates for chart management

## Basic Usage

```hcl
module "alb_controller" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/alb_controller?ref=v1.43.0"

  cluster_name = "your-cluster-name"
  vpc_id       = "your-vpc-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.alb_controller.id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_load_balancer_controller_role"></a> [aws\_load\_balancer\_controller\_role](#module\_aws\_load\_balancer\_controller\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | ~> 6.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.lb_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [helm_release.aws_load_balancer_controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_service_account_v1.aws_load_balancer_controller_sa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_iam_openid_connect_provider"></a> [aws\_iam\_openid\_connect\_provider](#input\_aws\_iam\_openid\_connect\_provider) | AWS IAM OpenID Connect Provider for EKS cluster authentication | `string` | n/a | yes |
| <a name="input_aws_load_balancer_controller_version"></a> [aws\_load\_balancer\_controller\_version](#input\_aws\_load\_balancer\_controller\_version) | Version of the AWS Load Balancer Controller Helm chart | `string` | `"1.13.4"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where load balancers controller will be deployed | `string` | n/a | yes |
<!-- END_TF_DOCS -->
