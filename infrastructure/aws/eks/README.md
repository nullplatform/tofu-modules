# Module: eks

## Description

Provisions an Amazon EKS cluster with managed node groups or Auto Mode, core add-ons, IRSA, and an EBS CSI driver IAM role using the terraform-aws-modules/eks module

## Architecture

The module wraps terraform-aws-modules/eks to create the EKS cluster (aws_eks_cluster), optionally provisioning either an EKS managed node group or Auto Mode compute config based on the use_auto_mode flag. An aws_iam_role (ebs_csi_driver) is created and wired into the aws-ebs-csi-driver add-on via service_account_role_arn, while IRSA is enabled to expose an OIDC provider ARN as output. Security group additional rules for NLB health checks and HTTPS ingress are conditionally injected via security_group_additional_rules, using the VPC CIDR fetched from the aws_vpc data source combined with any additional_network_cidrs.

## Features

- Creates EKS cluster with configurable Kubernetes version and dual endpoint access control
- Provisions EKS managed node group with configurable AMI type, instance type, and scaling parameters
- Enables EKS Auto Mode with configurable node pools (general-purpose and/or system) as an alternative to managed node groups
- Installs core EKS add-ons: aws-ebs-csi-driver, coredns, eks-pod-identity-agent, kube-proxy, and vpc-cni
- Creates IAM role for the EBS CSI driver and wires it to the add-on via IRSA with OIDC provider
- Configures optional CloudWatch log group for EKS control plane logs with configurable retention
- Adds conditional security group rules for NLB health checks (port 15021) and HTTPS (port 443) ingress from VPC and peered CIDRs

## Basic Usage

