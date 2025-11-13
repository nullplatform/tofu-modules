# Module: EKS

This module provisions an Amazon Elastic Kubernetes Service (EKS) cluster with managed node groups. It includes
essential addons like CoreDNS, kube-proxy, and VPC-CNI, along with configurable managed node groups for workload
execution.

## Usage

```hcl
module "eks" {
  source                  = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/aws/eks?ref=v1.0.0"
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

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 21.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.eks_auto_mode_node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eks_auto_mode_cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_auto_mode_container_registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_auto_mode_ssm_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_auto_mode_worker_node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_entries"></a> [access\_entries](#input\_access\_entries) | Map of access entries for the EKS cluster | <pre>map(object({<br/>    principal_arn     = string<br/>    user_name         = optional(string)<br/>    kubernetes_groups = optional(list(string))<br/>    type              = optional(string)<br/><br/>    policy_associations = optional(map(object({<br/>      policy_arn = string<br/>      access_scope = optional(object({<br/>        type       = optional(string)<br/>        namespaces = optional(list(string))<br/>      }))<br/>    })))<br/>  }))</pre> | `{}` | no |
| <a name="input_ami_type"></a> [ami\_type](#input\_ami\_type) | AMI type to use with the node | `string` | `"AL2023_x86_64_STANDARD"` | no |
| <a name="input_aws_subnets_private_ids"></a> [aws\_subnets\_private\_ids](#input\_aws\_subnets\_private\_ids) | List of private subnet IDs for the EKS cluster and node groups | `list(string)` | n/a | yes |
| <a name="input_aws_vpc_vpc_id"></a> [aws\_vpc\_vpc\_id](#input\_aws\_vpc\_vpc\_id) | VPC ID where the EKS cluster will be deployed | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Instance type to use | `string` | `"t3.medium"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | K8s version to use | `string` | `"1.32"` | no |
| <a name="input_name"></a> [name](#input\_name) | Cluster name | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_auto_mode_node_role_arn"></a> [auto\_mode\_node\_role\_arn](#output\_auto\_mode\_node\_role\_arn) | IAM role ARN for Auto Mode nodes |
| <a name="output_auto_mode_node_role_name"></a> [auto\_mode\_node\_role\_name](#output\_auto\_mode\_node\_role\_name) | IAM role name for Auto Mode nodes |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | Base64 encoded certificate data required to communicate with the cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint for EKS control plane |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | EKS cluster ID |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | EKS cluster name |
| <a name="output_eks_cluster_ca"></a> [eks\_cluster\_ca](#output\_eks\_cluster\_ca) | Cluster CA in base64 |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | API Server endpoint |
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | EKS cluster name |
| <a name="output_eks_oidc_provider_arn"></a> [eks\_oidc\_provider\_arn](#output\_eks\_oidc\_provider\_arn) | ARN of the cluster's OIDC provider |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | ARN of the OIDC Provider for EKS |
<!-- END_TF_DOCS -->