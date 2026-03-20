# Module: security

## Description

Creates GCP firewall rules for Istio gateways with health check port restrictions and HTTPS traffic management

## Features

- Creates firewall rules for Istio public gateway allowing HTTPS traffic from internet
- Restricts health check port (15021) to VPC CIDR and GCP health check ranges
- Supports optional private/internal gateway with VPC-only HTTPS access
- Derives network and CIDR configuration automatically from GKE cluster
- Implements deny rules to prevent unauthorized health check access from internet
- Configures target tags for gateway-specific traffic routing

## Basic Usage

```hcl
module "security" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/security?ref=v1.46.0"

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
