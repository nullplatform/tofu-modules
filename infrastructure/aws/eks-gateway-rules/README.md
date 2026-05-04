# Module: eks-gateway-rules

## Description

Creates security group ingress rules on an EKS cluster primary security group to allow traffic from Istio gateway security groups (public and/or private)

## Architecture

Creates aws_vpc_security_group_ingress_rule resources that attach to an existing EKS cluster security group. For each enabled gateway (public/private), the module creates two ingress rules: one allowing application traffic on a configurable port from the gateway security group, and one allowing health check traffic on port 15021. The rules reference external security group IDs via referenced_security_group_id, establishing trust between the gateway security groups and the cluster security group. Outputs expose the security group rule IDs for dependency tracking.

## Features

- Creates ingress rules allowing public ALB traffic to EKS cluster on configurable gateway port
- Creates ingress rules allowing private ALB traffic to EKS cluster on configurable gateway port
- Configures health check ingress on port 15021 for Istio gateway liveness probes
- Supports conditional creation of public gateway rules via gateways_enabled flag
- Supports conditional creation of private gateway rules via gateway_internal_enabled flag
- Tags all security group rules with descriptive names for identification

## Basic Usage

```hcl
module "eks-gateway-rules" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/eks-gateway-rules?ref=v2.0.0"

  cluster_security_group_id = "your-cluster-security-group-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.eks-gateway-rules.public_traffic_rule_id
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
| [aws_vpc_security_group_ingress_rule.cluster_from_private_gateway_health](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.cluster_from_private_gateway_traffic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.cluster_from_public_gateway_health](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.cluster_from_public_gateway_traffic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_security_group_id"></a> [cluster\_security\_group\_id](#input\_cluster\_security\_group\_id) | The EKS cluster primary security group ID. Ingress rules allowing traffic from the gateway SGs are created on this SG. | `string` | n/a | yes |
| <a name="input_gateway_internal_enabled"></a> [gateway\_internal\_enabled](#input\_gateway\_internal\_enabled) | Whether to create ingress rules for the private gateway. | `bool` | `false` | no |
| <a name="input_gateway_port"></a> [gateway\_port](#input\_gateway\_port) | Port used by Istio gateway pods for application traffic (e.g. 80, 8080, 8443). | `number` | `80` | no |
| <a name="input_gateways_enabled"></a> [gateways\_enabled](#input\_gateways\_enabled) | Whether to create ingress rules for the public gateway. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name prefix for resource tags. | `string` | `""` | no |
| <a name="input_private_gateway_security_group_id"></a> [private\_gateway\_security\_group\_id](#input\_private\_gateway\_security\_group\_id) | Security group ID of the private Istio gateway (from the security module). | `string` | `""` | no |
| <a name="input_public_gateway_security_group_id"></a> [public\_gateway\_security\_group\_id](#input\_public\_gateway\_security\_group\_id) | Security group ID of the public Istio gateway (from the security module). | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_traffic_rule_id"></a> [private\_traffic\_rule\_id](#output\_private\_traffic\_rule\_id) | ID of the ingress rule allowing private gateway traffic to the cluster SG. |
| <a name="output_public_traffic_rule_id"></a> [public\_traffic\_rule\_id](#output\_public\_traffic\_rule\_id) | ID of the ingress rule allowing public gateway traffic to the cluster SG. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "eks-gateway-rules",
  "description": "Creates security group ingress rules on an EKS cluster primary security group to allow traffic from Istio gateway security groups (public and/or private)",
  "architecture": "Creates aws_vpc_security_group_ingress_rule resources that attach to an existing EKS cluster security group. For each enabled gateway (public/private), the module creates two ingress rules: one allowing application traffic on a configurable port from the gateway security group, and one allowing health check traffic on port 15021. The rules reference external security group IDs via referenced_security_group_id, establishing trust between the gateway security groups and the cluster security group. Outputs expose the security group rule IDs for dependency tracking.",
  "features": [
    "Creates ingress rules allowing public ALB traffic to EKS cluster on configurable gateway port",
    "Creates ingress rules allowing private ALB traffic to EKS cluster on configurable gateway port",
    "Configures health check ingress on port 15021 for Istio gateway liveness probes",
    "Supports conditional creation of public gateway rules via gateways_enabled flag",
    "Supports conditional creation of private gateway rules via gateway_internal_enabled flag",
    "Tags all security group rules with descriptive names for identification"
  ],
  "inputs": [
    {
      "name": "cluster_security_group_id",
      "description": "The EKS cluster primary security group ID. Ingress rules allowing traffic from the gateway SGs are created on this SG.",
      "required": true
    },
    {
      "name": "name",
      "description": "Name prefix for resource tags.",
      "required": false
    },
    {
      "name": "public_gateway_security_group_id",
      "description": "Security group ID of the public Istio gateway (from the security module).",
      "required": false
    },
    {
      "name": "private_gateway_security_group_id",
      "description": "Security group ID of the private Istio gateway (from the security module).",
      "required": false
    },
    {
      "name": "gateways_enabled",
      "description": "Whether to create ingress rules for the public gateway.",
      "required": false
    },
    {
      "name": "gateway_internal_enabled",
      "description": "Whether to create ingress rules for the private gateway.",
      "required": false
    },
    {
      "name": "gateway_port",
      "description": "Port used by Istio gateway pods for application traffic (e.g. 80, 8080, 8443).",
      "required": false
    }
  ],
  "outputs": [
    "public_traffic_rule_id",
    "private_traffic_rule_id"
  ],
  "hash": "f6fba62cbc722ceb543d1cbcd2f09b4c"
}
END_AI_METADATA -->
