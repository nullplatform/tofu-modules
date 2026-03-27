# Module: cloud-nat

## Description

This module creates a Google Cloud Router and a Cloud NAT in a specified GCP project and region

## Architecture

The module uses the google_compute_router and google_compute_router_nat Terraform resource types to create a Cloud Router and a Cloud NAT, respectively. The Cloud Router is created with the specified name, project, region, and network, and the Cloud NAT is created with the specified name, project, region, and router. The module outputs the names of the created Cloud Router and Cloud NAT. The inputs to the module, such as project ID, region, network ID, router name, and NAT name, are used to configure the created resources.

## Features

- Creates Cloud Router with specified name and network
- Configures Cloud NAT with specified name and router
- Supports automatic IP allocation for Cloud NAT

## Basic Usage

```hcl
module "cloud-nat" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/cloud-nat?ref=v1.48.1"

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

<!-- BEGIN_AI_METADATA
{
  "name": "cloud-nat",
  "description": "This module creates a Google Cloud Router and a Cloud NAT in a specified GCP project and region",
  "architecture": "The module uses the google_compute_router and google_compute_router_nat Terraform resource types to create a Cloud Router and a Cloud NAT, respectively. The Cloud Router is created with the specified name, project, region, and network, and the Cloud NAT is created with the specified name, project, region, and router. The module outputs the names of the created Cloud Router and Cloud NAT. The inputs to the module, such as project ID, region, network ID, router name, and NAT name, are used to configure the created resources.",
  "features": [
    "Creates Cloud Router with specified name and network",
    "Configures Cloud NAT with specified name and router",
    "Supports automatic IP allocation for Cloud NAT"
  ],
  "inputs": [
    {
      "name": "project_id",
      "description": "The GCP project ID",
      "required": true
    },
    {
      "name": "region",
      "description": "The region for Cloud NAT",
      "required": true
    },
    {
      "name": "network_id",
      "description": "The self-link of the VPC network",
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
    }
  ],
  "outputs": [
    "router_name",
    "nat_name"
  ],
  "hash": "7d89a9d1483cd139ea9ac7ac1d2389f6"
}
END_AI_METADATA -->
