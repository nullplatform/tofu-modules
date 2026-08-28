# Module: vpc

## Description

Registers AWS VPC networking configuration (subnets, security groups, and load balancer details) as a nullplatform provider config resource

## Architecture

The module creates a single nullplatform_provider_config resource of type aws-networking-configuration, wiring the vpc_id, vpc_subnets, and vpc_security_groups inputs into a nested vpc attribute block alongside public and private load_balancer objects. The nrn input identifies the Nullplatform resource hierarchy scope, and optional dimensions enable multi-tenant or environment-scoped configuration. A lifecycle ignore_changes block on attributes prevents drift detection from overwriting externally managed state.

## Features

- Creates a nullplatform provider config resource of type aws-networking-configuration scoped to a given NRN
- Registers VPC ID, subnet list, and security group list as structured networking attributes
- Publishes public and private load balancer details under the networking provider for downstream workflow resolution
- Supports optional dimension mapping for multi-tenant or environment-scoped Nullplatform configurations
- Prevents Terraform drift on attributes block via lifecycle ignore_changes to preserve externally managed state

## Basic Usage

```hcl
module "vpc" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/cloud/aws/vpc?ref=v6.20.0"

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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.95 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.vpc](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Map of dimension values to configure nullplatform | `map(string)` | `{}` | no |
| <a name="input_load_balancer"></a> [load\_balancer](#input\_load\_balancer) | Load balancer wiring published under the networking provider's load\_balancer.{public,private} so scope workflows (e.g. the Lambda ALB) can resolve listener/target details. Each side is free-form (e.g. { arn = ..., listener\_arn = ... }); defaults to empty objects, preserving the previous behaviour. | <pre>object({<br/>    public  = optional(any, {})<br/>    private = optional(any, {})<br/>  })</pre> | `{}` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Identifier Nullplatform Resources Name | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC | `string` | n/a | yes |
| <a name="input_vpc_security_groups"></a> [vpc\_security\_groups](#input\_vpc\_security\_groups) | List of security group IDs associated with the VPC | `list(string)` | n/a | yes |
| <a name="input_vpc_subnets"></a> [vpc\_subnets](#input\_vpc\_subnets) | List of subnet IDs associated with the VPC | `list(string)` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "vpc",
  "description": "Registers AWS VPC networking configuration (subnets, security groups, and load balancer details) as a nullplatform provider config resource",
  "architecture": "The module creates a single nullplatform_provider_config resource of type aws-networking-configuration, wiring the vpc_id, vpc_subnets, and vpc_security_groups inputs into a nested vpc attribute block alongside public and private load_balancer objects. The nrn input identifies the Nullplatform resource hierarchy scope, and optional dimensions enable multi-tenant or environment-scoped configuration. A lifecycle ignore_changes block on attributes prevents drift detection from overwriting externally managed state.",
  "features": [
    "Creates a nullplatform provider config resource of type aws-networking-configuration scoped to a given NRN",
    "Registers VPC ID, subnet list, and security group list as structured networking attributes",
    "Publishes public and private load balancer details under the networking provider for downstream workflow resolution",
    "Supports optional dimension mapping for multi-tenant or environment-scoped Nullplatform configurations",
    "Prevents Terraform drift on attributes block via lifecycle ignore_changes to preserve externally managed state"
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
    },
    {
      "name": "load_balancer",
      "description": "Load balancer wiring published under the networking provider's load_balancer.{public,private} so scope workflows (e.g. the Lambda ALB) can resolve listener/target details. Each side is free-form (e.g. { arn = ..., listener_arn = ... }); defaults to empty objects, preserving the previous behaviour.",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "396315238cd4cd3bde47416f7cfafa11"
}
END_AI_METADATA -->
