# Module: vpc
This configuration uses the official terraform-google-modules/network/google module to create and manage a VPC network in GCP.

- Creates a VPC with the provided `network_name` in the given `project_id`.

- Provisions one or more subnets, derived from `var.subnets`, each with:
  
  - Name, CIDR range, region
  - Private Google access enabled (`subnet_private_access = true`), so instances without external IPs can reach Google APIs.
  - Configures secondary IP ranges for the subnets (e.g. for GKE pods and services) using `var.secondary_ranges`.

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