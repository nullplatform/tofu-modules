# Module: cloud-nat

This module provisions a Google Cloud NAT configuration using OpenTofu.
It is designed to be a reusable building block to provide egress internet access for private resources (such as GCE instances or GKE nodes without external IPs) in your VPC.


## Usage

```hcl
module "cloud_nat" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/cloud-nat?ref=v1.13.0"

  project_id  = var.gcp_project_id
  region      = var.region
  network_id  = module.vpc.network_self_link
  router_name = var.router
  nat_name    = var.nat_name

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