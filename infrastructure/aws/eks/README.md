# Module: EKS

This module provisions an Amazon Elastic Kubernetes Service (EKS) cluster with managed node groups or  automode. It includes
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
  use_auto_mode  = var.use_auto_mode # for default false
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | >= 21.14, < 22.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_entries"></a> [access\_entries](#input\_access\_entries) | Map of access entries for the EKS cluster | <pre>map(object({<br/>    principal_arn     = string<br/>    user_name         = optional(string)<br/>    kubernetes_groups = optional(list(string))<br/>    type              = optional(string)<br/><br/>    policy_associations = optional(map(object({<br/>      policy_arn = string<br/>      access_scope = optional(object({<br/>        type       = optional(string)<br/>        namespaces = optional(list(string))<br/>      }))<br/>    })))<br/>  }))</pre> | `{}` | no |
| <a name="input_ami_type"></a> [ami\_type](#input\_ami\_type) | AMI type to use with the node | `string` | `"AL2023_x86_64_STANDARD"` | no |
| <a name="input_attach_cluster_primary_security_group"></a> [attach\_cluster\_primary\_security\_group](#input\_attach\_cluster\_primary\_security\_group) | Attach cluster primary security group to node groups | `bool` | `true` | no |
| <a name="input_auto_mode_node_pools"></a> [auto\_mode\_node\_pools](#input\_auto\_mode\_node\_pools) | Node pools for Auto Mode. Valid values are 'general-purpose' and 'system'. | `list(string)` | <pre>[<br/>  "general-purpose",<br/>  "system"<br/>]</pre> | no |
| <a name="input_aws_subnets_private_ids"></a> [aws\_subnets\_private\_ids](#input\_aws\_subnets\_private\_ids) | List of private subnet IDs for the EKS cluster and node groups | `list(string)` | n/a | yes |
| <a name="input_aws_vpc_vpc_id"></a> [aws\_vpc\_vpc\_id](#input\_aws\_vpc\_vpc\_id) | VPC ID where the EKS cluster will be deployed | `string` | n/a | yes |
| <a name="input_cluster_endpoint_public_access_cidrs"></a> [cluster\_endpoint\_public\_access\_cidrs](#input\_cluster\_endpoint\_public\_access\_cidrs) | List of CIDR blocks allowed to access the public EKS API server endpoint | `list(string)` | `[]` | no |
| <a name="input_endpoint_private_access"></a> [endpoint\_private\_access](#input\_endpoint\_private\_access) | Whether the Amazon EKS private API server endpoint is enabled | `bool` | `false` | no |
| <a name="input_endpoint_public_access"></a> [endpoint\_public\_access](#input\_endpoint\_public\_access) | Whether the Amazon EKS public API server endpoint is enabled | `bool` | `true` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Instance type to use | `string` | `"t3.medium"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | K8s version to use | `string` | `"1.32"` | no |
| <a name="input_name"></a> [name](#input\_name) | Cluster name | `string` | n/a | yes |
| <a name="input_node_group_desired_size"></a> [node\_group\_desired\_size](#input\_node\_group\_desired\_size) | Desired number of nodes in the managed node group | `number` | `2` | no |
| <a name="input_node_group_max_size"></a> [node\_group\_max\_size](#input\_node\_group\_max\_size) | Maximum number of nodes in the managed node group | `number` | `10` | no |
| <a name="input_node_group_min_size"></a> [node\_group\_min\_size](#input\_node\_group\_min\_size) | Minimum number of nodes in the managed node group | `number` | `2` | no |
| <a name="input_use_auto_mode"></a> [use\_auto\_mode](#input\_use\_auto\_mode) | Use EKS Auto Mode (true) or Managed Node Groups (false) | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_ca"></a> [eks\_cluster\_ca](#output\_eks\_cluster\_ca) | Cluster CA in base64 |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | API Server endpoint |
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | EKS cluster name |
| <a name="output_eks_node_iam_role_arn"></a> [eks\_node\_iam\_role\_arn](#output\_eks\_node\_iam\_role\_arn) | ARN of the IAM role for EKS nodes (Auto Mode or Managed Node Groups) |
| <a name="output_eks_node_iam_role_name"></a> [eks\_node\_iam\_role\_name](#output\_eks\_node\_iam\_role\_name) | Name of the IAM role for EKS nodes |
| <a name="output_eks_oidc_provider_arn"></a> [eks\_oidc\_provider\_arn](#output\_eks\_oidc\_provider\_arn) | ARN of the cluster's OIDC provider |
<!-- END_TF_DOCS -->