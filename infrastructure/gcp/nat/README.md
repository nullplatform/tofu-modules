# Module: nat

## Description

Creates a Cloud Router and Cloud NAT in Google Cloud Platform

## Architecture

This module creates a google_compute_router resource and a google_compute_router_nat resource, connecting them internally by setting the router attribute of the nat resource to the name of the router resource. The inputs for project_id, location, vpc_id, router_name, and nat_name are used to configure these resources. The module also outputs the names of the created router and nat resources.

## Features

- Creates Cloud Router with specified name and region
- Configures Cloud NAT with auto-allocated IP addresses
- Supports all subnetworks and IP ranges for NAT

## Basic Usage

```hcl
module "nat" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/nat?ref=v1.48.3"

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

<!-- BEGIN_AI_METADATA
{
  "name": "nat",
  "description": "Creates a Cloud Router and Cloud NAT in Google Cloud Platform",
  "architecture": "This module creates a google_compute_router resource and a google_compute_router_nat resource, connecting them internally by setting the router attribute of the nat resource to the name of the router resource. The inputs for project_id, location, vpc_id, router_name, and nat_name are used to configure these resources. The module also outputs the names of the created router and nat resources.",
  "features": [
    "Creates Cloud Router with specified name and region",
    "Configures Cloud NAT with auto-allocated IP addresses",
    "Supports all subnetworks and IP ranges for NAT"
  ],
  "inputs": [
    {
      "name": "project_id",
      "description": "The GCP project ID",
      "required": true
    },
    {
      "name": "location",
      "description": "The GCP region where Cloud NAT will be created (e.g., us-central1, europe-west1)",
      "required": true
    },
    {
      "name": "vpc_id",
      "description": "The self-link of the virtual network",
      "required": true
    },
    {
      "name": "router_name",
      "description": "The name of the Cloud Router",
      "required": true
    },
    {
      "name": "nat_name",
      "description": "The name of the Cloud NAT",
      "required": true
    },
    {
      "name": "tags",
      "description": "A mapping of labels to assign to the NAT resources",
      "required": false
    }
  ],
  "outputs": [
    "router_name",
    "nat_name"
  ],
  "hash": "0af2ba4aec45e4861c95264eb2ab48af"
}
END_AI_METADATA -->
