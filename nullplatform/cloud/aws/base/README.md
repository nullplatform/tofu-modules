# Module: AWS Base

Installs the Nullplatform base Helm release on the cluster namespace and generates the agent API key tied to the provided NRN.

Usage:

```
module "cloud_aws_base" {
  source    = "git::https://github.com/nullplatform/tofu-modules.git///nullplatform/cloud/aws/base?ref=v1.0.0"
  nrn       = var.nrn
  namespace = var.namespace
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
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
| [helm_release.base](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [nullplatform_api_key.nullplatform_agent_api_key](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/api_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace to agent run | `string` | `"nullplatform-tools"` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Identifier Nullplatform Resources Name | `string` | n/a | yes |
| <a name="input_nullplatform_base_helm_version"></a> [nullplatform_base_helm_version](#input\_nullplatform_base_helm_version) | Helm chart version for the Nullplatform agent | `string` | `"2.12.0"` | no |
<!-- END_TF_DOCS -->
