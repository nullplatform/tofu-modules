# Module: vnet

## Description

This module creates a virtual private network with subnets in Google Cloud Platform

## Architecture

The module uses the google network module to create a virtual private network and subnets, and outputs the network and subnet names and IDs. The module also supports secondary IP ranges for GKE pods and services, and allows for custom tags to be applied to the virtual network resources. The subnets are created with private access enabled. The module uses a for loop to iterate over the subnets definition and create each subnet with the specified name, IP address prefix, and location.

## Features

- Creates virtual private network with subnets
- Configures subnets with private access
- Supports secondary IP ranges for GKE pods and services
- Applies custom tags to virtual network resources

## Basic Usage

```hcl
module "vnet" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/vnet?ref=v1.48.1"

  project_id         = "your-project-id"
  subnets_definition = "your-subnets-definition"
  vpc_name           = "your-vpc-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.vnet.vnet_name
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-google-modules/network/google | ~> 9.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | n/a | yes |
| <a name="input_secondary_ranges"></a> [secondary\_ranges](#input\_secondary\_ranges) | Secondary IP ranges for GKE pods and services | `map(list(object({ range_name = string, ip_cidr_range = string })))` | `{}` | no |
| <a name="input_subnets_definition"></a> [subnets\_definition](#input\_subnets\_definition) | List of subnets to create within the virtual network | <pre>list(object({<br/>    name           = string<br/>    address_prefix = string<br/>    location       = string<br/>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of labels to assign to the virtual network resources | `map(string)` | `{}` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the virtual private network | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | The self-links of the subnets created in the virtual network |
| <a name="output_subnet_names"></a> [subnet\_names](#output\_subnet\_names) | The names of the subnets created in the virtual network |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | The self-link of the virtual network |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | The name of the virtual network |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "vnet",
  "description": "This module creates a virtual private network with subnets in Google Cloud Platform",
  "architecture": "The module uses the google network module to create a virtual private network and subnets, and outputs the network and subnet names and IDs. The module also supports secondary IP ranges for GKE pods and services, and allows for custom tags to be applied to the virtual network resources. The subnets are created with private access enabled. The module uses a for loop to iterate over the subnets definition and create each subnet with the specified name, IP address prefix, and location.",
  "features": [
    "Creates virtual private network with subnets",
    "Configures subnets with private access",
    "Supports secondary IP ranges for GKE pods and services",
    "Applies custom tags to virtual network resources"
  ],
  "inputs": [
    {
      "name": "project_id",
      "description": "The GCP project ID",
      "required": true
    },
    {
      "name": "vpc_name",
      "description": "The name of the virtual private network",
      "required": true
    },
    {
      "name": "subnets_definition",
      "description": "List of subnets to create within the virtual network",
      "required": true
    },
    {
      "name": "secondary_ranges",
      "description": "Secondary IP ranges for GKE pods and services",
      "required": false
    },
    {
      "name": "tags",
      "description": "A mapping of labels to assign to the virtual network resources",
      "required": false
    }
  ],
  "outputs": [
    "vnet_name",
    "vnet_id",
    "subnet_names",
    "subnet_ids"
  ],
  "hash": "f4f14441c333548fd4f5e66e0f7d833b"
}
END_AI_METADATA -->
