# Module: vpc

## Description

Creates an AWS VPC with public and private subnets across multiple availability zones, configured for Kubernetes workloads with NAT gateway for private subnet internet access

## Architecture

This module creates a terraform-aws-modules/vpc/aws module resource with DNS hostnames enabled. It provisions public subnets tagged for external load balancers and private subnets tagged for internal load balancers, both tagged for Kubernetes integration. A single NAT gateway is created in a public subnet to enable outbound internet access for resources in private subnets. The VPC name is derived from organization and account variables, and outputs include the VPC ID, subnet IDs, and default security group ID.

## Features

- Creates VPC with configurable CIDR block and availability zones
- Provisions public subnets with Kubernetes external load balancer tags
- Provisions private subnets with Kubernetes internal load balancer tags
- Configures single NAT gateway for private subnet internet egress
- Enables DNS hostnames for VPC resources
- Tags subnets with nullplatform identifiers for infrastructure management
- Outputs VPC ID, subnet IDs, and default security group for downstream resource integration

## Basic Usage

```hcl
module "vpc" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/vpc?ref=v1.50.0"

  account      = "your-account"
  organization = "your-organization"
  vpc          = "your-vpc"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.vpc.vpc_id
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
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 6.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | The nullplatform account name | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | The nullplatform organization name | `string` | n/a | yes |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | The VPC configuration settings | <pre>object({<br/>    cidr_block      = string<br/>    azs             = list(string)<br/>    private_subnets = list(string)<br/>    public_subnets  = list(string)<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | The private subnets |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | The public subnets |
| <a name="output_security_group_ids"></a> [security\_group\_ids](#output\_security\_group\_ids) | The security group IDs associated with the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "vpc",
  "description": "Creates an AWS VPC with public and private subnets across multiple availability zones, configured for Kubernetes workloads with NAT gateway for private subnet internet access",
  "architecture": "This module creates a terraform-aws-modules/vpc/aws module resource with DNS hostnames enabled. It provisions public subnets tagged for external load balancers and private subnets tagged for internal load balancers, both tagged for Kubernetes integration. A single NAT gateway is created in a public subnet to enable outbound internet access for resources in private subnets. The VPC name is derived from organization and account variables, and outputs include the VPC ID, subnet IDs, and default security group ID.",
  "features": [
    "Creates VPC with configurable CIDR block and availability zones",
    "Provisions public subnets with Kubernetes external load balancer tags",
    "Provisions private subnets with Kubernetes internal load balancer tags",
    "Configures single NAT gateway for private subnet internet egress",
    "Enables DNS hostnames for VPC resources",
    "Tags subnets with nullplatform identifiers for infrastructure management",
    "Outputs VPC ID, subnet IDs, and default security group for downstream resource integration"
  ],
  "inputs": [
    {
      "name": "vpc",
      "description": "The VPC configuration settings",
      "required": true
    },
    {
      "name": "organization",
      "description": "The nullplatform organization name",
      "required": true
    },
    {
      "name": "account",
      "description": "The nullplatform account name",
      "required": true
    }
  ],
  "outputs": [
    "vpc_id",
    "private_subnets",
    "public_subnets",
    "security_group_ids"
  ],
  "hash": "c0c6e91682b6bb694696874d8f69aed6"
}
END_AI_METADATA -->
