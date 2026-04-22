# Module: security

## Description

Creates AWS security groups for Istio public and private gateways with configurable ingress/egress rules for HTTPS traffic and health checks

## Architecture

The module queries aws_eks_cluster and aws_vpc data sources to derive VPC ID and CIDR block from the cluster name. It creates aws_security_group resources for public and private Istio gateways, each with multiple aws_vpc_security_group_ingress_rule and aws_vpc_security_group_egress_rule resources controlling traffic on port 443 (HTTPS) and port 15021 (health checks). When cluster_security_group_id is provided, additional ingress rules are created on the cluster security group to allow traffic from gateway security groups. Public gateway allows HTTPS from 0.0.0.0/0 while private gateway restricts HTTPS to VPC CIDR. Health check rules can be conditionally created and support additional CIDR blocks via for_each iteration.

## Features

- Creates security group for public Istio gateway with HTTPS open to internet and health checks restricted to VPC CIDR
- Creates security group for private Istio gateway with all traffic restricted to VPC CIDR only
- Derives VPC ID and CIDR block automatically from EKS cluster name via data sources
- Supports additional CIDR blocks for health check and HTTPS ingress rules via for_each iteration
- Creates optional ingress rules on EKS cluster security group to allow ALB-to-pod traffic on gateway and health check ports
- Configures separate ingress rules for port 443 (HTTPS) and port 15021 (Istio health checks)
- Supports overriding derived VPC ID and network CIDR with explicit variable values

## Basic Usage

```hcl
module "security" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/security?ref=v1.53.0"

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
| [aws_vpc_security_group_ingress_rule.cluster_from_private_gateway_health](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.cluster_from_private_gateway_traffic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.cluster_from_public_gateway_health](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.cluster_from_public_gateway_traffic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
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
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The EKS cluster name, used for naming security resources and deriving VPC. | `string` | n/a | yes |
| <a name="input_cluster_security_group_id"></a> [cluster\_security\_group\_id](#input\_cluster\_security\_group\_id) | The EKS cluster primary security group ID. When set, ingress rules are created on this SG to allow traffic from the gateway SGs on the gateway and health check ports. Required for ALB setups where the ALB needs to reach pods. | `string` | `""` | no |
| <a name="input_gateway_internal_enabled"></a> [gateway\_internal\_enabled](#input\_gateway\_internal\_enabled) | Whether the internal (private) gateway is enabled. | `bool` | `false` | no |
| <a name="input_gateway_port"></a> [gateway\_port](#input\_gateway\_port) | The port used by Istio gateway pods for traffic. Used for cluster SG ingress rules when cluster\_security\_group\_id is set. | `number` | `443` | no |
| <a name="input_gateways_enabled"></a> [gateways\_enabled](#input\_gateways\_enabled) | Whether public gateways are enabled. | `bool` | `true` | no |
| <a name="input_health_check_rules_enabled"></a> [health\_check\_rules\_enabled](#input\_health\_check\_rules\_enabled) | Whether to create port 15021 (Istio health check) inbound rules on the gateway SGs. Set to false when using ALB (health checks are outbound from ALB, not inbound). Only needed for NLB/direct access patterns. | `bool` | `true` | no |
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
  "description": "Creates AWS security groups for Istio public and private gateways with configurable ingress/egress rules for HTTPS traffic and health checks",
  "architecture": "The module queries aws_eks_cluster and aws_vpc data sources to derive VPC ID and CIDR block from the cluster name. It creates aws_security_group resources for public and private Istio gateways, each with multiple aws_vpc_security_group_ingress_rule and aws_vpc_security_group_egress_rule resources controlling traffic on port 443 (HTTPS) and port 15021 (health checks). When cluster_security_group_id is provided, additional ingress rules are created on the cluster security group to allow traffic from gateway security groups. Public gateway allows HTTPS from 0.0.0.0/0 while private gateway restricts HTTPS to VPC CIDR. Health check rules can be conditionally created and support additional CIDR blocks via for_each iteration.",
  "features": [
    "Creates security group for public Istio gateway with HTTPS open to internet and health checks restricted to VPC CIDR",
    "Creates security group for private Istio gateway with all traffic restricted to VPC CIDR only",
    "Derives VPC ID and CIDR block automatically from EKS cluster name via data sources",
    "Supports additional CIDR blocks for health check and HTTPS ingress rules via for_each iteration",
    "Creates optional ingress rules on EKS cluster security group to allow ALB-to-pod traffic on gateway and health check ports",
    "Configures separate ingress rules for port 443 (HTTPS) and port 15021 (Istio health checks)",
    "Supports overriding derived VPC ID and network CIDR with explicit variable values"
  ],
  "inputs": [
    {
      "name": "cluster_name",
      "description": "The EKS cluster name, used for naming security resources and deriving VPC.",
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
    },
    {
      "name": "cluster_security_group_id",
      "description": "The EKS cluster primary security group ID. When set, ingress rules are created on this SG to allow traffic from the gateway SGs on the gateway and health check ports. Required for ALB setups where the ALB needs to reach pods.",
      "required": false
    },
    {
      "name": "gateway_port",
      "description": "The port used by Istio gateway pods for traffic. Used for cluster SG ingress rules when cluster_security_group_id is set.",
      "required": false
    }
  ],
  "outputs": [
    "public_gateway_security_group_id",
    "private_gateway_security_group_id"
  ],
  "hash": "d053a12e693707e717ac589f29e43bf8"
}
END_AI_METADATA -->