```hcl
module "eks" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/eks?ref=v6.17.0"

  aws_subnets_private_ids = "your-aws-subnets-private-ids"
  aws_vpc_vpc_id          = "your-aws-vpc-vpc-id"
  name                    = "your-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.eks.eks_cluster_name
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.16, < 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.41.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.38.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | >= 21.14, < 22.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.ebs_csi_driver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ebs_csi_driver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [kubernetes_annotations.gp2_not_default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/annotations) | resource |
| [kubernetes_storage_class_v1.gp3](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_entries"></a> [access\_entries](#input\_access\_entries) | Map of access entries for the EKS cluster | <pre>map(object({<br/>    principal_arn     = string<br/>    user_name         = optional(string)<br/>    kubernetes_groups = optional(list(string))<br/>    type              = optional(string)<br/><br/>    policy_associations = optional(map(object({<br/>      policy_arn = string<br/>      access_scope = optional(object({<br/>        type       = optional(string)<br/>        namespaces = optional(list(string))<br/>      }))<br/>    })))<br/>  }))</pre> | `{}` | no |
| <a name="input_additional_network_cidrs"></a> [additional\_network\_cidrs](#input\_additional\_network\_cidrs) | Additional CIDR blocks to allow in security group rules (e.g., peered VPC, on-premises network). | `list(string)` | `[]` | no |
| <a name="input_ami_release_version"></a> [ami\_release\_version](#input\_ami\_release\_version) | Pin a specific AMI release version for the managed node group (e.g. "1.34.6-20260415").<br/>When null, the upstream module resolves the AMI based on use\_latest\_ami\_release\_version.<br/>Set this to a fixed value when reproducible AMIs are required (e.g. to avoid plan drift<br/>every time AWS publishes a new optimized AMI). | `string` | `null` | no |
| <a name="input_ami_type"></a> [ami\_type](#input\_ami\_type) | AMI type to use with the node | `string` | `"AL2023_x86_64_STANDARD"` | no |
| <a name="input_attach_cluster_primary_security_group"></a> [attach\_cluster\_primary\_security\_group](#input\_attach\_cluster\_primary\_security\_group) | Attach cluster primary security group to node groups | `bool` | `true` | no |
| <a name="input_authentication_mode"></a> [authentication\_mode](#input\_authentication\_mode) | Authentication mode for the EKS cluster. Valid values: CONFIG\_MAP, API, API\_AND\_CONFIG\_MAP. | `string` | `"API_AND_CONFIG_MAP"` | no |
| <a name="input_auto_mode_node_pools"></a> [auto\_mode\_node\_pools](#input\_auto\_mode\_node\_pools) | Node pools for Auto Mode. Valid values are 'general-purpose' and 'system'. | `list(string)` | <pre>[<br/>  "general-purpose",<br/>  "system"<br/>]</pre> | no |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | Optional AWS CLI profile used by the kubernetes provider's exec plugin (`aws eks get-token`) to authenticate against the cluster. If empty, the default AWS credential chain (or the AWS\_PROFILE environment variable) is used. | `string` | `""` | no |
| <a name="input_aws_subnets_private_ids"></a> [aws\_subnets\_private\_ids](#input\_aws\_subnets\_private\_ids) | List of private subnet IDs for the EKS cluster and node groups | `list(string)` | n/a | yes |
| <a name="input_aws_vpc_vpc_id"></a> [aws\_vpc\_vpc\_id](#input\_aws\_vpc\_vpc\_id) | VPC ID where the EKS cluster will be deployed | `string` | n/a | yes |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | Number of days to retain log events in the CloudWatch log group | `number` | `90` | no |
| <a name="input_create_cloudwatch_log_group"></a> [create\_cloudwatch\_log\_group](#input\_create\_cloudwatch\_log\_group) | Whether to create a CloudWatch log group for cluster logs. If false and logging is enabled, AWS creates it automatically but outside of Terraform management. | `bool` | `true` | no |
| <a name="input_enabled_log_types"></a> [enabled\_log\_types](#input\_enabled\_log\_types) | List of EKS control plane log types to enable. Valid values: api, audit, authenticator, controllerManager, scheduler | `list(string)` | `[]` | no |
| <a name="input_encryption_config"></a> [encryption\_config](#input\_encryption\_config) | Encryption config for the EKS control plane (KMS encryption of Kubernetes<br/>secrets stored in etcd). Type matches the upstream<br/>`terraform-aws-modules/eks/aws` variable of the same name.<br/><br/>Default `{}` (no `provider_key_arn`): the upstream module creates an<br/>auto-managed KMS key and uses it to encrypt etcd secrets — this matches<br/>the wrapper's pre-existing behavior and is what existing consumers<br/>already get today (no change after upgrading).<br/><br/>Bring your own CMK (typically required by audit/compliance reviews):<br/><br/>    encryption\_config = {<br/>      provider\_key\_arn = aws\_kms\_key.eks\_secrets.arn<br/>    }<br/><br/>When `provider_key_arn` is set, the wrapper automatically passes<br/>`create_kms_key = false` to the upstream module so the supplied ARN is<br/>used instead of an auto-generated key. (Without this, the upstream<br/>default `create_kms_key = true` would silently override the operator's<br/>ARN.)<br/><br/>`resources` defaults to `["secrets"]` (the only resource EKS supports<br/>encrypting today) and rarely needs to be set explicitly.<br/><br/>Note: the EKS cluster's `encryption_config` block is ForceNew. Switching<br/>a cluster from no-encryption to encryption (or changing `provider_key_arn`)<br/>after initial creation triggers a cluster replacement. Decide on the<br/>encryption strategy before the first `tofu apply`. | <pre>object({<br/>    provider_key_arn = optional(string)<br/>    resources        = optional(list(string), ["secrets"])<br/>  })</pre> | `{}` | no |
| <a name="input_endpoint_private_access"></a> [endpoint\_private\_access](#input\_endpoint\_private\_access) | Whether the Amazon EKS private API server endpoint is enabled | `bool` | `false` | no |
| <a name="input_endpoint_public_access"></a> [endpoint\_public\_access](#input\_endpoint\_public\_access) | Whether the Amazon EKS public API server endpoint is enabled | `bool` | `true` | no |
| <a name="input_endpoint_public_access_cidrs"></a> [endpoint\_public\_access\_cidrs](#input\_endpoint\_public\_access\_cidrs) | List of CIDR blocks allowed to access the public EKS API server endpoint | `list(string)` | `[]` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Instance type to use | `string` | `"t3.medium"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | K8s version to use | `string` | `"1.34"` | no |
| <a name="input_name"></a> [name](#input\_name) | Cluster name | `string` | n/a | yes |
| <a name="input_node_group_desired_size"></a> [node\_group\_desired\_size](#input\_node\_group\_desired\_size) | Desired number of nodes in the managed node group | `number` | `2` | no |
| <a name="input_node_group_max_size"></a> [node\_group\_max\_size](#input\_node\_group\_max\_size) | Maximum number of nodes in the managed node group | `number` | `10` | no |
| <a name="input_node_group_min_size"></a> [node\_group\_min\_size](#input\_node\_group\_min\_size) | Minimum number of nodes in the managed node group | `number` | `2` | no |
| <a name="input_security_group_additional_rules"></a> [security\_group\_additional\_rules](#input\_security\_group\_additional\_rules) | Whether to create additional security group rules for NLB health checks and HTTPS traffic | `bool` | `true` | no |
| <a name="input_use_auto_mode"></a> [use\_auto\_mode](#input\_use\_auto\_mode) | Use EKS Auto Mode (true) or Managed Node Groups (false) | `bool` | `false` | no |
| <a name="input_use_latest_ami_release_version"></a> [use\_latest\_ami\_release\_version](#input\_use\_latest\_ami\_release\_version) | If true, the upstream module looks up the latest AMI release version from the SSM<br/>parameter `/aws/service/eks/optimized-ami/.../recommended/release_version` on every plan,<br/>which surfaces drift whenever AWS publishes a new AMI. When null, defers to the upstream<br/>default (true in terraform-aws-modules/eks v21+). Set to false together with<br/>ami\_release\_version to pin the AMI to an explicit value. | `bool` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_ca"></a> [eks\_cluster\_ca](#output\_eks\_cluster\_ca) | Cluster CA in base64 |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | API Server endpoint |
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | EKS cluster name |
| <a name="output_eks_cluster_primary_security_group_id"></a> [eks\_cluster\_primary\_security\_group\_id](#output\_eks\_cluster\_primary\_security\_group\_id) | Primary security group ID of the EKS cluster (auto-created by EKS, attached to all nodes and ENIs) |
| <a name="output_eks_cluster_security_group_id"></a> [eks\_cluster\_security\_group\_id](#output\_eks\_cluster\_security\_group\_id) | Security group ID attached to the EKS cluster |
| <a name="output_eks_node_iam_role_arn"></a> [eks\_node\_iam\_role\_arn](#output\_eks\_node\_iam\_role\_arn) | ARN of the IAM role for EKS nodes (Auto Mode or Managed Node Groups) |
| <a name="output_eks_node_iam_role_name"></a> [eks\_node\_iam\_role\_name](#output\_eks\_node\_iam\_role\_name) | Name of the IAM role for EKS nodes |
| <a name="output_eks_oidc_provider_arn"></a> [eks\_oidc\_provider\_arn](#output\_eks\_oidc\_provider\_arn) | ARN of the cluster's OIDC provider |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "eks",
  "description": "Provisions an Amazon EKS cluster with managed node groups or Auto Mode, core add-ons, IRSA, and an EBS CSI driver IAM role using the terraform-aws-modules/eks module",
  "architecture": "The module wraps terraform-aws-modules/eks to create the EKS cluster (aws_eks_cluster), optionally provisioning either an EKS managed node group or Auto Mode compute config based on the use_auto_mode flag. An aws_iam_role (ebs_csi_driver) is created and wired into the aws-ebs-csi-driver add-on via service_account_role_arn, while IRSA is enabled to expose an OIDC provider ARN as output. Security group additional rules for NLB health checks and HTTPS ingress are conditionally injected via security_group_additional_rules, using the VPC CIDR fetched from the aws_vpc data source combined with any additional_network_cidrs.",
  "features": [
    "Creates EKS cluster with configurable Kubernetes version and dual endpoint access control",
    "Provisions EKS managed node group with configurable AMI type, instance type, and scaling parameters",
    "Enables EKS Auto Mode with configurable node pools (general-purpose and/or system) as an alternative to managed node groups",
    "Installs core EKS add-ons: aws-ebs-csi-driver, coredns, eks-pod-identity-agent, kube-proxy, and vpc-cni",
    "Creates IAM role for the EBS CSI driver and wires it to the add-on via IRSA with OIDC provider",
    "Configures optional CloudWatch log group for EKS control plane logs with configurable retention",
    "Adds conditional security group rules for NLB health checks (port 15021) and HTTPS (port 443) ingress from VPC and peered CIDRs"
  ],
  "inputs": [
    {
      "name": "name",
      "description": "Cluster name",
      "required": true
    },
    {
      "name": "aws_vpc_vpc_id",
      "description": "VPC ID where the EKS cluster will be deployed",
      "required": true
    },
    {
      "name": "aws_subnets_private_ids",
      "description": "List of private subnet IDs for the EKS cluster and node groups",
      "required": true
    },
    {
      "name": "auto_mode_node_pools",
      "description": "Node pools for Auto Mode. Valid values are 'general-purpose' and 'system'.",
      "required": false
    },
    {
      "name": "endpoint_public_access_cidrs",
      "description": "List of CIDR blocks allowed to access the public EKS API server endpoint",
      "required": false
    },
    {
      "name": "authentication_mode",
      "description": "Authentication mode for the EKS cluster. Valid values: CONFIG_MAP, API, API_AND_CONFIG_MAP.",
      "required": false
    },
    {
      "name": "ami_type",
      "description": "AMI type to use with the node",
      "required": false
    },
    {
      "name": "instance_types",
      "description": "Instance type to use",
      "required": false
    },
    {
      "name": "kubernetes_version",
      "description": "K8s version to use",
      "required": false
    },
    {
      "name": "access_entries",
      "description": "Map of access entries for the EKS cluster",
      "required": false
    },
    {
      "name": "use_auto_mode",
      "description": "Use EKS Auto Mode (true) or Managed Node Groups (false)",
      "required": false
    },
    {
      "name": "attach_cluster_primary_security_group",
      "description": "Attach cluster primary security group to node groups",
      "required": false
    },
    {
      "name": "node_group_min_size",
      "description": "Minimum number of nodes in the managed node group",
      "required": false
    },
    {
      "name": "ami_release_version",
      "description": "",
      "required": false
    },
    {
      "name": "use_latest_ami_release_version",
      "description": "",
      "required": false
    },
    {
      "name": "node_group_max_size",
      "description": "Maximum number of nodes in the managed node group",
      "required": false
    },
    {
      "name": "node_group_desired_size",
      "description": "Desired number of nodes in the managed node group",
      "required": false
    },
    {
      "name": "endpoint_public_access",
      "description": "Whether the Amazon EKS public API server endpoint is enabled",
      "required": false
    },
    {
      "name": "endpoint_private_access",
      "description": "Whether the Amazon EKS private API server endpoint is enabled",
      "required": false
    },
    {
      "name": "security_group_additional_rules",
      "description": "Whether to create additional security group rules for NLB health checks and HTTPS traffic",
      "required": false
    },
    {
      "name": "additional_network_cidrs",
      "description": "Additional CIDR blocks to allow in security group rules (e.g., peered VPC, on-premises network).",
      "required": false
    },
    {
      "name": "enabled_log_types",
      "description": "List of EKS control plane log types to enable. Valid values: api, audit, authenticator, controllerManager, scheduler",
      "required": false
    },
    {
      "name": "create_cloudwatch_log_group",
      "description": "Whether to create a CloudWatch log group for cluster logs. If false and logging is enabled, AWS creates it automatically but outside of Terraform management.",
      "required": false
    },
    {
      "name": "cloudwatch_log_group_retention_in_days",
      "description": "Number of days to retain log events in the CloudWatch log group",
      "required": false
    },
    {
      "name": "encryption_config",
      "description": "Encryption config for the EKS control plane (KMS encryption of etcd secrets). Default {} preserves the wrapper's pre-existing behavior: the upstream module auto-creates a KMS key. Set provider_key_arn to bring your own CMK — the wrapper then auto-disables upstream's create_kms_key so the supplied ARN is honored.",
      "required": false
    }
  ],
  "outputs": [
    "eks_cluster_name",
    "eks_cluster_endpoint",
    "eks_cluster_ca",
    "eks_oidc_provider_arn",
    "eks_node_iam_role_arn",
    "eks_node_iam_role_name",
    "eks_cluster_security_group_id",
    "eks_cluster_primary_security_group_id"
  ],
  "hash": "a20671d0031dc3797531a0a3d823521e"
}
END_AI_METADATA -->
