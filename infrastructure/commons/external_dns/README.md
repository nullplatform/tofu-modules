
# Modules: external_dns

This module installs external dns using helm chart.

Usage:


```
module "external_dns" {
  source                       = "git@github.com:nullplatform/tofu-modules.git//infrastructure/commons/external_dns?ref=v0.0.1"
   namespace                    = var.externa_dns_namespace
  create_namespace              = true
  version                       = var.external_dns_version
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
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.external_dns](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_secret_v1.external_dns_cloudflare](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudflare_token"></a> [cloudflare\_token](#input\_cloudflare\_token) | n/a | `string` | n/a | yes |
| <a name="input_dns_provider_name"></a> [dns\_provider\_name](#input\_dns\_provider\_name) | dns provider | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_externa_dns_namespace"></a> [externa\_dns\_namespace](#input\_externa\_dns\_namespace) | n/a | `string` | n/a | yes |
| <a name="input_external_dns_version"></a> [external\_dns\_version](#input\_external\_dns\_version) | n/a | `string` | `"1.19.0"` | no |
| <a name="input_extra_args"></a> [extra\_args](#input\_extra\_args) | n/a | `list(string)` | <pre>[<br/>  ""<br/>]</pre> | no |
| <a name="input_kube_context"></a> [kube\_context](#input\_kube\_context) | n/a | `string` | `null` | no |
| <a name="input_kubeconfig_path"></a> [kubeconfig\_path](#input\_kubeconfig\_path) | n/a | `string` | `"~/.kube/config"` | no |
| <a name="input_txt_owner_id"></a> [txt\_owner\_id](#input\_txt\_owner\_id) | n/a | `string` | n/a | yes |
<!-- END_TF_DOCS -->