# Module: Base

This module installs the **base Helm chart** from **nullplatform** and optionally creates cloud-specific network security resources (Security Groups, NSGs, Firewall Rules) to restrict gateway health check port access.

For more information, see the [our documentation](https://docs.nullplatform.com/docs/providers/helm-charts#base-chart)

## Gateway Security

When `gateway_security_enabled = true`, the module creates cloud-specific network security resources based on the `k8s_provider` value:

| `k8s_provider` | Security Resources Created |
|---|---|
| `eks` | AWS Security Groups for public/private gateways |
| `aks`, `aro` | Azure Network Security Groups (NSGs) for public/private gateways |
| `gke` | GCP Firewall Rules for public/private gateways |

The security resource IDs are automatically injected into the Helm chart values, so the gateways reference the correct security groups/NSGs/firewall rules.

### Required variables per cloud (when security is enabled)

| Cloud | Required Variables |
|---|---|
| AWS (EKS) | `cluster_name` |
| Azure (AKS/ARO) | `cluster_name`, `resource_group_name`, `azure_location` |
| GCP (GKE) | `cluster_name`, `gcp_project_id`, `gcp_region` |

> **Note:** This module requires all three cloud providers (aws, azurerm, google) to be configured, even if only one is used. For clouds not in use, configure provider stubs in the root module. See the usage examples below.

## Usage

### Basic example (without security)

```hcl
module "base" {
    source     = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/base?ref=v1.0.0"
    np_api_key = var.np_api_key
    nrn        = var.nrn
    k8s_provider = "gke"
}
```

### With gateway security enabled (Azure example)

```hcl
module "base" {
    source                   = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/base?ref=v1.0.0"
    np_api_key               = var.np_api_key
    nrn                      = var.nrn
    k8s_provider             = "aks"
    gateway_internal_enabled = true
    gateway_security_enabled = true
    cluster_name             = "my-aks-cluster"
    resource_group_name      = "my-resource-group"
    azure_location           = "eastus2"
}
```

### Provider stubs for unused clouds

```hcl
# When using Azure, stub AWS and GCP providers:
provider "aws" {
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  region                      = "us-east-1"
}

provider "google" {
  project = "unused"
  region  = "us-central1"
}
```



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.76 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_security_aws"></a> [security\_aws](#module\_security\_aws) | ./security_aws | n/a |
| <a name="module_security_azure"></a> [security\_azure](#module\_security\_azure) | ./security_azure | n/a |
| <a name="module_security_gcp"></a> [security\_gcp](#module\_security\_gcp) | ./security_gcp | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.base](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region where resources will be deployed. | `string` | `"us-east-1"` | no |
| <a name="input_azure_location"></a> [azure\_location](#input\_azure\_location) | Override: Azure region. If empty, derived automatically from cluster. | `string` | `""` | no |
| <a name="input_cloudwatch_access_logs_enabled"></a> [cloudwatch\_access\_logs\_enabled](#input\_cloudwatch\_access\_logs\_enabled) | Enable access logs in CloudWatch. | `bool` | `false` | no |
| <a name="input_cloudwatch_custom_metrics_enabled"></a> [cloudwatch\_custom\_metrics\_enabled](#input\_cloudwatch\_custom\_metrics\_enabled) | Enable custom metrics in CloudWatch. | `bool` | `false` | no |
| <a name="input_cloudwatch_enabled"></a> [cloudwatch\_enabled](#input\_cloudwatch\_enabled) | Enable CloudWatch (global switch). | `bool` | `false` | no |
| <a name="input_cloudwatch_logs_enabled"></a> [cloudwatch\_logs\_enabled](#input\_cloudwatch\_logs\_enabled) | Enable log forwarding to CloudWatch. | `bool` | `false` | no |
| <a name="input_cloudwatch_performance_metrics_enabled"></a> [cloudwatch\_performance\_metrics\_enabled](#input\_cloudwatch\_performance\_metrics\_enabled) | Enable performance metrics in CloudWatch. | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The Kubernetes cluster name (used by security modules to derive network info). | `string` | `""` | no |
| <a name="input_control_plane_enabled"></a> [control\_plane\_enabled](#input\_control\_plane\_enabled) | Enable the control plane. | `bool` | `false` | no |
| <a name="input_datadog_api_key"></a> [datadog\_api\_key](#input\_datadog\_api\_key) | Datadog API key. | `string` | `""` | no |
| <a name="input_datadog_enabled"></a> [datadog\_enabled](#input\_datadog\_enabled) | Enable Datadog integration. | `bool` | `false` | no |
| <a name="input_datadog_region"></a> [datadog\_region](#input\_datadog\_region) | Datadog region (e.g., us, eu). | `string` | `""` | no |
| <a name="input_dynatrace_api_key"></a> [dynatrace\_api\_key](#input\_dynatrace\_api\_key) | Dynatrace API key. | `string` | `""` | no |
| <a name="input_dynatrace_enabled"></a> [dynatrace\_enabled](#input\_dynatrace\_enabled) | Enable Dynatrace integration. | `bool` | `false` | no |
| <a name="input_dynatrace_environment_id"></a> [dynatrace\_environment\_id](#input\_dynatrace\_environment\_id) | Dynatrace environment ID. | `string` | `""` | no |
| <a name="input_exporter_prometheus_port"></a> [exporter\_prometheus\_port](#input\_exporter\_prometheus\_port) | Port Number to Prometheus exporter. | `string` | `"2021"` | no |
| <a name="input_gateway_api_crds_install"></a> [gateway\_api\_crds\_install](#input\_gateway\_api\_crds\_install) | Install Gateway API CRDs. | `bool` | `false` | no |
| <a name="input_gateway_api_enabled"></a> [gateway\_api\_enabled](#input\_gateway\_api\_enabled) | Enable the Gateway API. | `bool` | `false` | no |
| <a name="input_gateway_enabled"></a> [gateway\_enabled](#input\_gateway\_enabled) | Enable the HTTP gateway. | `bool` | `false` | no |
| <a name="input_gateway_internal_aws_name"></a> [gateway\_internal\_aws\_name](#input\_gateway\_internal\_aws\_name) | Name of private gateway in AWS. | `string` | `"k8s-nullplatform-internal"` | no |
| <a name="input_gateway_internal_enabled"></a> [gateway\_internal\_enabled](#input\_gateway\_internal\_enabled) | Enable the internal (private) gateway. | `bool` | `false` | no |
| <a name="input_gateway_public_aws_name"></a> [gateway\_public\_aws\_name](#input\_gateway\_public\_aws\_name) | Name of public gateway in AWS. | `string` | `"k8s-nullplatform-internet-facing"` | no |
| <a name="input_gateway_security_enabled"></a> [gateway\_security\_enabled](#input\_gateway\_security\_enabled) | Enable creation of security resources (Security Groups for AWS, NSGs for Azure, Firewall Rules for GCP) to restrict health check port access. | `bool` | `false` | no |
| <a name="input_gateways_enabled"></a> [gateways\_enabled](#input\_gateways\_enabled) | Enable gateway resources (Helm chart). | `bool` | `true` | no |
| <a name="input_gcp_network_name"></a> [gcp\_network\_name](#input\_gcp\_network\_name) | Override: GCP VPC network name for firewall rules. If empty, derived from cluster. | `string` | `""` | no |
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | GCP project ID. | `string` | `""` | no |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | GCP region where the GKE cluster is located. | `string` | `""` | no |
| <a name="input_gelf_enabled"></a> [gelf\_enabled](#input\_gelf\_enabled) | Enable GELF output. | `bool` | `false` | no |
| <a name="input_gelf_host"></a> [gelf\_host](#input\_gelf\_host) | GELF host. | `string` | `""` | no |
| <a name="input_gelf_port"></a> [gelf\_port](#input\_gelf\_port) | GELF port. | `number` | `12201` | no |
| <a name="input_image_pull_secrets_enabled"></a> [image\_pull\_secrets\_enabled](#input\_image\_pull\_secrets\_enabled) | Create and use an image pull secret. | `bool` | `false` | no |
| <a name="input_image_pull_secrets_password"></a> [image\_pull\_secrets\_password](#input\_image\_pull\_secrets\_password) | Registry password or token. | `string` | `""` | no |
| <a name="input_image_pull_secrets_registry"></a> [image\_pull\_secrets\_registry](#input\_image\_pull\_secrets\_registry) | Registry URL for the image pull secret. | `string` | `""` | no |
| <a name="input_image_pull_secrets_username"></a> [image\_pull\_secrets\_username](#input\_image\_pull\_secrets\_username) | Registry username. | `string` | `""` | no |
| <a name="input_ingressControllers"></a> [ingressControllers](#input\_ingressControllers) | Configuración de los IngressControllers públicos y privados | <pre>object({<br/>    public = object({<br/>      name    = string<br/>      enabled = bool<br/>      scope   = string<br/>      domain  = string<br/>    })<br/>    private = object({<br/>      name    = string<br/>      enabled = bool<br/>      scope   = string<br/>      domain  = string<br/>    })<br/>  })</pre> | <pre>{<br/>  "private": {<br/>    "domain": "",<br/>    "enabled": false,<br/>    "name": "internal",<br/>    "scope": "Internal"<br/>  },<br/>  "public": {<br/>    "domain": "",<br/>    "enabled": false,<br/>    "name": "internet-facing",<br/>    "scope": "External"<br/>  }<br/>}</pre> | no |
| <a name="input_install_gateway_v2_crd"></a> [install\_gateway\_v2\_crd](#input\_install\_gateway\_v2\_crd) | Install Gateway API v2 CRDs. | `bool` | `false` | no |
| <a name="input_internal_azure_load_balancer_subnet"></a> [internal\_azure\_load\_balancer\_subnet](#input\_internal\_azure\_load\_balancer\_subnet) | The name of the subnet to use in azure private load balancer | `string` | `"load_balancer"` | no |
| <a name="input_k8s_provider"></a> [k8s\_provider](#input\_k8s\_provider) | Cloud provider (eks, gke, aks, oke and aro). | `string` | n/a | yes |
| <a name="input_logging_enabled"></a> [logging\_enabled](#input\_logging\_enabled) | Enable the logging layer. | `bool` | `true` | no |
| <a name="input_loki_bearer_token"></a> [loki\_bearer\_token](#input\_loki\_bearer\_token) | Loki bearer token (if applicable). | `string` | `""` | no |
| <a name="input_loki_enabled"></a> [loki\_enabled](#input\_loki\_enabled) | Enable Loki output. | `bool` | `false` | no |
| <a name="input_loki_host"></a> [loki\_host](#input\_loki\_host) | Loki host. | `string` | `""` | no |
| <a name="input_loki_password"></a> [loki\_password](#input\_loki\_password) | Loki password (if applicable). | `string` | `""` | no |
| <a name="input_loki_port"></a> [loki\_port](#input\_loki\_port) | Loki port. | `number` | `3100` | no |
| <a name="input_loki_user"></a> [loki\_user](#input\_loki\_user) | Loki username (if applicable). | `string` | `""` | no |
| <a name="input_metrics_server_enabled"></a> [metrics\_server\_enabled](#input\_metrics\_server\_enabled) | Enable the metrics server. | `bool` | `false` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace where the agent runs. | `string` | `"nullplatform-tools"` | no |
| <a name="input_network_cidr"></a> [network\_cidr](#input\_network\_cidr) | Override: Network CIDR block for restricting health check access. If empty, derived automatically. | `string` | `""` | no |
| <a name="input_newrelic_enabled"></a> [newrelic\_enabled](#input\_newrelic\_enabled) | Enable New Relic integration. | `bool` | `false` | no |
| <a name="input_newrelic_license_key"></a> [newrelic\_license\_key](#input\_newrelic\_license\_key) | New Relic license key. | `string` | `""` | no |
| <a name="input_newrelic_region"></a> [newrelic\_region](#input\_newrelic\_region) | New Relic region (e.g., US, EU). | `string` | `""` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key for authentication (account level). | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | The Nullplatform Resource Name (NRN). | `string` | n/a | yes |
| <a name="input_nullplatform_base_helm_version"></a> [nullplatform\_base\_helm\_version](#input\_nullplatform\_base\_helm\_version) | Helm chart version for the nullplatform base. | `string` | `"2.30.1"` | no |
| <a name="input_prometheus_enabled"></a> [prometheus\_enabled](#input\_prometheus\_enabled) | Enable the Prometheus exporter. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Azure resource group name for NSG resources. | `string` | `""` | no |
| <a name="input_tls_required"></a> [tls\_required](#input\_tls\_required) | Whether TLS is required. | `bool` | `true` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Override: AWS VPC ID. If empty, derived automatically from cluster name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_gateway_firewall_rules"></a> [private\_gateway\_firewall\_rules](#output\_private\_gateway\_firewall\_rules) | The names of the private gateway firewall rules (GCP) |
| <a name="output_private_gateway_nsg_id"></a> [private\_gateway\_nsg\_id](#output\_private\_gateway\_nsg\_id) | The ID of the private gateway NSG (Azure) |
| <a name="output_private_gateway_nsg_name"></a> [private\_gateway\_nsg\_name](#output\_private\_gateway\_nsg\_name) | The name of the private gateway NSG (Azure) |
| <a name="output_private_gateway_security_group_id"></a> [private\_gateway\_security\_group\_id](#output\_private\_gateway\_security\_group\_id) | The ID of the private gateway security group (AWS) |
| <a name="output_public_gateway_firewall_rules"></a> [public\_gateway\_firewall\_rules](#output\_public\_gateway\_firewall\_rules) | The names of the public gateway firewall rules (GCP) |
| <a name="output_public_gateway_nsg_id"></a> [public\_gateway\_nsg\_id](#output\_public\_gateway\_nsg\_id) | The ID of the public gateway NSG (Azure) |
| <a name="output_public_gateway_nsg_name"></a> [public\_gateway\_nsg\_name](#output\_public\_gateway\_nsg\_name) | The name of the public gateway NSG (Azure) |
| <a name="output_public_gateway_security_group_id"></a> [public\_gateway\_security\_group\_id](#output\_public\_gateway\_security\_group\_id) | The ID of the public gateway security group (AWS) |
<!-- END_TF_DOCS -->
