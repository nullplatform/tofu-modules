# Module: istio

## Description

Deploys Istio service mesh components (base, istiod control plane, and ingress gateway) to a Kubernetes cluster using Helm charts

## Architecture

The module creates three helm_release resources in sequence: istio-base for CRDs and foundational resources, istiod for the Istio control plane, and istio-ingressgateway for ingress traffic management. The helm_release resources use explicit dependencies (depends_on) to ensure proper installation order, with istiod depending on istio-base and the gateway depending on istiod. The ingress gateway is configured via a templated values file that translates input variables into Helm chart values for service type, port mappings (status, HTTPS, and optional HTTP2), creating a Kubernetes service and deployment that routes external traffic into the mesh.

## Features

- Creates Istio base installation with CRDs and cluster-scoped resources
- Deploys istiod control plane for service mesh management and configuration distribution
- Provisions Istio ingress gateway with configurable LoadBalancer service type
- Configures HTTPS ingress on port 443 with customizable target port for TLS termination
- Supports optional HTTP2 port exposure on port 80 for non-TLS traffic
- Implements atomic Helm deployments with automatic rollback on failure and pod recreation

## Basic Usage

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v1.49.0"
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
| <a name="input_istio_base_version"></a> [istio\_base\_version](#input\_istio\_base\_version) | Helm chart version for the istio-base component | `string` | `"1.27.1"` | no |
| <a name="input_istio_ingressgateway_version"></a> [istio\_ingressgateway\_version](#input\_istio\_ingressgateway\_version) | Helm chart version for the Istio ingress gateway | `string` | `"1.27.1"` | no |
| <a name="input_istiod_version"></a> [istiod\_version](#input\_istiod\_version) | Helm chart version for istiod (Istio control plane) | `string` | `"1.27.1"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The Kubernetes namespace where gateway will be installed. | `string` | `"istio-system"` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | The Helm repository URL (e.g., https://istio-release.storage.googleapis.com/charts). | `string` | `"https://istio-release.storage.googleapis.com/charts"` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | The Kubernetes service type for the Istio ingress gateway | `string` | `"LoadBalancer"` | no |
| <a name="input_status_port"></a> [status\_port](#input\_status\_port) | The status port used (status-port) | `number` | `15021` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "istio",
  "description": "Deploys Istio service mesh components (base, istiod control plane, and ingress gateway) to a Kubernetes cluster using Helm charts",
  "architecture": "The module creates three helm_release resources in sequence: istio-base for CRDs and foundational resources, istiod for the Istio control plane, and istio-ingressgateway for ingress traffic management. The helm_release resources use explicit dependencies (depends_on) to ensure proper installation order, with istiod depending on istio-base and the gateway depending on istiod. The ingress gateway is configured via a templated values file that translates input variables into Helm chart values for service type, port mappings (status, HTTPS, and optional HTTP2), creating a Kubernetes service and deployment that routes external traffic into the mesh.",
  "features": [
    "Creates Istio base installation with CRDs and cluster-scoped resources",
    "Deploys istiod control plane for service mesh management and configuration distribution",
    "Provisions Istio ingress gateway with configurable LoadBalancer service type",
    "Configures HTTPS ingress on port 443 with customizable target port for TLS termination",
    "Supports optional HTTP2 port exposure on port 80 for non-TLS traffic",
    "Implements atomic Helm deployments with automatic rollback on failure and pod recreation"
  ],
  "inputs": [
    {
      "name": "istio_base_version",
      "description": "Helm chart version for the istio-base component",
      "required": false
    },
    {
      "name": "istio_ingressgateway_version",
      "description": "Helm chart version for the Istio ingress gateway",
      "required": false
    },
    {
      "name": "istiod_version",
      "description": "Helm chart version for istiod (Istio control plane)",
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
  "hash": "aceae57fe7cee43c75864347dae6a3d5"
}
END_AI_METADATA -->
