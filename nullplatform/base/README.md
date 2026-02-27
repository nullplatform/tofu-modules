# Module: base

## Description

Deploys the Nullplatform base Helm chart on Kubernetes with support for multiple cloud providers and configurable integrations

## Features

- Deploys Nullplatform base components via Helm to Kubernetes clusters
- Supports multiple cloud providers including EKS, GKE, AKS, OKE, and ARO
- Configures ingress controllers for public and private traffic management
- Integrates with multiple observability platforms including Prometheus, Loki, Dynatrace, Datadog, and New Relic
- Manages gateway resources with provider-specific security configurations
- Supports CloudWatch logging and metrics for AWS environments
- Configures TLS and custom image pull secrets for secure deployments

## Basic Usage

```hcl
module "base" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/base?ref=v1.39.0"

  k8s_provider = "your-k8s-provider"
  np_api_key   = "your-np-api-key"
  nrn          = "your-nrn"
}
```

### Usage with EKS (Amazon Elastic Kubernetes Service)

```hcl
module "base" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/base?ref=v1.39.0"

  k8s_provider = "eks"
  np_api_key   = "your-np-api-key"
  nrn          = "your-nrn"
}
```

### Usage with GKE (Google Kubernetes Engine)

```hcl
module "base" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/base?ref=v1.39.0"

  k8s_provider = "gke"
  np_api_key   = "your-np-api-key"
  nrn          = "your-nrn"
}
```

### Usage with AKS (Azure Kubernetes Service)

```hcl
module "base" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/base?ref=v1.39.0"

  k8s_provider = "aks"
  np_api_key   = "your-np-api-key"
  nrn          = "your-nrn"
}
```

### Usage with OKE (Oracle Kubernetes Engine)

```hcl
module "base" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/base?ref=v1.39.0"

  k8s_provider = "oke"
  np_api_key   = "your-np-api-key"
  nrn          = "your-nrn"
}
```

### Usage with ARO (Azure Red Hat OpenShift)

