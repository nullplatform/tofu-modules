# Module: security

## Description

Creates GCP firewall rules for Istio public and private gateways on GKE, restricting health check port 15021 to VPC CIDR and GCP health checker ranges while allowing HTTPS on port 443

## Architecture

The module uses data.google_container_cluster to derive the VPC network name and data.google_compute_subnetwork to derive the subnet CIDR, both skipped when override variables are supplied. These derived or overridden values flow into google_compute_firewall resources for public and private gateways, each controlled by boolean flags. For the public gateway, three google_compute_firewall rules are created: one allowing 443 from 0.0.0.0/0, one allowing 15021 from VPC CIDR plus GCP health check ranges, and a lower-priority deny rule blocking 15021 from the internet. For the private gateway, two google_compute_firewall rules restrict both 443 and 15021 to VPC CIDR plus GCP health check ranges, with all rules targeting nodes via cluster-name-prefixed network tags.

## Features

- Creates google_compute_firewall rules for Istio public gateway allowing HTTPS (443) from the internet
- Creates google_compute_firewall deny rule blocking health check port 15021 from the internet at lower priority
- Creates google_compute_firewall rules for Istio private gateway restricting HTTPS to VPC CIDR only
- Allows GCP load balancer health check ranges (35.191.0.0/16, 130.211.0.0/22) access to port 15021 for both gateways
- Derives VPC network name and subnet CIDR automatically from data.google_container_cluster and data.google_compute_subnetwork when not supplied
- Skips data source lookups entirely when both gcp_network_name and network_cidr overrides are provided, avoiding the need for container.clusters.get or compute.subnetworks.get permissions
- Targets firewall rules to specific GKE nodes using cluster-name-prefixed network tags for public and private gateways

## Basic Usage

```hcl
module "security" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/security?ref=v7.2.0"

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
| <a name="provider_google"></a> [google](#provider\_google) | 5.45.2 |

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
| <a name="input_gcp_network_name"></a> [gcp\_network\_name](#input\_gcp\_network\_name) | Override: The VPC network name. If empty, derived from the cluster. Supplying this together with network\_cidr skips the cluster and subnetwork lookups entirely, so the caller does not need container.clusters.get or compute.subnetworks.get. Accepts a bare name or a full projects/P/global/networks/N path — google\_compute\_firewall normalizes either | `string` | `""` | no |
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | The GCP project ID. | `string` | n/a | yes |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | The GCP region where the GKE cluster is located. | `string` | n/a | yes |
| <a name="input_network_cidr"></a> [network\_cidr](#input\_network\_cidr) | Override: The network CIDR block. If empty, derived from the cluster's subnetwork. Supplying it skips the subnetwork lookup. Needed when the derived path cannot be resolved by the caller's credentials, e.g. a Shared VPC subnet in a host project the module cannot read | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_gateway_firewall_name"></a> [private\_gateway\_firewall\_name](#output\_private\_gateway\_firewall\_name) | The name of the private gateway HTTPS firewall rule. |
| <a name="output_public_gateway_firewall_name"></a> [public\_gateway\_firewall\_name](#output\_public\_gateway\_firewall\_name) | The name of the public gateway HTTPS firewall rule. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "security",
  "description": "Creates GCP firewall rules for Istio public and private gateways on GKE, restricting health check port 15021 to VPC CIDR and GCP health checker ranges while allowing HTTPS on port 443",
  "architecture": "The module uses data.google_container_cluster to derive the VPC network name and data.google_compute_subnetwork to derive the subnet CIDR, both skipped when override variables are supplied. These derived or overridden values flow into google_compute_firewall resources for public and private gateways, each controlled by boolean flags. For the public gateway, three google_compute_firewall rules are created: one allowing 443 from 0.0.0.0/0, one allowing 15021 from VPC CIDR plus GCP health check ranges, and a lower-priority deny rule blocking 15021 from the internet. For the private gateway, two google_compute_firewall rules restrict both 443 and 15021 to VPC CIDR plus GCP health check ranges, with all rules targeting nodes via cluster-name-prefixed network tags.",
  "features": [
    "Creates google_compute_firewall rules for Istio public gateway allowing HTTPS (443) from the internet",
    "Creates google_compute_firewall deny rule blocking health check port 15021 from the internet at lower priority",
    "Creates google_compute_firewall rules for Istio private gateway restricting HTTPS to VPC CIDR only",
    "Allows GCP load balancer health check ranges (35.191.0.0/16, 130.211.0.0/22) access to port 15021 for both gateways",
    "Derives VPC network name and subnet CIDR automatically from data.google_container_cluster and data.google_compute_subnetwork when not supplied",
    "Skips data source lookups entirely when both gcp_network_name and network_cidr overrides are provided, avoiding the need for container.clusters.get or compute.subnetworks.get permissions",
    "Targets firewall rules to specific GKE nodes using cluster-name-prefixed network tags for public and private gateways"
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
      "description": "Override: The VPC network name. If empty, derived from the cluster. Supplying this together with network_cidr skips the cluster and subnetwork lookups entirely, so the caller does not need container.clusters.get or compute.subnetworks.get. Accepts a bare name or a full projects/P/global/networks/N path — google_compute_firewall normalizes either",
      "required": false
    },
    {
      "name": "network_cidr",
      "description": "Override: The network CIDR block. If empty, derived from the cluster's subnetwork. Supplying it skips the subnetwork lookup. Needed when the derived path cannot be resolved by the caller's credentials, e.g. a Shared VPC subnet in a host project the module cannot read",
      "required": false
    }
  ],
  "outputs": [
    "public_gateway_firewall_name",
    "private_gateway_firewall_name"
  ],
  "hash": "0d2c798a14b25be0ff52508cc3499433"
}
END_AI_METADATA -->
