# Module: vpc

## Description

Configures AWS networking settings including VPC, subnets, and security groups for Nullplatform provider

## Features

- Creates Nullplatform provider configuration for AWS networking
- Configures VPC with specified ID, subnets, and security groups
- Supports custom dimensions for provider configuration
- Manages load balancer configuration for public and private endpoints
- Ignores changes to attributes after initial creation

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
