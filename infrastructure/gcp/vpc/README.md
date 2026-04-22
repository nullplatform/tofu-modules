# Module: vpc

## Description

Creates a Google Cloud VPC network with configurable subnets and secondary IP ranges using the terraform-google-modules/network module

## Architecture

The module invokes the terraform-google-modules/network/google module to create VPC network resources. It transforms the input subnets list by enforcing subnet_private_access = true on all subnets before passing them to the underlying module. The module.vpc resource creates the google_compute_network and google_compute_subnetwork resources internally, with optional secondary_ranges for GKE pod and service networking. Outputs expose the network and subnet identifiers via self-links and names from the underlying module.

## Features

- Creates GCP VPC network with custom subnet configurations across multiple regions
- Enforces private Google access on all subnets automatically
- Supports secondary IP ranges for GKE pod and service CIDR blocks
- Outputs network and subnet self-links for resource referencing
- Leverages community-maintained terraform-google-modules for standardized network creation

## Basic Usage

```hcl
module "vpc" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/vpc?ref=v1.54.0"

  network_name = "your-network-name"
  project_id   = "your-project-id"
  subnets      = "your-subnets"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.vpc.network_name
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.0, < 7.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-google-modules/network/google | ~> 9.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the VPC network | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | n/a | yes |
| <a name="input_secondary_ranges"></a> [secondary\_ranges](#input\_secondary\_ranges) | Secondary ranges for GKE pods and services | `map(list(object({ range_name = string, ip_cidr_range = string })))` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnets to create | <pre>list(object({<br/>    subnet_name   = string<br/>    subnet_ip     = string<br/>    subnet_region = string<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | The name of the VPC network |
| <a name="output_network_self_link"></a> [network\_self\_link](#output\_network\_self\_link) | The self-link of the VPC network |
| <a name="output_subnets_names"></a> [subnets\_names](#output\_subnets\_names) | The names of the subnets created in the VPC |
| <a name="output_subnets_self_links"></a> [subnets\_self\_links](#output\_subnets\_self\_links) | The self-links of the subnets created in the VPC |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "vpc",
  "description": "Creates a Google Cloud VPC network with configurable subnets and secondary IP ranges using the terraform-google-modules/network module",
  "architecture": "The module invokes the terraform-google-modules/network/google module to create VPC network resources. It transforms the input subnets list by enforcing subnet_private_access = true on all subnets before passing them to the underlying module. The module.vpc resource creates the google_compute_network and google_compute_subnetwork resources internally, with optional secondary_ranges for GKE pod and service networking. Outputs expose the network and subnet identifiers via self-links and names from the underlying module.",
  "features": [
    "Creates GCP VPC network with custom subnet configurations across multiple regions",
    "Enforces private Google access on all subnets automatically",
    "Supports secondary IP ranges for GKE pod and service CIDR blocks",
    "Outputs network and subnet self-links for resource referencing",
    "Leverages community-maintained terraform-google-modules for standardized network creation"
  ],
  "inputs": [
    {
      "name": "project_id",
      "description": "The GCP project ID",
      "required": true
    },
    {
      "name": "network_name",
      "description": "The name of the VPC network",
      "required": true
    },
    {
      "name": "subnets",
      "description": "List of subnets to create",
      "required": true
    },
    {
      "name": "secondary_ranges",
      "description": "Secondary ranges for GKE pods and services",
      "required": false
    }
  ],
  "outputs": [
    "network_name",
    "network_self_link",
    "subnets_names",
    "subnets_self_links"
  ],
  "hash": "f6fdda5903c55bac3cef73815ddd4bf7"
}
END_AI_METADATA -->
