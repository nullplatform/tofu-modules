# Module: Prometheus

Deploys Prometheus via Helm and registers the server endpoint with Nullplatform for metrics collection.

Usage:

```
module "prometheus" {
  source               = "git::https://github.com/nullplatform/tofu-modules.git///nullplatform/prometheus?ref=v1.0.0"
  nrn                  = var.nrn
  np_api_key           = var.np_api_key
  prometheus_namespace = var.prometheus_namespace
  nullplatform_port    = var.nullplatform_port
  prometheus_url       = var.prometheus_url
  install_prometheus   = var.install_prometheus
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.0 |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | ~> 0.0.63 |

## Resources

| Name | Type |
|------|------|
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [nullplatform_provider_config.prometheus](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Value of the dimensions that you need this provider to be visible | `map(string)` | `{}` | no |
| <a name="input_install_prometheus"></a> [install\_prometheus](#input\_install\_prometheus) | value | `bool` | `false` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | nullplatform API key for authentication | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | nullplatform Resource Name - unique identifier for resources | `string` | n/a | yes |
| <a name="input_nullplatform_port"></a> [nullplatform\_port](#input\_nullplatform\_port) | Port number for nullplatform service communication | `number` | `2021` | no |
| <a name="input_prometheus_namespace"></a> [prometheus\_namespace](#input\_prometheus\_namespace) | Kubernetes namespace where Prometheus will be deployed | `string` | `"prometheus"` | no |
| <a name="input_prometheus_url"></a> [prometheus\_url](#input\_prometheus\_url) | Prometheus server URL | `string` | `""` | no |
<!-- END_TF_DOCS -->
