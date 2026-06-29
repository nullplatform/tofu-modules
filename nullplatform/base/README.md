# Module: base

## Description

Deploys the nullplatform base Helm chart onto a Kubernetes cluster with pre-created namespaces and multi-cloud gateway, ingress, logging, and observability configuration

## Architecture

The module creates two kubernetes_namespace_v1 resources (nullplatform-tools and nullplatform) before deploying a helm_release named nullplatform-base from the nullplatform GitHub Helm registry. A templatefile local renders all input variables into a YAML values file that is passed directly to the helm_release resource. Outputs expose security resource identifiers (AWS security group IDs, Azure NSG IDs, GCP firewall names) that are threaded through from input variables and the rendered Helm values are exposed as a sensitive output for testing.

## Features

- Creates kubernetes_namespace_v1 resources for nullplatform-tools and nullplatform to prevent Helm race conditions
- Deploys nullplatform-base helm_release with fully templated multi-cloud gateway and ingress configuration
- Configures public and private Gateway API resources with per-cloud security group, NSG, firewall, and OCI subnet annotations
- Supports multiple observability backends including Prometheus, Datadog, Dynatrace, New Relic, Loki, GELF, and CloudWatch
- Manages image pull secrets for private container registries via Helm chart values
- Configures public and private NGINX ingress controllers with scoped domain routing
- Supports internal or external load balancer types for the public gateway to enable Cloudflare Tunnel and VPN proxy setups

## Basic Usage

```hcl
module "base" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/base?ref=v5.3.1"

  k8s_provider = "your-k8s-provider"
  np_api_key   = "your-np-api-key"
}
```

### Usage with Amazon EKS

```hcl
module "base" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/base?ref=v5.3.1"

  k8s_provider = "eks"
  np_api_key   = "your-np-api-key"
}
```

### Usage with Google GKE

```hcl
module "base" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/base?ref=v5.3.1"

  k8s_provider = "gke"
  np_api_key   = "your-np-api-key"
}
```

### Usage with Azure AKS

```hcl
module "base" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/base?ref=v5.3.1"

  k8s_provider = "aks"
  np_api_key   = "your-np-api-key"
}
```

### Usage with Oracle OKE

```hcl
module "base" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/base?ref=v5.3.1"

  k8s_provider = "oke"
  np_api_key   = "your-np-api-key"
}
```

### Usage with Azure ARO

