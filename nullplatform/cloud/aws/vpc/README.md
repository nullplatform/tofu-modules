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
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/cloud/aws/vpc?ref=v1.46.0"

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
