# Module: nat

## Description

Creates a Google Cloud Router and Cloud NAT gateway for enabling outbound internet connectivity from private resources

## Features

- Creates a Google Cloud Router in a specified region and VPC network
- Configures Cloud NAT with automatic IP allocation for outbound connectivity
- Enables all subnetworks and IP ranges to use NAT for internet access
- Supports custom naming for both router and NAT gateway resources
- Provides outputs for router and NAT gateway names for reference

## Basic Usage

```hcl
module "nat" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/nat?ref=v1.43.0"

  location    = "your-location"
  nat_name    = "your-nat-name"
  project_id  = "your-project-id"
  router_name = "your-router-name"
  vpc_id      = "your-vpc-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.nat.router_name
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_router.router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router_nat.nat](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The GCP region where Cloud NAT will be created (e.g., us-central1, europe-west1) | `string` | n/a | yes |
| <a name="input_nat_name"></a> [nat\_name](#input\_nat\_name) | The name of the Cloud NAT | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | n/a | yes |
| <a name="input_router_name"></a> [router\_name](#input\_router\_name) | The name of the Cloud Router | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of labels to assign to the NAT resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The self-link of the virtual network | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_name"></a> [nat\_name](#output\_nat\_name) | The name of the Cloud NAT |
| <a name="output_router_name"></a> [router\_name](#output\_router\_name) | The name of the Cloud Router |
<!-- END_TF_DOCS -->
