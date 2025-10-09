# Module: EKS

This module provisions an Amazon Elastic Kubernetes Service (EKS) cluster with managed node groups. It includes essential addons like CoreDNS, kube-proxy, and VPC-CNI, along with configurable managed node groups for workload execution.

Usage:

```hcl
module "eks" {
  source                  = "git@github.com:nullplatform/tofu-modules.git//infrastructure/aws/eks?ref=v0.0.1"
  name                    = var.name
  kubernetes_version      = var.kubernetes_version
  aws_vpc_vpc_id          = var.aws_vpc_vpc_id
  aws_subnets_private_ids = var.aws_subnets_private_ids

  ami_type       = var.ami_type
  instance_types = var.instance_types
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 21.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_type"></a> [ami\_type](#input\_ami\_type) | The ami type to use with node | `string` | `"AL2023_x86_64_STANDARD"` | no |
| <a name="input_aws_subnets_private_ids"></a> [aws\_subnets\_private\_ids](#input\_aws\_subnets\_private\_ids) | List of private subnet IDs for EKS cluster and node groups | `list(string)` | n/a | yes |
| <a name="input_aws_vpc_vpc_id"></a> [aws\_vpc\_vpc\_id](#input\_aws\_vpc\_vpc\_id) | VPC ID where the EKS cluster will be deployed | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | The instance type to use | `string` | `"t3.medium"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The version of K8s to use | `string` | `"1.32"` | no |
| <a name="input_name"></a> [name](#input\_name) | A name of cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_ca"></a> [eks\_cluster\_ca](#output\_eks\_cluster\_ca) | CA del cluster en base64 |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint del API Server |
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | Nombre del cluster EKS |
| <a name="output_eks_oidc_provider_arn"></a> [eks\_oidc\_provider\_arn](#output\_eks\_oidc\_provider\_arn) | ARN del OIDC provider del cluster |
<!-- END_TF_DOCS -->