# Module: vpc

## Description

Configures AWS networking resources in Nullplatform by creating a provider configuration that registers VPC, subnets, security groups, and load balancer settings

## Architecture

The module creates a single nullplatform_provider_config resource of type 'aws-networking-configuration'. This resource takes the VPC ID, subnet IDs, and security group IDs as inputs and encodes them into a JSON attributes structure along with empty public and private load balancer configurations. The NRN and dimensions are passed directly to the provider config, while the lifecycle ignore_changes block prevents drift on the attributes field.

## Features

- Registers VPC networking configuration with Nullplatform provider
- Associates subnets and security groups to the VPC configuration
- Defines empty public and private load balancer placeholders
- Uses JSON encoding to structure VPC and load balancer attributes

## Basic Usage

```hcl
module "vpc" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/cloud/aws/vpc?ref=v1.48.3"

  np_api_key          = "your-np-api-key"
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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | ~> 0.0.63 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.vpc](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Map of dimension values to configure nullplatform | `map(string)` | `{}` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key for authentication | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Identifier Nullplatform Resources Name | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC | `string` | n/a | yes |
| <a name="input_vpc_security_groups"></a> [vpc\_security\_groups](#input\_vpc\_security\_groups) | List of security group IDs associated with the VPC | `list(string)` | n/a | yes |
| <a name="input_vpc_subnets"></a> [vpc\_subnets](#input\_vpc\_subnets) | List of subnet IDs associated with the VPC | `list(string)` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "vpc",
  "description": "Configures AWS networking resources in Nullplatform by creating a provider configuration that registers VPC, subnets, security groups, and load balancer settings",
  "architecture": "The module creates a single nullplatform_provider_config resource of type 'aws-networking-configuration'. This resource takes the VPC ID, subnet IDs, and security group IDs as inputs and encodes them into a JSON attributes structure along with empty public and private load balancer configurations. The NRN and dimensions are passed directly to the provider config, while the lifecycle ignore_changes block prevents drift on the attributes field.",
  "features": [
    "Registers VPC networking configuration with Nullplatform provider",
    "Associates subnets and security groups to the VPC configuration",
    "Defines empty public and private load balancer placeholders",
    "Uses JSON encoding to structure VPC and load balancer attributes"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "Identifier Nullplatform Resources Name",
      "required": true
    },
    {
      "name": "np_api_key",
      "description": "Nullplatform API key for authentication",
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
  "hash": "3e089bced3e3acc6ec76c24507a0f9ed"
}
END_AI_METADATA -->
