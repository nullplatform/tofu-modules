# Module: vpc

## Description

This module creates a VPC with public and private subnets and enables DNS hostnames

## Architecture

The module uses the terraform-aws-modules/vpc/aws module to create a VPC with the specified CIDR block, availability zones, and subnets. It enables DNS hostnames and creates a NAT gateway. The module also configures public and private subnet tags for Kubernetes. The inputs from the variables are used to configure the VPC and subnets. The module outputs the VPC ID, private subnets, and public subnets.

## Features

- Creates VPC with specified CIDR block and availability zones
- Configures public and private subnets with Kubernetes tags
- Enables DNS hostnames and creates a NAT gateway

## Basic Usage

```hcl
module "vpc" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/vpc?ref=v1.46.0"

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
| <a name="input_account"></a> [account](#input\_account) | The account name | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | The organization name | `string` | n/a | yes |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | The VPC configuration settings | <pre>object({<br/>    cidr_block      = string<br/>    azs             = list(string)<br/>    private_subnets = list(string)<br/>    public_subnets  = list(string)<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | The private subnets |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | The public subnets |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "vpc",
  "description": "This module creates a VPC with public and private subnets and enables DNS hostnames",
  "architecture": "The module uses the terraform-aws-modules/vpc/aws module to create a VPC with the specified CIDR block, availability zones, and subnets. It enables DNS hostnames and creates a NAT gateway. The module also configures public and private subnet tags for Kubernetes. The inputs from the variables are used to configure the VPC and subnets. The module outputs the VPC ID, private subnets, and public subnets.",
  "features": [
    "Creates VPC with specified CIDR block and availability zones",
    "Configures public and private subnets with Kubernetes tags",
    "Enables DNS hostnames and creates a NAT gateway"
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
    "public_subnets"
  ],
  "hash": "2eda3ededa6b4def2954f9707d6a8515"
}
END_AI_METADATA -->
