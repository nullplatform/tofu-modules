# Module: GCP Base

Deploys the Nullplatform base Helm chart to the target cluster and issues the platform API key for the specified NRN.

Usage:

```
module "cloud_gcp_base" {
  source          = "git::https://github.com/nullplatform/tofu-modules.git///nullplatform/cloud/gcp/base?ref=v1.0.0"
  nrn             = var.nrn
  np_api_key      = var.np_api_key
  namespace       = var.namespace
  kubeconfig_path = var.kubeconfig_path
  kube_context    = var.kube_context
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.25 |
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.25 |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | ~> 0.0.63 |

## Resources

| Name | Type |
|------|------|
| [helm_release.base](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.gateways](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [nullplatform_api_key.nullplatform_base_api_key](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/api_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kube_context"></a> [kube\_context](#input\_kube\_context) | Kubernetes context name to use from the kubeconfig file | `string` | `null` | no |
| <a name="input_kubeconfig_path"></a> [kubeconfig\_path](#input\_kubeconfig\_path) | Path to the kubeconfig file for Kubernetes cluster access | `string` | `"~/.kube/config"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace to agent run | `string` | `"nullplatform-tools"` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key for authentication | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Identifier Nullplatform Resources Name | `string` | n/a | yes |
| <a name="input_nullplatform_base_helm_version"></a> [nullplatform_base_helm_version](#input\_nullplatform_base_helm_version) | Helm chart version for the Nullplatform agent | `string` | `"2.12.0"` | no |
<!-- END_TF_DOCS -->
