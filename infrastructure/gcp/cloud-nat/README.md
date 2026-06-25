# Module: cloud-nat

## Description

Creates a Google Cloud Router with a Cloud NAT gateway for egress traffic from private instances in a VPC network

## Architecture

This module creates a google_compute_router resource in a specified region and network, then provisions a google_compute_router_nat resource attached to that router. The router acts as the control plane for the NAT gateway, while the NAT resource handles automatic IP allocation and configures source NAT for all subnetworks in the VPC. The nat_ip_allocate_option is set to AUTO_ONLY, allowing Google Cloud to automatically provision ephemeral external IPs, and source_subnetwork_ip_ranges_to_nat is set to ALL_SUBNETWORKS_ALL_IP_RANGES to enable NAT for all private instances across all subnets.

## Features

- Creates Cloud Router as a regional routing control plane for dynamic routing and NAT services
- Provisions Cloud NAT gateway with automatic external IP allocation for egress traffic
- Configures NAT to cover all subnetworks and IP ranges within the specified VPC network
- Outputs router and NAT gateway names for reference by dependent resources

## Basic Usage

```hcl
module "cloud-nat" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/cloud-nat?ref=v5.2.0"

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
| <a name="output_nat_name"></a> [nat\_name](#output\_nat\_name) | The name of the created Cloud NAT gateway |
| <a name="output_router_name"></a> [router\_name](#output\_router\_name) | The name of the created Cloud Router |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "cloud-nat",
  "description": "Creates a Google Cloud Router with a Cloud NAT gateway for egress traffic from private instances in a VPC network",
  "architecture": "This module creates a google_compute_router resource in a specified region and network, then provisions a google_compute_router_nat resource attached to that router. The router acts as the control plane for the NAT gateway, while the NAT resource handles automatic IP allocation and configures source NAT for all subnetworks in the VPC. The nat_ip_allocate_option is set to AUTO_ONLY, allowing Google Cloud to automatically provision ephemeral external IPs, and source_subnetwork_ip_ranges_to_nat is set to ALL_SUBNETWORKS_ALL_IP_RANGES to enable NAT for all private instances across all subnets.",
  "features": [
    "Creates Cloud Router as a regional routing control plane for dynamic routing and NAT services",
    "Provisions Cloud NAT gateway with automatic external IP allocation for egress traffic",
    "Configures NAT to cover all subnetworks and IP ranges within the specified VPC network",
    "Outputs router and NAT gateway names for reference by dependent resources"
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
  "hash": "512f5d9fa3c38d66897af79e28151867"
}
END_AI_METADATA -->
