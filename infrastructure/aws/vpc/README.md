# Module: vpc

## Description

Creates an AWS VPC with public and private subnets across multiple availability zones, configured for Kubernetes workloads with NAT gateway support

## Architecture

The module wraps the terraform-aws-modules/vpc/aws community module to provision an aws_vpc resource along with public and private aws_subnet resources distributed across the specified availability zones. A single aws_nat_gateway is created to provide outbound internet access for private subnets, while an aws_internet_gateway handles public subnet routing. Subnet tags for Kubernetes ELB roles are applied automatically, and outputs expose the vpc_id, subnet IDs, and default security group ID for consumption by downstream modules.

## Features

- Creates a VPC with configurable CIDR block named after the organization and account
- Provisions public and private subnets across multiple availability zones for high availability
- Deploys a single NAT gateway to provide cost-effective outbound internet access for private subnets
- Applies Kubernetes ELB and internal-ELB subnet tags to enable automatic load balancer subnet discovery
- Applies nullplatform subnet-type tags to distinguish public and private subnets
- Enables DNS hostnames within the VPC to support service discovery and EKS node registration

## Basic Usage

```hcl
module "vpc" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/vpc?ref=v7.2.0"

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
  "description": "Creates an AWS VPC with public and private subnets across multiple availability zones, configured for Kubernetes workloads with NAT gateway support",
  "architecture": "The module wraps the terraform-aws-modules/vpc/aws community module to provision an aws_vpc resource along with public and private aws_subnet resources distributed across the specified availability zones. A single aws_nat_gateway is created to provide outbound internet access for private subnets, while an aws_internet_gateway handles public subnet routing. Subnet tags for Kubernetes ELB roles are applied automatically, and outputs expose the vpc_id, subnet IDs, and default security group ID for consumption by downstream modules.",
  "features": [
    "Creates a VPC with configurable CIDR block named after the organization and account",
    "Provisions public and private subnets across multiple availability zones for high availability",
    "Deploys a single NAT gateway to provide cost-effective outbound internet access for private subnets",
    "Applies Kubernetes ELB and internal-ELB subnet tags to enable automatic load balancer subnet discovery",
    "Applies nullplatform subnet-type tags to distinguish public and private subnets",
    "Enables DNS hostnames within the VPC to support service discovery and EKS node registration"
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
  "hash": "fca46061782a682001b91d42d94497cd"
}
END_AI_METADATA -->
