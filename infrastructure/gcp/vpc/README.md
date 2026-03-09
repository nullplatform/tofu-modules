# Module: vpc

## Description

Creates a GCP VPC network with configurable subnets and secondary IP ranges for GKE workloads

## Features

- Creates a VPC network in Google Cloud Platform using the official terraform-google-modules/network module
- Configures multiple subnets with customizable IP ranges and regions
- Enables private Google access on all subnets by default
- Supports secondary IP ranges for GKE pod and service networking
- Outputs network and subnet identifiers for use in other modules

## Basic Usage

```hcl
module "vpc" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/vpc?ref=v1.43.0"

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
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | n/a |
| <a name="output_network_self_link"></a> [network\_self\_link](#output\_network\_self\_link) | n/a |
| <a name="output_subnets_names"></a> [subnets\_names](#output\_subnets\_names) | n/a |
| <a name="output_subnets_self_links"></a> [subnets\_self\_links](#output\_subnets\_self\_links) | n/a |
<!-- END_TF_DOCS -->
