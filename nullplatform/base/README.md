# Module: Base

This module installs the **base Helm chart** from **nullplatform**.  
For more information, see the [our documentation](https://docs.nullplatform.com/docs/providers/helm-charts#base-chart)



## Usage

### Basic example

```hcl
module "base" {
    source = "git::https://github.com/nullplatform/tofu-modules.git///nullplatform/base?ref=v1.0.0"
    np_api_key = var.np_api_key
    nrn = var.nrn
    cloud_provider = "gke"
    nullplatform-base-helm-version = "2.16.0"
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

## Resources

| Name | Type |
|------|------|
| [helm_release.base](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region where resources will be deployed. | `string` | `"us-east-1"` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Cloud provider (eks, gke, aks, oke). | `string` | n/a | yes |
| <a name="input_cloudwatch_access_logs_enabled"></a> [cloudwatch\_access\_logs\_enabled](#input\_cloudwatch\_access\_logs\_enabled) | Enable access logs in CloudWatch. | `bool` | `false` | no |
| <a name="input_cloudwatch_custom_metrics_enabled"></a> [cloudwatch\_custom\_metrics\_enabled](#input\_cloudwatch\_custom\_metrics\_enabled) | Enable custom metrics in CloudWatch. | `bool` | `false` | no |
| <a name="input_cloudwatch_enabled"></a> [cloudwatch\_enabled](#input\_cloudwatch\_enabled) | Enable CloudWatch (global switch). | `bool` | `false` | no |
| <a name="input_cloudwatch_logs_enabled"></a> [cloudwatch\_logs\_enabled](#input\_cloudwatch\_logs\_enabled) | Enable logs to CloudWatch. | `bool` | `false` | no |
| <a name="input_cloudwatch_performance_metrics_enabled"></a> [cloudwatch\_performance\_metrics\_enabled](#input\_cloudwatch\_performance\_metrics\_enabled) | Enable performance metrics in CloudWatch. | `bool` | `false` | no |
| <a name="input_control_plane_enabled"></a> [control\_plane\_enabled](#input\_control\_plane\_enabled) | Enable the Control Plane. | `bool` | `false` | no |
| <a name="input_datadog_api_key"></a> [datadog\_api\_key](#input\_datadog\_api\_key) | Datadog API key. | `string` | `""` | no |
| <a name="input_datadog_enabled"></a> [datadog\_enabled](#input\_datadog\_enabled) | Enable Datadog integration. | `bool` | `false` | no |
| <a name="input_datadog_region"></a> [datadog\_region](#input\_datadog\_region) | Datadog region (e.g., us, eu). | `string` | `""` | no |
| <a name="input_dynatrace_api_key"></a> [dynatrace\_api\_key](#input\_dynatrace\_api\_key) | Dynatrace API key. | `string` | `""` | no |
| <a name="input_dynatrace_enabled"></a> [dynatrace\_enabled](#input\_dynatrace\_enabled) | Enable Dynatrace integration. | `bool` | `false` | no |
| <a name="input_dynatrace_environment_id"></a> [dynatrace\_environment\_id](#input\_dynatrace\_environment\_id) | Dynatrace environment ID. | `string` | `""` | no |
| <a name="input_gateway_api_crds_install"></a> [gateway\_api\_crds\_install](#input\_gateway\_api\_crds\_install) | Install Gateway API CRDs. | `bool` | `false` | no |
| <a name="input_gateway_api_enabled"></a> [gateway\_api\_enabled](#input\_gateway\_api\_enabled) | Enable Gateway API. | `bool` | `false` | no |
| <a name="input_gateway_enabled"></a> [gateway\_enabled](#input\_gateway\_enabled) | Enable the HTTP Gateway. | `bool` | `false` | no |
| <a name="input_gateway_internal_enabled"></a> [gateway\_internal\_enabled](#input\_gateway\_internal\_enabled) | Enable the internal (private) Gateway. | `bool` | `false` | no |
| <a name="input_gateways_enabled"></a> [gateways\_enabled](#input\_gateways\_enabled) | Enable Gateways resources (helm chart). | `bool` | `true` | no |
| <a name="input_gelf_enabled"></a> [gelf\_enabled](#input\_gelf\_enabled) | Enable GELF output. | `bool` | `false` | no |
| <a name="input_gelf_host"></a> [gelf\_host](#input\_gelf\_host) | GELF host. | `string` | `""` | no |
| <a name="input_gelf_port"></a> [gelf\_port](#input\_gelf\_port) | GELF port. | `number` | `12201` | no |
| <a name="input_image_pull_secrets_enabled"></a> [image\_pull\_secrets\_enabled](#input\_image\_pull\_secrets\_enabled) | Create and use an imagePullSecret. | `bool` | `false` | no |
| <a name="input_image_pull_secrets_password"></a> [image\_pull\_secrets\_password](#input\_image\_pull\_secrets\_password) | Registry password/token. | `string` | `""` | no |
| <a name="input_image_pull_secrets_registry"></a> [image\_pull\_secrets\_registry](#input\_image\_pull\_secrets\_registry) | Registry URL for the imagePullSecret. | `string` | `""` | no |
| <a name="input_image_pull_secrets_username"></a> [image\_pull\_secrets\_username](#input\_image\_pull\_secrets\_username) | Registry username. | `string` | `""` | no |
| <a name="input_install_gateway_v2_crd"></a> [install\_gateway\_v2\_crd](#input\_install\_gateway\_v2\_crd) | Install Gateway API V2 CRDs. | `bool` | `false` | no |
| <a name="input_logging_enabled"></a> [logging\_enabled](#input\_logging\_enabled) | Enable the logging layer. | `bool` | `true` | no |
| <a name="input_loki_bearer_token"></a> [loki\_bearer\_token](#input\_loki\_bearer\_token) | Loki bearer token (if applicable). | `string` | `""` | no |
| <a name="input_loki_enabled"></a> [loki\_enabled](#input\_loki\_enabled) | Enable Loki output. | `bool` | `false` | no |
| <a name="input_loki_host"></a> [loki\_host](#input\_loki\_host) | Loki host. | `string` | `""` | no |
| <a name="input_loki_password"></a> [loki\_password](#input\_loki\_password) | Loki password (if applicable). | `string` | `""` | no |
| <a name="input_loki_port"></a> [loki\_port](#input\_loki\_port) | Loki port. | `number` | `3100` | no |
| <a name="input_loki_user"></a> [loki\_user](#input\_loki\_user) | Loki username (if applicable). | `string` | `""` | no |
| <a name="input_metrics_server_enabled"></a> [metrics\_server\_enabled](#input\_metrics\_server\_enabled) | Enable Metrics Server. | `bool` | `false` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace to agent run | `string` | `"nullplatform-tools"` | no |
| <a name="input_newrelic_enabled"></a> [newrelic\_enabled](#input\_newrelic\_enabled) | Enable New Relic integration. | `bool` | `false` | no |
| <a name="input_newrelic_license_key"></a> [newrelic\_license\_key](#input\_newrelic\_license\_key) | New Relic license key. | `string` | `""` | no |
| <a name="input_newrelic_region"></a> [newrelic\_region](#input\_newrelic\_region) | New Relic region (e.g., US, EU). | `string` | `""` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key for authentication, account level | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Identifier Nullplatform Resources Name | `string` | n/a | yes |
| <a name="input_nullplatform_base_helm_version"></a> [nullplatform\_base\_helm\_version](#input\_nullplatform\_base\_helm\_version) | Helm chart version for the nullplatform agent | `string` | `"2.12.0"` | no |
| <a name="input_prometheus_enabled"></a> [prometheus\_enabled](#input\_prometheus\_enabled) | Enable Prometheus exporter. | `bool` | `true` | no |
| <a name="input_tls_required"></a> [tls\_required](#input\_tls\_required) | Whether TLS is required. | `bool` | `true` | no |
<!-- END_TF_DOCS -->
