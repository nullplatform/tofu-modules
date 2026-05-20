# Module: vpc

## Description

Configures AWS networking provider settings in Nullplatform with VPC, subnet, security group, and load balancer configurations

## Architecture

Creates a nullplatform_provider_config resource of type 'aws-networking-configuration' that stores AWS VPC networking details. The resource accepts VPC ID, subnet IDs, and security group IDs as inputs and encodes them into a JSON attributes structure. The configuration includes placeholders for public and private load balancers and uses a lifecycle rule to ignore changes to the attributes field after creation.

## Features

- Creates Nullplatform provider configuration for AWS networking
- Configures VPC networking with subnet and security group associations
- Provides load balancer configuration placeholders for public and private endpoints
- Supports custom dimension mappings for Nullplatform resource organization
- Implements lifecycle management to prevent attribute drift after initial creation

## Basic Usage

```hcl
module "vpc" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/cloud/aws/vpc?ref=v3.2.0"

  nrn                 = "your-nrn"
  vpc_id              = "your-vpc-id"
  vpc_security_groups = "your-vpc-security-groups"
  vpc_subnets         = "your-vpc-subnets"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.vpc.id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.86 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.vpc](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Map of dimension values to configure nullplatform | `map(string)` | `{}` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Identifier Nullplatform Resources Name | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC | `string` | n/a | yes |
| <a name="input_vpc_security_groups"></a> [vpc\_security\_groups](#input\_vpc\_security\_groups) | List of security group IDs associated with the VPC | `list(string)` | n/a | yes |
| <a name="input_vpc_subnets"></a> [vpc\_subnets](#input\_vpc\_subnets) | List of subnet IDs associated with the VPC | `list(string)` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "vpc",
  "description": "Configures AWS networking provider settings in Nullplatform with VPC, subnet, security group, and load balancer configurations",
  "architecture": "Creates a nullplatform_provider_config resource of type 'aws-networking-configuration' that stores AWS VPC networking details. The resource accepts VPC ID, subnet IDs, and security group IDs as inputs and encodes them into a JSON attributes structure. The configuration includes placeholders for public and private load balancers and uses a lifecycle rule to ignore changes to the attributes field after creation.",
  "features": [
    "Creates Nullplatform provider configuration for AWS networking",
    "Configures VPC networking with subnet and security group associations",
    "Provides load balancer configuration placeholders for public and private endpoints",
    "Supports custom dimension mappings for Nullplatform resource organization",
    "Implements lifecycle management to prevent attribute drift after initial creation"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "Identifier Nullplatform Resources Name",
      "required": true
    },
    {
      "name": "vpc_id",
      "description": "The ID of the VPC",
      "required": true
    },
    {
      "name": "vpc_subnets",
      "description": "List of subnet IDs associated with the VPC",
      "required": true
    },
    {
      "name": "vpc_security_groups",
      "description": "List of security group IDs associated with the VPC",
      "required": true
    },
    {
      "name": "dimensions",
      "description": "Map of dimension values to configure nullplatform",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "5ff480ac7d9e061b2bc18fcc29750aa6"
}
END_AI_METADATA -->
