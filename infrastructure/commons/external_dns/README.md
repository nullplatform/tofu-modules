
# Module: external_dns

This OpenTofu module installs **ExternalDNS** using a Helm chart, enabling dynamic DNS record management through
either **Google Cloud DNS** or **Cloudflare** as your DNS provider.


## Usage

### Cloudflare example

```
module "external_dns" {
  source                       = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/commons/external_dns?ref=fix/change-version-name"
  dns_provider_name            = "cloudflare"
  domain                       = "implementations.nullaps.io"
  external_dns_namespace       = "external-dns"
  extra_args                   = ["--cloudflare-proxied"]
  cloudflare_token             = "my-secret-token"
}
```

### Google Cloud DNS example

```
module "external_dns" {
  source                 = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/commons/external_dns?ref=v1.0.0"
  dns_provider_name      = "google"
  zone_name              = "myprivate"
  project_id             = "myproject"
  domain                 = "myprivate.zone"
  external_dns_namespace = var.external_dns_namespace
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
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.external_dns](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace_v1.external_dns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_secret_v1.external_dns_cloudflare](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_iam_role_arn"></a> [aws\_iam\_role\_arn](#input\_aws\_iam\_role\_arn) | n/a | `any` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `any` | n/a | yes |
| <a name="input_cloudflare_token"></a> [cloudflare\_token](#input\_cloudflare\_token) | n/a | `string` | `null` | no |
| <a name="input_dns_provider_name"></a> [dns\_provider\_name](#input\_dns\_provider\_name) | The DNS provider to use with ExternalDNS | `string` | n/a | yes |
| <a name="input_domain_filters"></a> [domain\_filters](#input\_domain\_filters) | n/a | `string` | n/a | yes |
| <a name="input_external_dns_namespace"></a> [external\_dns\_namespace](#input\_external\_dns\_namespace) | n/a | `string` | `"external-dns"` | no |
| <a name="input_external_dns_version"></a> [external\_dns\_version](#input\_external\_dns\_version) | n/a | `string` | `"1.19.0"` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | The policy to external dns manage the DNS records | `string` | `"upsert-only"` | no |
| <a name="input_private_hosted_zone_id"></a> [private\_hosted\_zone\_id](#input\_private\_hosted\_zone\_id) | n/a | `any` | `null` | no |
| <a name="input_public_hosted_zone_id"></a> [public\_hosted\_zone\_id](#input\_public\_hosted\_zone\_id) | n/a | `any` | `null` | no |
| <a name="input_sources"></a> [sources](#input\_sources) | Array contents the sources to external dns work | `list(string)` | <pre>[<br/>  "crd"<br/>]</pre> | no |
| <a name="input_txt_owner_id"></a> [txt\_owner\_id](#input\_txt\_owner\_id) | n/a | `string` | `"external_dns"` | no |
<!-- END_TF_DOCS -->