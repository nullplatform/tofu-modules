# Module: cloud-nat

## Description

Creates a Google Cloud Router and Cloud NAT for outbound internet connectivity from private GCP resources

## Features

- Creates a Cloud Router in a specified VPC network and region
- Provisions a Cloud NAT gateway with automatic IP allocation
- Configures NAT for all subnetworks and IP ranges
- Enables outbound internet connectivity for instances without external IPs
- Outputs router and NAT resource names for reference

## Basic Usage

```hcl
module "cloud-nat" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/cloud-nat?ref=v1.38.3"

  nat_name    = "your-nat-name"
  network_id  = "your-network-id"
  project_id  = "your-project-id"
  region      = "your-region"
  router_name = "your-router-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.cloud-nat.router_name
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 5.0, < 7.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_router.router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router_nat.nat](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_nat_name"></a> [nat\_name](#input\_nat\_name) | The name of the Cloud NAT | `string` | n/a | yes |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | The self-link of the VPC network | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region for Cloud NAT | `string` | n/a | yes |
| <a name="input_router_name"></a> [router\_name](#input\_router\_name) | The name of the Cloud Router | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_name"></a> [nat\_name](#output\_nat\_name) | n/a |
| <a name="output_router_name"></a> [router\_name](#output\_router\_name) | n/a |
<!-- END_TF_DOCS -->
