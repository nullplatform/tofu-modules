# Module: istio

## Description

Deploys Istio service mesh components (istio-base, istiod, and istio-ingressgateway) onto a Kubernetes cluster using sequenced Helm releases with cloud-provider-specific ingress gateway configuration

## Architecture

The module creates three helm_release resources in a strict dependency chain: istio-base is installed first, followed by istiod (which depends on istio-base and configures pilot.replicaCount and pilot.autoscaleMin via set blocks), and finally istio-ingressgateway (which depends on istiod). The ingress gateway helm_release consumes a templatefile-rendered values YAML from locals.tf, which injects service type, port mappings, HTTP2 settings, cloud provider identity, and OCI subnet IDs into the gateway Helm chart. All three releases target the same Kubernetes namespace and are configured with atomic installs, cleanup on failure, and a 600-second timeout.

## Features

- Deploys istio-base CRD foundation chart as the prerequisite for all other Istio components
- Installs istiod control plane with configurable replica count and autoscale minimum to prevent HPA from collapsing HA deployments during node drains
- Configures istio-ingressgateway with templated Helm values supporting HTTPS, optional HTTP2, and custom service types
- Injects cloud-provider-specific LoadBalancer annotations (AWS, OCI, Azure, GCP) into the ingress gateway service via templatefile rendering
- Supports OCI-specific LoadBalancer subnet assignment via oci_load_balancer_subnet_ids annotation injection
- Enforces sequential Helm release ordering with dependency_on chaining to ensure stable Istio component installation

## Basic Usage

```hcl
module "istio" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v3.1.0"
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
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.1.1 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.istio_base](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio_ingressgateway](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istiod](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [terraform_data.provider_validation](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | The cloud provider where the cluster is running. Used to inject provider-specific LoadBalancer annotations (e.g. oci). Leave empty for generic/on-prem clusters. | `string` | `""` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | Whether to expose the HTTP2 (port 80) service | `bool` | `false` | no |
| <a name="input_http2_port"></a> [http2\_port](#input\_http2\_port) | The external service port for HTTP2 when enabled. | `number` | `80` | no |
| <a name="input_http2_target_port"></a> [http2\_target\_port](#input\_http2\_target\_port) | The container target port for HTTP2 when enabled | `number` | `80` | no |
| <a name="input_https_port"></a> [https\_port](#input\_https\_port) | The external HTTPS service port | `number` | `443` | no |
| <a name="input_https_target_port"></a> [https\_target\_port](#input\_https\_target\_port) | The container target port for HTTPS | `number` | `8443` | no |
| <a name="input_istio_base_version"></a> [istio\_base\_version](#input\_istio\_base\_version) | Helm chart version for the istio-base component | `string` | `"1.27.1"` | no |
| <a name="input_istio_ingressgateway_version"></a> [istio\_ingressgateway\_version](#input\_istio\_ingressgateway\_version) | Helm chart version for the Istio ingress gateway | `string` | `"1.27.1"` | no |
| <a name="input_istiod_replicas"></a> [istiod\_replicas](#input\_istiod\_replicas) | Number of istiod replicas. Default is 1 to preserve the previous behavior of this module for existing consumers; set to 2 (recommended) to let the pilot deployment tolerate node drains — the istiod chart installs a PodDisruptionBudget with minAvailable=1, and a single-replica istiod therefore blocks node rolling updates (e.g. EKS AMI bumps). This value is applied to both pilot.replicaCount and pilot.autoscaleMin; without the autoscaleMin override, the HPA (enabled by default with autoscaleMin=1) would scale back to 1 replica shortly after install. | `number` | `1` | no |
| <a name="input_istiod_version"></a> [istiod\_version](#input\_istiod\_version) | Helm chart version for istiod (Istio control plane) | `string` | `"1.27.1"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The Kubernetes namespace where gateway will be installed. | `string` | `"istio-system"` | no |
| <a name="input_oci_load_balancer_subnet_ids"></a> [oci\_load\_balancer\_subnet\_ids](#input\_oci\_load\_balancer\_subnet\_ids) | List of OCI subnet OCIDs for the LoadBalancer Service (required when cloud\_provider is 'oci') | `list(string)` | `[]` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | The Helm repository URL (e.g., https://istio-release.storage.googleapis.com/charts). | `string` | `"https://istio-release.storage.googleapis.com/charts"` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | The Kubernetes service type for the Istio ingress gateway | `string` | `"LoadBalancer"` | no |
| <a name="input_status_port"></a> [status\_port](#input\_status\_port) | The status port used (status-port) | `number` | `15021` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "istio",
  "description": "Deploys Istio service mesh components (istio-base, istiod, and istio-ingressgateway) onto a Kubernetes cluster using sequenced Helm releases with cloud-provider-specific ingress gateway configuration",
  "architecture": "The module creates three helm_release resources in a strict dependency chain: istio-base is installed first, followed by istiod (which depends on istio-base and configures pilot.replicaCount and pilot.autoscaleMin via set blocks), and finally istio-ingressgateway (which depends on istiod). The ingress gateway helm_release consumes a templatefile-rendered values YAML from locals.tf, which injects service type, port mappings, HTTP2 settings, cloud provider identity, and OCI subnet IDs into the gateway Helm chart. All three releases target the same Kubernetes namespace and are configured with atomic installs, cleanup on failure, and a 600-second timeout.",
  "features": [
    "Deploys istio-base CRD foundation chart as the prerequisite for all other Istio components",
    "Installs istiod control plane with configurable replica count and autoscale minimum to prevent HPA from collapsing HA deployments during node drains",
    "Configures istio-ingressgateway with templated Helm values supporting HTTPS, optional HTTP2, and custom service types",
    "Injects cloud-provider-specific LoadBalancer annotations (AWS, OCI, Azure, GCP) into the ingress gateway service via templatefile rendering",
    "Supports OCI-specific LoadBalancer subnet assignment via oci_load_balancer_subnet_ids annotation injection",
    "Enforces sequential Helm release ordering with dependency_on chaining to ensure stable Istio component installation"
  ],
  "inputs": [
    {
      "name": "istiod_replicas",
      "description": "Number of istiod replicas. Default is 1 to preserve the previous behavior of this module for existing consumers; set to 2 (recommended) to let the pilot deployment tolerate node drains — the istiod chart installs a PodDisruptionBudget with minAvailable=1, and a single-replica istiod therefore blocks node rolling updates (e.g. EKS AMI bumps). This value is applied to both pilot.replicaCount and pilot.autoscaleMin; without the autoscaleMin override, the HPA (enabled by default with autoscaleMin=1) would scale back to 1 replica shortly after install.",
      "required": false
    },
    {
      "name": "cloud_provider",
      "description": "The cloud provider where the cluster is running. Used to inject provider-specific LoadBalancer annotations (e.g. oci). Leave empty for generic/on-prem clusters.",
      "required": false
    },
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
      "name": "oci_load_balancer_subnet_ids",
      "description": "List of OCI subnet OCIDs for the LoadBalancer Service (required when cloud_provider is 'oci')",
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
  "hash": "b03b4dc5a6c60bd77b4c20e4da00821b"
}
END_AI_METADATA -->
