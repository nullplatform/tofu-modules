
# Modules: istio

This module installs external dns using helm chart.

Usage:


```
module "istio" {
  source                       = "git@github.com:nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v0.0.1"
  istio_base_version           = var.istio_base_version
  istiod_version               = var.istiod_version
  istio_ingressgateway_version = var.istio_ingressgateway_version
  kubeconfig_path              = var.kubeconfig_path
  kube_context                 = var.kube_context
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
| <a name="input_istio_base_version"></a> [istio\_base\_version](#input\_istio\_base\_version) | n/a | `string` | `"1.27.1"` | no |
| <a name="input_istio_ingressgateway_version"></a> [istio\_ingressgateway\_version](#input\_istio\_ingressgateway\_version) | n/a | `string` | `"1.27.1"` | no |
| <a name="input_istiod_version"></a> [istiod\_version](#input\_istiod\_version) | n/a | `string` | `"1.27.1"` | no |
| <a name="input_kube_context"></a> [kube\_context](#input\_kube\_context) | n/a | `string` | `null` | no |
| <a name="input_kubeconfig_path"></a> [kubeconfig\_path](#input\_kubeconfig\_path) | n/a | `string` | `"~/.kube/config"` | no |
<!-- END_TF_DOCS -->