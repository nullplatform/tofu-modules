# Module: vpc
This configuration uses the official terraform-google-modules/network/google module to create and manage a VPC network in GCP.

Creates a VPC with the provided network_name in the given project_id.

Provisions one or more subnets, derived from var.subnets, each with:

Name, CIDR range, region

Private Google access enabled (subnet_private_access = true), so instances without external IPs can reach Google APIs.

Configures secondary IP ranges for the subnets (e.g. for GKE pods and services) using var.secondary_ranges.

In short, it standardizes the creation of a VPC and its subnets (including secondary ranges) as a reusable networking building block for GCP.


## Usage

```hcl
module "vpc" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/vpc?ref=v1.13.0"

  project_id   = var.gcp_project_id
  network_name = var.network_name

  subnets = [
    {
      subnet_name   = "subnet-gke"
      subnet_ip     = var.subnet_cidr
      subnet_region = var.region
    }
  ]

  secondary_ranges = {
    "subnet-gke" = [
      {
        range_name    = "pods"
        ip_cidr_range = var.pods_cidr
      },
      {
        range_name    = "services"
        ip_cidr_range = var.services_cidr
      }
    ]
  }
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