```hcl
module "base" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/base?ref=v5.3.1"

  k8s_provider = "aro"
  np_api_key   = "your-np-api-key"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.base.rendered_values
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.1.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 3.1.0 |

## Resources

| Name | Type |
|------|------|
| [helm_release.base](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace_v1.nullplatform_applications](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.nullplatform_tools](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |

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
| <a name="input_datadog_logs_enabled"></a> [datadog\_logs\_enabled](#input\_datadog\_logs\_enabled) | Enable log forwarding to Datadog. Set to false to send only metrics. | `bool` | `true` | no |
| <a name="input_datadog_metrics_enabled"></a> [datadog\_metrics\_enabled](#input\_datadog\_metrics\_enabled) | Enable metrics forwarding to Datadog. Set to false to send only logs. | `bool` | `true` | no |
| <a name="input_datadog_region"></a> [datadog\_region](#input\_datadog\_region) | Datadog region (e.g., us, eu). | `string` | `""` | no |
| <a name="input_dynatrace_api_key"></a> [dynatrace\_api\_key](#input\_dynatrace\_api\_key) | Dynatrace API key. | `string` | `""` | no |
| <a name="input_dynatrace_enabled"></a> [dynatrace\_enabled](#input\_dynatrace\_enabled) | Enable Dynatrace integration. | `bool` | `false` | no |
| <a name="input_dynatrace_environment_id"></a> [dynatrace\_environment\_id](#input\_dynatrace\_environment\_id) | Dynatrace environment ID. | `string` | `""` | no |
| <a name="input_dynatrace_logs_enabled"></a> [dynatrace\_logs\_enabled](#input\_dynatrace\_logs\_enabled) | Enable log forwarding to Dynatrace. Set to false to send only metrics. | `bool` | `true` | no |
| <a name="input_dynatrace_metrics_enabled"></a> [dynatrace\_metrics\_enabled](#input\_dynatrace\_metrics\_enabled) | Enable metrics forwarding to Dynatrace. Set to false to send only logs. | `bool` | `true` | no |
| <a name="input_exporter_prometheus_port"></a> [exporter\_prometheus\_port](#input\_exporter\_prometheus\_port) | Port Number to Prometheus exporter. | `string` | `"2021"` | no |
| <a name="input_gateway_api_crds_install"></a> [gateway\_api\_crds\_install](#input\_gateway\_api\_crds\_install) | Install Gateway API CRDs. | `bool` | `false` | no |
| <a name="input_gateway_api_enabled"></a> [gateway\_api\_enabled](#input\_gateway\_api\_enabled) | Enable the Gateway API. | `bool` | `false` | no |
| <a name="input_gateway_enabled"></a> [gateway\_enabled](#input\_gateway\_enabled) | Enable the HTTP gateway. | `bool` | `false` | no |
| <a name="input_gateway_internal_aws_name"></a> [gateway\_internal\_aws\_name](#input\_gateway\_internal\_aws\_name) | Name of private gateway in AWS. | `string` | `"k8s-nullplatform-internal"` | no |
| <a name="input_gateway_internal_enabled"></a> [gateway\_internal\_enabled](#input\_gateway\_internal\_enabled) | Enable the internal (private) gateway. | `bool` | `true` | no |
| <a name="input_gateway_private_aws_dns_name"></a> [gateway\_private\_aws\_dns\_name](#input\_gateway\_private\_aws\_dns\_name) | n/a | `string` | `""` | no |
| <a name="input_gateway_private_aws_security_group_id"></a> [gateway\_private\_aws\_security\_group\_id](#input\_gateway\_private\_aws\_security\_group\_id) | The ID of the AWS security group for the private gateway. Output from infrastructure/aws/security module. | `string` | `""` | no |
| <a name="input_gateway_private_azure_nsg_id"></a> [gateway\_private\_azure\_nsg\_id](#input\_gateway\_private\_azure\_nsg\_id) | The ID of the Azure NSG for the private gateway. Output from infrastructure/azure/security module. | `string` | `""` | no |
| <a name="input_gateway_private_gcp_firewall_name"></a> [gateway\_private\_gcp\_firewall\_name](#input\_gateway\_private\_gcp\_firewall\_name) | The name of the GCP firewall rule for the private gateway. Output from infrastructure/gcp/security module. | `string` | `""` | no |
| <a name="input_gateway_private_oci_security_list_management_mode"></a> [gateway\_private\_oci\_security\_list\_management\_mode](#input\_gateway\_private\_oci\_security\_list\_management\_mode) | OCI Load Balancer security list management mode for the private gateway. Options: 'All' (recommended - auto-manages security lists), 'Frontend' (only frontend rules), 'None' (manual management). | `string` | `"All"` | no |
| <a name="input_gateway_private_oci_subnet"></a> [gateway\_private\_oci\_subnet](#input\_gateway\_private\_oci\_subnet) | OCI subnet OCID for the private gateway load balancer (sets service.beta.kubernetes.io/oci-load-balancer-subnet1). | `string` | `""` | no |
| <a name="input_gateway_public_aws_dns_name"></a> [gateway\_public\_aws\_dns\_name](#input\_gateway\_public\_aws\_dns\_name) | n/a | `string` | `""` | no |
| <a name="input_gateway_public_aws_name"></a> [gateway\_public\_aws\_name](#input\_gateway\_public\_aws\_name) | Name of public gateway in AWS. | `string` | `"k8s-nullplatform-internet-facing"` | no |
| <a name="input_gateway_public_aws_security_group_id"></a> [gateway\_public\_aws\_security\_group\_id](#input\_gateway\_public\_aws\_security\_group\_id) | The ID of the AWS security group for the public gateway. Output from infrastructure/aws/security module. | `string` | `""` | no |
| <a name="input_gateway_public_azure_load_balancer_subnet"></a> [gateway\_public\_azure\_load\_balancer\_subnet](#input\_gateway\_public\_azure\_load\_balancer\_subnet) | Name of the subnet for the public gateway's internal Azure load balancer. Only applied when gateway\_public\_load\_balancer\_type is 'internal'; empty by default, in which case Azure picks the subnet automatically. | `string` | `""` | no |
| <a name="input_gateway_public_azure_nsg_id"></a> [gateway\_public\_azure\_nsg\_id](#input\_gateway\_public\_azure\_nsg\_id) | The ID of the Azure NSG for the public gateway. Output from infrastructure/azure/security module. | `string` | `""` | no |
| <a name="input_gateway_public_enabled"></a> [gateway\_public\_enabled](#input\_gateway\_public\_enabled) | Enable the public gateway. | `bool` | `true` | no |
| <a name="input_gateway_public_gcp_firewall_name"></a> [gateway\_public\_gcp\_firewall\_name](#input\_gateway\_public\_gcp\_firewall\_name) | The name of the GCP firewall rule for the public gateway. Output from infrastructure/gcp/security module. | `string` | `""` | no |
| <a name="input_gateway_public_load_balancer_type"></a> [gateway\_public\_load\_balancer\_type](#input\_gateway\_public\_load\_balancer\_type) | Load balancer type for the public gateway. Use 'internal' for Cloudflare Tunnel / VPN setups where public access is proxied through the private network. Use 'external' for direct internet exposure. | `string` | `"external"` | no |
| <a name="input_gateway_public_name"></a> [gateway\_public\_name](#input\_gateway\_public\_name) | Name of the public Gateway resource created by the chart. Must match the gateway name the nullplatform agent resolves from container-orchestration.gateway.public\_name (e.g. 'internet-facing' on AKS), otherwise HTTPRoutes are created with an unresolvable parentRef. Defaults to 'gateway-public' for backward compatibility: changing it on an existing install recreates the Gateway and orphans every HTTPRoute referencing the old name, causing a traffic outage until routes are regenerated. | `string` | `"gateway-public"` | no |
| <a name="input_gateway_public_oci_security_list_management_mode"></a> [gateway\_public\_oci\_security\_list\_management\_mode](#input\_gateway\_public\_oci\_security\_list\_management\_mode) | OCI Load Balancer security list management mode for the public gateway. Options: 'All' (recommended - auto-manages security lists), 'Frontend' (only frontend rules), 'None' (manual management). | `string` | `"All"` | no |
| <a name="input_gateway_public_oci_subnet"></a> [gateway\_public\_oci\_subnet](#input\_gateway\_public\_oci\_subnet) | OCI subnet OCID for the public gateway load balancer (sets service.beta.kubernetes.io/oci-load-balancer-subnet1). | `string` | `""` | no |
| <a name="input_gateway_use_cluster_ip"></a> [gateway\_use\_cluster\_ip](#input\_gateway\_use\_cluster\_ip) | n/a | `bool` | `false` | no |
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
| <a name="input_logging_application_logs_enabled"></a> [logging\_application\_logs\_enabled](#input\_logging\_application\_logs\_enabled) | Enable application log forwarding. Set to false to keep only http/sys metrics pipelines active across all providers. | `bool` | `true` | no |
| <a name="input_logging_enabled"></a> [logging\_enabled](#input\_logging\_enabled) | Enable the logging layer. | `bool` | `true` | no |
| <a name="input_logging_mount_docker_containers"></a> [logging\_mount\_docker\_containers](#input\_logging\_mount\_docker\_containers) | Mount Docker container log paths. Enable when using Docker container runtime (e.g. Minikube). | `bool` | `false` | no |
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
| <a name="input_newrelic_logs_enabled"></a> [newrelic\_logs\_enabled](#input\_newrelic\_logs\_enabled) | Enable log forwarding to New Relic. Set to false to send only metrics. | `bool` | `true` | no |
| <a name="input_newrelic_metrics_enabled"></a> [newrelic\_metrics\_enabled](#input\_newrelic\_metrics\_enabled) | Enable metrics forwarding to New Relic. Set to false to send only logs. | `bool` | `true` | no |
| <a name="input_newrelic_region"></a> [newrelic\_region](#input\_newrelic\_region) | New Relic region (e.g., US, EU). | `string` | `""` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key for authentication (account level). | `string` | n/a | yes |
| <a name="input_nullplatform_base_helm_version"></a> [nullplatform\_base\_helm\_version](#input\_nullplatform\_base\_helm\_version) | Helm chart version for the nullplatform base. | `string` | `"2.40.0"` | no |
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
| <a name="output_rendered_values"></a> [rendered\_values](#output\_rendered\_values) | The rendered Helm values passed to the base chart. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "base",
  "description": "Deploys the nullplatform base Helm chart onto a Kubernetes cluster with pre-created namespaces and multi-cloud gateway, ingress, logging, and observability configuration",
  "architecture": "The module creates two kubernetes_namespace_v1 resources (nullplatform-tools and nullplatform) before deploying a helm_release named nullplatform-base from the nullplatform GitHub Helm registry. A templatefile local renders all input variables into a YAML values file that is passed directly to the helm_release resource. Outputs expose security resource identifiers (AWS security group IDs, Azure NSG IDs, GCP firewall names) that are threaded through from input variables and the rendered Helm values are exposed as a sensitive output for testing.",
  "features": [
    "Creates kubernetes_namespace_v1 resources for nullplatform-tools and nullplatform to prevent Helm race conditions",
    "Deploys nullplatform-base helm_release with fully templated multi-cloud gateway and ingress configuration",
    "Configures public and private Gateway API resources with per-cloud security group, NSG, firewall, and OCI subnet annotations",
    "Supports multiple observability backends including Prometheus, Datadog, Dynatrace, New Relic, Loki, GELF, and CloudWatch",
    "Manages image pull secrets for private container registries via Helm chart values",
    "Configures public and private NGINX ingress controllers with scoped domain routing",
    "Supports internal or external load balancer types for the public gateway to enable Cloudflare Tunnel and VPN proxy setups"
  ],
  "inputs": [
    {
      "name": "np_api_key",
      "description": "Nullplatform API key for authentication (account level).",
      "required": true
    },
    {
      "name": "k8s_provider",
      "description": "Cloud provider (eks, gke, aks, oke and aro).",
      "required": true
    },
    {
      "name": "gateway_public_load_balancer_type",
      "description": "Load balancer type for the public gateway. Use 'internal' for Cloudflare Tunnel / VPN setups where public access is proxied through the private network. Use 'external' for direct internet exposure.",
      "required": false
    },
    {
      "name": "nullplatform_base_helm_version",
      "description": "Helm chart version for the nullplatform base.",
      "required": false
    },
    {
      "name": "namespace",
      "description": "Kubernetes namespace where the agent runs.",
      "required": false
    },
    {
      "name": "aws_region",
      "description": "AWS region where resources will be deployed.",
      "required": false
    },
    {
      "name": "install_gateway_v2_crd",
      "description": "Install Gateway API v2 CRDs.",
      "required": false
    },
    {
      "name": "tls_required",
      "description": "Whether TLS is required.",
      "required": false
    },
    {
      "name": "gateway_enabled",
      "description": "Enable the HTTP gateway.",
      "required": false
    },
    {
      "name": "gateway_internal_enabled",
      "description": "Enable the internal (private) gateway.",
      "required": false
    },
    {
      "name": "gateway_public_enabled",
      "description": "Enable the public gateway.",
      "required": false
    },
    {
      "name": "gateway_public_name",
      "description": "Name of the public Gateway resource created by the chart. Must match the gateway name the nullplatform agent resolves from container-orchestration.gateway.public_name (e.g. 'internet-facing' on AKS), otherwise HTTPRoutes are created with an unresolvable parentRef. Defaults to 'gateway-public' for backward compatibility: changing it on an existing install recreates the Gateway and orphans every HTTPRoute referencing the old name, causing a traffic outage until routes are regenerated.",
      "required": false
    },
    {
      "name": "internal_azure_load_balancer_subnet",
      "description": "The name of the subnet to use in azure private load balancer",
      "required": false
    },
    {
      "name": "gateway_public_azure_load_balancer_subnet",
      "description": "Name of the subnet for the public gateway's internal Azure load balancer. Only applied when gateway_public_load_balancer_type is 'internal'; empty by default, in which case Azure picks the subnet automatically.",
      "required": false
    },
    {
      "name": "gateway_use_cluster_ip",
      "description": "",
      "required": false
    },
    {
      "name": "gateway_public_aws_dns_name",
      "description": "",
      "required": false
    },
    {
      "name": "gateway_private_aws_dns_name",
      "description": "",
      "required": false
    },
    {
      "name": "control_plane_enabled",
      "description": "Enable the control plane.",
      "required": false
    },
    {
      "name": "logging_enabled",
      "description": "Enable the logging layer.",
      "required": false
    },
    {
      "name": "logging_application_logs_enabled",
      "description": "Enable application log forwarding. Set to false to keep only http/sys metrics pipelines active across all providers.",
      "required": false
    },
    {
      "name": "logging_mount_docker_containers",
      "description": "Mount Docker container log paths. Enable when using Docker container runtime (e.g. Minikube).",
      "required": false
    },
    {
      "name": "prometheus_enabled",
      "description": "Enable the Prometheus exporter.",
      "required": false
    },
    {
      "name": "exporter_prometheus_port",
      "description": "Port Number to Prometheus exporter.",
      "required": false
    },
    {
      "name": "gelf_enabled",
      "description": "Enable GELF output.",
      "required": false
    },
    {
      "name": "gelf_host",
      "description": "GELF host.",
      "required": false
    },
    {
      "name": "gelf_port",
      "description": "GELF port.",
      "required": false
    },
    {
      "name": "loki_enabled",
      "description": "Enable Loki output.",
      "required": false
    },
    {
      "name": "loki_host",
      "description": "Loki host.",
      "required": false
    },
    {
      "name": "loki_port",
      "description": "Loki port.",
      "required": false
    },
    {
      "name": "loki_user",
      "description": "Loki username (if applicable).",
      "required": false
    },
    {
      "name": "loki_password",
      "description": "Loki password (if applicable).",
      "required": false
    },
    {
      "name": "loki_bearer_token",
      "description": "Loki bearer token (if applicable).",
      "required": false
    },
    {
      "name": "dynatrace_enabled",
      "description": "Enable Dynatrace integration.",
      "required": false
    },
    {
      "name": "dynatrace_logs_enabled",
      "description": "Enable log forwarding to Dynatrace. Set to false to send only metrics.",
      "required": false
    },
    {
      "name": "dynatrace_metrics_enabled",
      "description": "Enable metrics forwarding to Dynatrace. Set to false to send only logs.",
      "required": false
    },
    {
      "name": "dynatrace_api_key",
      "description": "Dynatrace API key.",
      "required": false
    },
    {
      "name": "dynatrace_environment_id",
      "description": "Dynatrace environment ID.",
      "required": false
    },
    {
      "name": "datadog_enabled",
      "description": "Enable Datadog integration.",
      "required": false
    },
    {
      "name": "datadog_logs_enabled",
      "description": "Enable log forwarding to Datadog. Set to false to send only metrics.",
      "required": false
    },
    {
      "name": "datadog_metrics_enabled",
      "description": "Enable metrics forwarding to Datadog. Set to false to send only logs.",
      "required": false
    },
    {
      "name": "datadog_api_key",
      "description": "Datadog API key.",
      "required": false
    },
    {
      "name": "datadog_region",
      "description": "Datadog region (e.g., us, eu).",
      "required": false
    },
    {
      "name": "newrelic_enabled",
      "description": "Enable New Relic integration.",
      "required": false
    },
    {
      "name": "newrelic_logs_enabled",
      "description": "Enable log forwarding to New Relic. Set to false to send only metrics.",
      "required": false
    },
    {
      "name": "newrelic_metrics_enabled",
      "description": "Enable metrics forwarding to New Relic. Set to false to send only logs.",
      "required": false
    },
    {
      "name": "newrelic_license_key",
      "description": "New Relic license key.",
      "required": false
    },
    {
      "name": "newrelic_region",
      "description": "New Relic region (e.g., US, EU).",
      "required": false
    },
    {
      "name": "cloudwatch_enabled",
      "description": "Enable CloudWatch (global switch).",
      "required": false
    },
    {
      "name": "cloudwatch_logs_enabled",
      "description": "Enable log forwarding to CloudWatch.",
      "required": false
    },
    {
      "name": "cloudwatch_performance_metrics_enabled",
      "description": "Enable performance metrics in CloudWatch.",
      "required": false
    },
    {
      "name": "cloudwatch_custom_metrics_enabled",
      "description": "Enable custom metrics in CloudWatch.",
      "required": false
    },
    {
      "name": "cloudwatch_access_logs_enabled",
      "description": "Enable access logs in CloudWatch.",
      "required": false
    },
    {
      "name": "metrics_server_enabled",
      "description": "Enable the metrics server.",
      "required": false
    },
    {
      "name": "gateways_enabled",
      "description": "Enable gateway resources (Helm chart).",
      "required": false
    },
    {
      "name": "gateway_api_enabled",
      "description": "Enable the Gateway API.",
      "required": false
    },
    {
      "name": "gateway_api_crds_install",
      "description": "Install Gateway API CRDs.",
      "required": false
    },
    {
      "name": "gateway_public_aws_name",
      "description": "Name of public gateway in AWS.",
      "required": false
    },
    {
      "name": "gateway_internal_aws_name",
      "description": "Name of private gateway in AWS.",
      "required": false
    },
    {
      "name": "gateway_public_aws_security_group_id",
      "description": "The ID of the AWS security group for the public gateway. Output from infrastructure/aws/security module.",
      "required": false
    },
    {
      "name": "gateway_private_aws_security_group_id",
      "description": "The ID of the AWS security group for the private gateway. Output from infrastructure/aws/security module.",
      "required": false
    },
    {
      "name": "gateway_public_azure_nsg_id",
      "description": "The ID of the Azure NSG for the public gateway. Output from infrastructure/azure/security module.",
      "required": false
    },
    {
      "name": "gateway_private_azure_nsg_id",
      "description": "The ID of the Azure NSG for the private gateway. Output from infrastructure/azure/security module.",
      "required": false
    },
    {
      "name": "gateway_public_gcp_firewall_name",
      "description": "The name of the GCP firewall rule for the public gateway. Output from infrastructure/gcp/security module.",
      "required": false
    },
    {
      "name": "gateway_private_gcp_firewall_name",
      "description": "The name of the GCP firewall rule for the private gateway. Output from infrastructure/gcp/security module.",
      "required": false
    },
    {
      "name": "gateway_public_oci_security_list_management_mode",
      "description": "OCI Load Balancer security list management mode for the public gateway. Options: 'All' (recommended - auto-manages security lists), 'Frontend' (only frontend rules), 'None' (manual management).",
      "required": false
    },
    {
      "name": "gateway_private_oci_security_list_management_mode",
      "description": "OCI Load Balancer security list management mode for the private gateway. Options: 'All' (recommended - auto-manages security lists), 'Frontend' (only frontend rules), 'None' (manual management).",
      "required": false
    },
    {
      "name": "gateway_public_oci_subnet",
      "description": "OCI subnet OCID for the public gateway load balancer (sets service.beta.kubernetes.io/oci-load-balancer-subnet1).",
      "required": false
    },
    {
      "name": "gateway_private_oci_subnet",
      "description": "OCI subnet OCID for the private gateway load balancer (sets service.beta.kubernetes.io/oci-load-balancer-subnet1).",
      "required": false
    },
    {
      "name": "image_pull_secrets_enabled",
      "description": "Create and use an image pull secret.",
      "required": false
    },
    {
      "name": "image_pull_secrets_registry",
      "description": "Registry URL for the image pull secret.",
      "required": false
    },
    {
      "name": "image_pull_secrets_username",
      "description": "Registry username.",
      "required": false
    },
    {
      "name": "image_pull_secrets_password",
      "description": "Registry password or token.",
      "required": false
    },
    {
      "name": "ingressControllers",
      "description": "Configuración de los IngressControllers públicos y privados",
      "required": false
    }
  ],
  "outputs": [
    "rendered_values",
    "public_gateway_security_group_id",
    "private_gateway_security_group_id",
    "public_gateway_nsg_id",
    "private_gateway_nsg_id",
    "public_gateway_firewall_name",
    "private_gateway_firewall_name"
  ],
  "hash": "5cfdfa44c276c23e9e759e56ac0fc789"
}
END_AI_METADATA -->
