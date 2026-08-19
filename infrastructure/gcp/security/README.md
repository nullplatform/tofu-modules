# Module: security

## Description

Configures GCP firewall rules for Istio gateways in a GKE cluster

## Architecture

This module uses Terraform to create GCP firewall rules for public and private Istio gateways in a GKE cluster. It utilizes the google_compute_firewall resource to define ingress rules for HTTPS and health check traffic. The module also derives the network and CIDR block from the GKE cluster information using data sources like google_container_cluster and google_compute_subnetwork. The firewall rules are then created based on the derived network and CIDR block, with specific rules for public and private gateways. The module also outputs the names of the created firewall rules for public and private gateways.

## Features

- Creates GCP firewall rules for public and private Istio gateways
- Configures ingress rules for HTTPS and health check traffic
- Derives network and CIDR block from GKE cluster information
- Outputs firewall rule names for public and private gateways

## Basic Usage

```hcl
module "security" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/security?ref=v7.1.0"

  cluster_name   = "your-cluster-name"
  gcp_project_id = "your-gcp-project-id"
  gcp_region     = "your-gcp-region"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.security.public_gateway_firewall_name
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.private_gateway_health_check](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.private_gateway_https](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.public_gateway_deny_health_check](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.public_gateway_health_check](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.public_gateway_https](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The GKE cluster name, used for naming firewall rules and deriving network. | `string` | n/a | yes |
| <a name="input_gateway_internal_enabled"></a> [gateway\_internal\_enabled](#input\_gateway\_internal\_enabled) | Whether the internal (private) gateway is enabled. | `bool` | `false` | no |
| <a name="input_gateways_enabled"></a> [gateways\_enabled](#input\_gateways\_enabled) | Whether public gateways are enabled. | `bool` | `true` | no |
| <a name="input_gcp_network_name"></a> [gcp\_network\_name](#input\_gcp\_network\_name) | Override: The VPC network name. If empty, derived from cluster. | `string` | `""` | no |
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | The GCP project ID. | `string` | n/a | yes |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | The GCP region where the GKE cluster is located. | `string` | n/a | yes |
| <a name="input_network_cidr"></a> [network\_cidr](#input\_network\_cidr) | Override: The network CIDR block. If empty, derived from subnet. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_gateway_firewall_name"></a> [private\_gateway\_firewall\_name](#output\_private\_gateway\_firewall\_name) | The name of the private gateway HTTPS firewall rule. |
| <a name="output_public_gateway_firewall_name"></a> [public\_gateway\_firewall\_name](#output\_public\_gateway\_firewall\_name) | The name of the public gateway HTTPS firewall rule. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "security",
  "description": "Configures GCP firewall rules for Istio gateways in a GKE cluster",
  "architecture": "This module uses Terraform to create GCP firewall rules for public and private Istio gateways in a GKE cluster. It utilizes the google_compute_firewall resource to define ingress rules for HTTPS and health check traffic. The module also derives the network and CIDR block from the GKE cluster information using data sources like google_container_cluster and google_compute_subnetwork. The firewall rules are then created based on the derived network and CIDR block, with specific rules for public and private gateways. The module also outputs the names of the created firewall rules for public and private gateways.",
  "features": [
    "Creates GCP firewall rules for public and private Istio gateways",
    "Configures ingress rules for HTTPS and health check traffic",
    "Derives network and CIDR block from GKE cluster information",
    "Outputs firewall rule names for public and private gateways"
  ],
  "inputs": [
    {
      "name": "cluster_name",
      "description": "The GKE cluster name, used for naming firewall rules and deriving network.",
      "required": true
    },
    {
      "name": "gcp_project_id",
      "description": "The GCP project ID.",
      "required": true
    },
    {
      "name": "gcp_region",
      "description": "The GCP region where the GKE cluster is located.",
      "required": true
    },
    {
      "name": "gateways_enabled",
      "description": "Whether public gateways are enabled.",
      "required": false
    },
    {
      "name": "gateway_internal_enabled",
      "description": "Whether the internal (private) gateway is enabled.",
      "required": false
    },
    {
      "name": "gcp_network_name",
      "description": "Override: The VPC network name. If empty, derived from cluster.",
      "required": false
    },
    {
      "name": "network_cidr",
      "description": "Override: The network CIDR block. If empty, derived from subnet.",
      "required": false
    }
  ],
  "outputs": [
    "public_gateway_firewall_name",
    "private_gateway_firewall_name"
  ],
  "hash": "d5bafc8ca7f3fae8b7757228f1d8b9d2"
}
END_AI_METADATA -->
