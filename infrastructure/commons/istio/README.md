# Module: istio

## Description

Deploys Istio with Helm charts to create an ingress gateway

## Architecture

The module creates three Helm releases: istio-base, istiod, and istio-ingressgateway, which are connected through dependencies. The istio-ingressgateway release uses values from the locals.tf file, which are templated from the istio_ingressgateway.tmpl.yaml file. The Helm releases are configured with various options, such as create_namespace, disable_webhooks, and force_update. The module also uses variables from the variables.tf file to customize the deployment, such as the service type, status port, and HTTPS port.

## Features

- Creates Helm releases for Istio base, Istiod, and ingress gateway
- Configures Istio ingress gateway with customizable service type and ports
- Supports HTTP2 protocol with customizable port and target port

## Basic Usage

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v1.46.0"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.istio.id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [helm_release.istio_base](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio_ingressgateway](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istiod](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | Whether to expose the HTTP2 (port 80) service | `bool` | `false` | no |
| <a name="input_http2_port"></a> [http2\_port](#input\_http2\_port) | The external service port for HTTP2 when enabled. | `number` | `80` | no |
| <a name="input_http2_target_port"></a> [http2\_target\_port](#input\_http2\_target\_port) | The container target port for HTTP2 when enabled | `number` | `80` | no |
| <a name="input_https_port"></a> [https\_port](#input\_https\_port) | The external HTTPS service port | `number` | `443` | no |
| <a name="input_https_target_port"></a> [https\_target\_port](#input\_https\_target\_port) | The container target port for HTTPS | `number` | `8443` | no |
| <a name="input_istio_base_version"></a> [istio\_base\_version](#input\_istio\_base\_version) | n/a | `string` | `"1.27.1"` | no |
| <a name="input_istio_ingressgateway_version"></a> [istio\_ingressgateway\_version](#input\_istio\_ingressgateway\_version) | n/a | `string` | `"1.27.1"` | no |
| <a name="input_istiod_version"></a> [istiod\_version](#input\_istiod\_version) | n/a | `string` | `"1.27.1"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The Kubernetes namespace where gateway will be installed. | `string` | `"istio-system"` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | The Helm repository URL (e.g., https://istio-release.storage.googleapis.com/charts). | `string` | `"https://istio-release.storage.googleapis.com/charts"` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | The Kubernetes service type for the Istio ingress gateway | `string` | `"LoadBalancer"` | no |
| <a name="input_status_port"></a> [status\_port](#input\_status\_port) | The status port used (status-port) | `number` | `15021` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "istio",
  "description": "Deploys Istio with Helm charts to create an ingress gateway",
  "architecture": "The module creates three Helm releases: istio-base, istiod, and istio-ingressgateway, which are connected through dependencies. The istio-ingressgateway release uses values from the locals.tf file, which are templated from the istio_ingressgateway.tmpl.yaml file. The Helm releases are configured with various options, such as create_namespace, disable_webhooks, and force_update. The module also uses variables from the variables.tf file to customize the deployment, such as the service type, status port, and HTTPS port.",
  "features": [
    "Creates Helm releases for Istio base, Istiod, and ingress gateway",
    "Configures Istio ingress gateway with customizable service type and ports",
    "Supports HTTP2 protocol with customizable port and target port"
  ],
  "inputs": [
    {
      "name": "istio_base_version",
      "description": "",
      "required": false
    },
    {
      "name": "istio_ingressgateway_version",
      "description": "",
      "required": false
    },
    {
      "name": "istiod_version",
      "description": "",
      "required": false
    },
    {
      "name": "service_type",
      "description": "The Kubernetes service type for the Istio ingress gateway",
      "required": false
    },
    {
      "name": "status_port",
      "description": "The status port used (status-port)",
      "required": false
    },
    {
      "name": "https_port",
      "description": "The external HTTPS service port",
      "required": false
    },
    {
      "name": "https_target_port",
      "description": "The container target port for HTTPS",
      "required": false
    },
    {
      "name": "repository",
      "description": "The Helm repository URL (e.g., https://istio-release.storage.googleapis.com/charts).",
      "required": false
    },
    {
      "name": "namespace",
      "description": "The Kubernetes namespace where gateway will be installed.",
      "required": false
    },
    {
      "name": "enable_http2",
      "description": "Whether to expose the HTTP2 (port 80) service",
      "required": false
    },
    {
      "name": "http2_port",
      "description": "The external service port for HTTP2 when enabled.",
      "required": false
    },
    {
      "name": "http2_target_port",
      "description": "The container target port for HTTP2 when enabled",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "e04845dd33391c1391743d1060704bd1"
}
END_AI_METADATA -->
