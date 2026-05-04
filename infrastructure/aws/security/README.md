# Module: security

## Description

Creates AWS security groups for Istio ingress gateways with separate rules for public and private gateways, restricting health check traffic to VPC CIDR while allowing HTTPS access

## Architecture

Queries aws_eks_cluster and aws_vpc data sources to derive VPC ID and CIDR block when not explicitly provided. Creates aws_security_group resources for public and private Istio gateways, then provisions aws_vpc_security_group_ingress_rule resources for HTTPS (port 443) and health check (port 15021) traffic. Public gateway allows HTTPS from 0.0.0.0/0 while restricting health checks to VPC CIDR; private gateway restricts both HTTPS and health checks to VPC CIDR. Additional network CIDRs are applied via for_each loops on ingress rules.

## Features

- Creates public gateway security group with HTTPS open to internet and health check restricted to VPC
- Creates private gateway security group with HTTPS and health check both restricted to VPC CIDR
- Derives VPC ID and CIDR automatically from EKS cluster name when overrides not provided
- Supports additional network CIDRs for peered VPCs or on-premises networks
- Conditionally creates health check rules on port 15021 based on load balancer type

## Basic Usage

```hcl
module "security" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/security?ref=v2.0.0"

  name = "your-name"
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
| [aws_vpc_security_group_ingress_rule.private_gateway_health_check](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.private_gateway_health_check_additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.private_gateway_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.private_gateway_https_additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.public_gateway_health_check](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.public_gateway_health_check_additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.public_gateway_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_network_cidrs"></a> [additional\_network\_cidrs](#input\_additional\_network\_cidrs) | Additional CIDR blocks to allow in security group rules (e.g., peered VPC, on-premises network). | `list(string)` | `[]` | no |
| <a name="input_gateway_internal_enabled"></a> [gateway\_internal\_enabled](#input\_gateway\_internal\_enabled) | Whether the internal (private) gateway is enabled. | `bool` | `false` | no |
| <a name="input_gateways_enabled"></a> [gateways\_enabled](#input\_gateways\_enabled) | Whether public gateways are enabled. | `bool` | `true` | no |
| <a name="input_health_check_rules_enabled"></a> [health\_check\_rules\_enabled](#input\_health\_check\_rules\_enabled) | Whether to create port 15021 (Istio health check) inbound rules on the gateway SGs. Set to false when using ALB (health checks are outbound from ALB, not inbound). Only needed for NLB/direct access patterns. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name prefix for security group resources and tags. When vpc\_id is not provided, also used as the EKS cluster name to derive VPC and CIDR. | `string` | n/a | yes |
| <a name="input_network_cidr"></a> [network\_cidr](#input\_network\_cidr) | Override: The network CIDR block. If empty, derived automatically from VPC. | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Override: The VPC ID. If empty, derived automatically from cluster name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_gateway_security_group_id"></a> [private\_gateway\_security\_group\_id](#output\_private\_gateway\_security\_group\_id) | The ID of the private gateway security group. |
| <a name="output_public_gateway_security_group_id"></a> [public\_gateway\_security\_group\_id](#output\_public\_gateway\_security\_group\_id) | The ID of the public gateway security group. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "security",
  "description": "Creates AWS security groups for Istio ingress gateways with separate rules for public and private gateways, restricting health check traffic to VPC CIDR while allowing HTTPS access",
  "architecture": "Queries aws_eks_cluster and aws_vpc data sources to derive VPC ID and CIDR block when not explicitly provided. Creates aws_security_group resources for public and private Istio gateways, then provisions aws_vpc_security_group_ingress_rule resources for HTTPS (port 443) and health check (port 15021) traffic. Public gateway allows HTTPS from 0.0.0.0/0 while restricting health checks to VPC CIDR; private gateway restricts both HTTPS and health checks to VPC CIDR. Additional network CIDRs are applied via for_each loops on ingress rules.",
  "features": [
    "Creates public gateway security group with HTTPS open to internet and health check restricted to VPC",
    "Creates private gateway security group with HTTPS and health check both restricted to VPC CIDR",
    "Derives VPC ID and CIDR automatically from EKS cluster name when overrides not provided",
    "Supports additional network CIDRs for peered VPCs or on-premises networks",
    "Conditionally creates health check rules on port 15021 based on load balancer type"
  ],
  "inputs": [
    {
      "name": "name",
      "description": "Name prefix for security group resources and tags. When vpc_id is not provided, also used as the EKS cluster name to derive VPC and CIDR.",
      "required": true
    },
    {
      "name": "gateways_enabled",
      "description": "Whether public gateways are enabled.",
      "required": false
    },
    {
      "name": "gateway_internal_enabled",
      "description": "Whether the internal (private) gateway is enabled.",
      "required": false
    },
    {
      "name": "vpc_id",
      "description": "Override: The VPC ID. If empty, derived automatically from cluster name.",
      "required": false
    },
    {
      "name": "network_cidr",
      "description": "Override: The network CIDR block. If empty, derived automatically from VPC.",
      "required": false
    },
    {
      "name": "additional_network_cidrs",
      "description": "Additional CIDR blocks to allow in security group rules (e.g., peered VPC, on-premises network).",
      "required": false
    },
    {
      "name": "health_check_rules_enabled",
      "description": "Whether to create port 15021 (Istio health check) inbound rules on the gateway SGs. Set to false when using ALB (health checks are outbound from ALB, not inbound). Only needed for NLB/direct access patterns.",
      "required": false
    }
  ],
  "outputs": [
    "public_gateway_security_group_id",
    "private_gateway_security_group_id"
  ],
  "hash": "01cf95703731d448ecaf11008f4c844d"
}
END_AI_METADATA -->
