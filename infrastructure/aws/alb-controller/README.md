# Module: ALB Controller

This module deploys the AWS Load Balancer Controller on an EKS cluster using Helm. It provides native AWS Application Load Balancer (ALB) and Network Load Balancer (NLB) support for Kubernetes ingress resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws-load-balancer-controller-role"></a> [aws-load-balancer-controller-role](#module\_aws-load-balancer-controller-role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | ~> 6.0 |

## Resources

| Name | Type |
|------|------|
| [helm_release.aws-load-balancer-controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_service_account.aws-load-balancer-controller-sa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws-load-balancer-controller-version"></a> [aws-load-balancer-controller-version](#input\_aws-load-balancer-controller-version) | Version of the AWS Load Balancer Controller Helm chart | `string` | `"1.13.4"` | no |
| <a name="input_aws_iam_openid_connect_provider"></a> [aws\_iam\_openid\_connect\_provider](#input\_aws\_iam\_openid\_connect\_provider) | AWS IAM OpenID Connect Provider for EKS cluster authentication | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where load balancers controller will be deployed | `string` | n/a | yes |
<!-- END_TF_DOCS -->