
# Modules: external_dns

This OpenTofu module installs ExternalDNS using a Helm chart, allowing you to use either Google Cloud DNS or Cloudflare as your DNS provider.


Usage:

Cloudflare example:

```
module "external_dns" {
  source                       = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/commons/external_dns?ref=fix/change-version-name"
  dns_provider_name            = "cloudflare"
  domain                       = "implementations.nullaps.io"
  external_dns_namespace       = "external-dns"
  extra_args                   = ["--cloudflare-proxied"]
  cloudflare_token             = "mi-token-magico"
}
```

Google (CloudDNS) example:

```
module "external_dns" {
  source                 = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/commons/external_dns?ref=v1.0.0"
  zone_name              ="myprivate"
  project_id             = "myproject"
  dns_provider_name      = "google"
  domain                 = "myprivate.zone"
  external_dns_namespace = var.externa_dns_namespace
  external_dns_version   = var.external_dns_version
  extra_args             = ["--google-zone-visibility=private"]

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
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Resources

| Name | Type |
|------|------|
| [google_project_iam_member.external_dns_dns_admin](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.external_dns](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_member.wi_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [helm_release.external_dns](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_secret_v1.external_dns_cloudflare](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudflare_token"></a> [cloudflare\_token](#input\_cloudflare\_token) | n/a | `string` | `" "` | no |
| <a name="input_dns_provider_name"></a> [dns\_provider\_name](#input\_dns\_provider\_name) | dns provider | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_external_dns_namespace"></a> [external\_dns\_namespace](#input\_external\_dns\_namespace) | n/a | `string` | n/a | yes |
| <a name="input_external_dns_version"></a> [external\_dns\_version](#input\_external\_dns\_version) | n/a | `string` | `"1.19.0"` | no |
| <a name="input_extra_args"></a> [extra\_args](#input\_extra\_args) | n/a | `list(string)` | <pre>[<br/>  ""<br/>]</pre> | no |
| <a name="input_gsa_name"></a> [gsa\_name](#input\_gsa\_name) | n/a | `string` | `"external-dns"` | no |
| <a name="input_ksa_name"></a> [ksa\_name](#input\_ksa\_name) | n/a | `string` | `"external-dns"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | `" "` | no |
| <a name="input_txt_owner_id"></a> [txt\_owner\_id](#input\_txt\_owner\_id) | n/a | `string` | `"external_dns"` | no |
| <a name="input_zone_name"></a> [zone\_name](#input\_zone\_name) | n/a | `string` | `" "` | no |
<!-- END_TF_DOCS -->