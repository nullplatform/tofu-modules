# Module: aws_load_balancer_controller

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
module "aws_loadbalancer_controller_iam" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/aws_loadbalancer_controller_iam?ref=v1.43.0"

  aws_iam_openid_connect_provider_arn = module.eks.eks_oidc_provider_arn
  cluster_name                        = module.eks.eks_cluster_name
}

module "aws_load_balancer_controller" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/aws_load_balancer_controller?ref=v1.43.0"

  cluster_name         = module.eks.eks_cluster_name
  vpc_id               = module.vpc.vpc_id
  service_account_name = module.aws_loadbalancer_controller_iam.service_account_name
}
```

## Using Outputs

```hcl
# This module has no outputs. The AWS Load Balancer Controller
# is ready to use once the Helm release is deployed.
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

## Resources

| Name | Type |
|------|------|
| [helm_release.aws_load_balancer_controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where load balancers controller will be deployed | `string` | n/a | yes |
| <a name="input_aws_load_balancer_controller_version"></a> [aws\_load\_balancer\_controller\_version](#input\_aws\_load\_balancer\_controller\_version) | Version of the AWS Load Balancer Controller Helm chart | `string` | `"1.13.4"` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Name of the Kubernetes service account for the AWS Load Balancer Controller | `string` | `"aws-load-balancer-controller"` | no |
<!-- END_TF_DOCS -->