```hcl
module "base" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/base?ref=v1.39.0"

  k8s_provider = "aro"
  np_api_key   = "your-np-api-key"
  nrn          = "your-nrn"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.base.public_gateway_security_group_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.76 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [helm_release.base](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region where resources will be deployed. | `string` | `"us-east-1"` | no |
| <a name="input_cloudwatch_access_logs_enabled"></a> [cloudwatch\_access\_logs\_enabled](#input\_cloudwatch\_access\_logs\_enabled) | Enable access logs in CloudWatch. | `bool` | `false` | no |
| <a name="input_cloudwatch_custom_metrics_enabled"></a> [cloudwatch\_custom\_metrics\_enabled](#input\_cloudwatch\_custom\_metrics\_enabled) | Enable custom metrics in CloudWatch. | `bool` | `false` | no |
| <a name="input_cloudwatch_enabled"></a> [cloudwatch\_enabled](#input\_cloudwatch\_enabled) | Enable CloudWatch (global switch). | `bool` | `false` | no |
| <a name="input_cloudwatch_logs_enabled"></a> [cloudwatch\_logs\_enabled](#input\_cloudwatch\_logs\_enabled) | Enable log forwarding to CloudWatch. | `bool` | `false` | no |
| <a name="input_cloudwatch_performance_metrics_enabled"></a> [cloudwatch\_performance\_metrics\_enabled](#input\_cloudwatch\_performance\_metrics\_enabled) | Enable performance metrics in CloudWatch. | `bool` | `false` | no |
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
| <a name="input_gateway_private_aws_security_group_id"></a> [gateway\_private\_aws\_security\_group\_id](#input\_gateway\_private\_aws\_security\_group\_id) | The ID of the AWS security group for the private gateway. Output from infrastructure/aws/security module. | `string` | `""` | no |
| <a name="input_gateway_private_azure_nsg_id"></a> [gateway\_private\_azure\_nsg\_id](#input\_gateway\_private\_azure\_nsg\_id) | The ID of the Azure NSG for the private gateway. Output from infrastructure/azure/security module. | `string` | `""` | no |
| <a name="input_gateway_private_gcp_firewall_name"></a> [gateway\_private\_gcp\_firewall\_name](#input\_gateway\_private\_gcp\_firewall\_name) | The name of the GCP firewall rule for the private gateway. Output from infrastructure/gcp/security module. | `string` | `""` | no |
| <a name="input_gateway_public_aws_name"></a> [gateway\_public\_aws\_name](#input\_gateway\_public\_aws\_name) | Name of public gateway in AWS. | `string` | `"k8s-nullplatform-internet-facing"` | no |
| <a name="input_gateway_public_aws_security_group_id"></a> [gateway\_public\_aws\_security\_group\_id](#input\_gateway\_public\_aws\_security\_group\_id) | The ID of the AWS security group for the public gateway. Output from infrastructure/aws/security module. | `string` | `""` | no |
| <a name="input_gateway_public_azure_nsg_id"></a> [gateway\_public\_azure\_nsg\_id](#input\_gateway\_public\_azure\_nsg\_id) | The ID of the Azure NSG for the public gateway. Output from infrastructure/azure/security module. | `string` | `""` | no |
| <a name="input_gateway_public_gcp_firewall_name"></a> [gateway\_public\_gcp\_firewall\_name](#input\_gateway\_public\_gcp\_firewall\_name) | The name of the GCP firewall rule for the public gateway. Output from infrastructure/gcp/security module. | `string` | `""` | no |
| <a name="input_gateways_enabled"></a> [gateways\_enabled](#input\_gateways\_enabled) | Enable gateway resources (Helm chart). | `bool` | `true` | no |
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
| <a name="input_newrelic_enabled"></a> [newrelic\_enabled](#input\_newrelic\_enabled) | Enable New Relic integration. | `bool` | `false` | no |
| <a name="input_newrelic_license_key"></a> [newrelic\_license\_key](#input\_newrelic\_license\_key) | New Relic license key. | `string` | `""` | no |
| <a name="input_newrelic_region"></a> [newrelic\_region](#input\_newrelic\_region) | New Relic region (e.g., US, EU). | `string` | `""` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key for authentication (account level). | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | The Nullplatform Resource Name (NRN). | `string` | n/a | yes |
| <a name="input_nullplatform_base_helm_version"></a> [nullplatform\_base\_helm\_version](#input\_nullplatform\_base\_helm\_version) | Helm chart version for the nullplatform base. | `string` | `"2.36.0"` | no |
| <a name="input_prometheus_enabled"></a> [prometheus\_enabled](#input\_prometheus\_enabled) | Enable the Prometheus exporter. | `bool` | `true` | no |
| <a name="input_tls_required"></a> [tls\_required](#input\_tls\_required) | Whether TLS is required. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_gateway_firewall_name"></a> [private\_gateway\_firewall\_name](#output\_private\_gateway\_firewall\_name) | The name of the private gateway firewall rule (GCP) |
| <a name="output_private_gateway_nsg_id"></a> [private\_gateway\_nsg\_id](#output\_private\_gateway\_nsg\_id) | The ID of the private gateway NSG (Azure) |
| <a name="output_private_gateway_security_group_id"></a> [private\_gateway\_security\_group\_id](#output\_private\_gateway\_security\_group\_id) | The ID of the private gateway security group (AWS) |
| <a name="output_public_gateway_firewall_name"></a> [public\_gateway\_firewall\_name](#output\_public\_gateway\_firewall\_name) | The name of the public gateway firewall rule (GCP) |
| <a name="output_public_gateway_nsg_id"></a> [public\_gateway\_nsg\_id](#output\_public\_gateway\_nsg\_id) | The ID of the public gateway NSG (Azure) |
| <a name="output_public_gateway_security_group_id"></a> [public\_gateway\_security\_group\_id](#output\_public\_gateway\_security\_group\_id) | The ID of the public gateway security group (AWS) |
<!-- END_TF_DOCS -->
