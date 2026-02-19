# Module: security

## Description

Creates AWS security groups for Istio gateways with restricted health check access and configurable HTTPS traffic rules

## Features

- Creates security groups for Istio public and private gateways on AWS EKS
- Restricts health check port (15021) to VPC CIDR for enhanced security
- Configures HTTPS (443) traffic rules with internet or VPC-only access based on gateway type
- Automatically derives VPC ID and CIDR block from EKS cluster name
- Supports manual override of VPC ID and network CIDR for custom configurations
- Provides separate security groups for public (internet-facing) and private (internal) gateways

## Basic Usage

```hcl
module "security" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/security?ref=v1.35.0"

  cluster_name = "your-cluster-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.security.public_gateway_security_group_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.private_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.public_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.private_gateway_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.public_gateway_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.private_gateway_health_check](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.private_gateway_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.public_gateway_health_check](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.public_gateway_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The EKS cluster name, used for naming security resources and deriving VPC. | `string` | n/a | yes |
| <a name="input_gateway_internal_enabled"></a> [gateway\_internal\_enabled](#input\_gateway\_internal\_enabled) | Whether the internal (private) gateway is enabled. | `bool` | `false` | no |
| <a name="input_gateways_enabled"></a> [gateways\_enabled](#input\_gateways\_enabled) | Whether public gateways are enabled. | `bool` | `true` | no |
| <a name="input_network_cidr"></a> [network\_cidr](#input\_network\_cidr) | Override: The network CIDR block. If empty, derived automatically from VPC. | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Override: The VPC ID. If empty, derived automatically from cluster name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_gateway_security_group_id"></a> [private\_gateway\_security\_group\_id](#output\_private\_gateway\_security\_group\_id) | The ID of the private gateway security group. |
| <a name="output_public_gateway_security_group_id"></a> [public\_gateway\_security\_group\_id](#output\_public\_gateway\_security\_group\_id) | The ID of the public gateway security group. |
<!-- END_TF_DOCS -->
