
# Modules: istio

This module installs external dns using helm chart.

Usage:


```
module "istio" {
  source                       = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/commons/istio?ref=v1.0.0"
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
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | Whether to expose the http2 (port 80) service. | `bool` | `false` | no |
| <a name="input_http2_port"></a> [http2\_port](#input\_http2\_port) | Service port for http2 when enabled. | `number` | `80` | no |
| <a name="input_http2_target_port"></a> [http2\_target\_port](#input\_http2\_target\_port) | Target port for http2 when enabled. | `number` | `80` | no |
| <a name="input_https_port"></a> [https\_port](#input\_https\_port) | External HTTPS Service port. | `number` | `443` | no |
| <a name="input_https_target_port"></a> [https\_target\_port](#input\_https\_target\_port) | Container targetPort for HTTPS. | `number` | `8443` | no |
| <a name="input_istio_base_version"></a> [istio\_base\_version](#input\_istio\_base\_version) | n/a | `string` | `"1.27.1"` | no |
| <a name="input_istio_ingressgateway_version"></a> [istio\_ingressgateway\_version](#input\_istio\_ingressgateway\_version) | n/a | `string` | `"1.27.1"` | no |
| <a name="input_istiod_version"></a> [istiod\_version](#input\_istiod\_version) | n/a | `string` | `"1.27.1"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace where the gateway will be installed. | `string` | `"istio-system"` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Helm repository URL (e.g., https://istio-release.storage.googleapis.com/charts). | `string` | `"https://istio-release.storage.googleapis.com/charts"` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | Service type for the IngressGateway. | `string` | `"LoadBalancer"` | no |
| <a name="input_status_port"></a> [status\_port](#input\_status\_port) | Status port (status-port). | `number` | `15021` | no |
<!-- END_TF_DOCS -->