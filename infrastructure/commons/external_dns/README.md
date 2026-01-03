
# Module: external_dns

This OpenTofu module installs **ExternalDNS** using a Helm chart, enabling dynamic DNS record management through
either **AWS Route53** or **Cloudflare** as your DNS provider.


## Usage
<!-- BEGIN_MODULE_USAGE -->

### AWS example

```hcl
module "external_dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/external_dns?ref=v1.0.0"

  dns_provider_name      = "aws"
  aws_region             = var.aws_region
  aws_iam_role_arn       = var.aws_iam_role_arn
  public_hosted_zone_id  = var.public_hosted_zone_id
  private_hosted_zone_id = var.private_hosted_zone_id
  domain_filters         = var.domain_filters
}
```

### Cloudflare example

```hcl
module "external_dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/external_dns?ref=v1.0.0"

  dns_provider_name = "cloudflare"
  cloudflare_token  = var.cloudflare_token
  domain_filters    = var.domain_filters
  aws_region        = var.aws_region
}
```

<!-- END_MODULE_USAGE -->
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
| <a name="input_aws_iam_role_arn"></a> [aws\_iam\_role\_arn](#input\_aws\_iam\_role\_arn) | The IAM role ARN for ExternalDNS to assume for Route53 access (required when dns\_provider\_name is 'aws') | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region where the Route53 hosted zones are located | `string` | n/a | yes |
| <a name="input_cloudflare_token"></a> [cloudflare\_token](#input\_cloudflare\_token) | The Cloudflare API token for DNS management (required when dns\_provider\_name is 'cloudflare') | `string` | `null` | no |
| <a name="input_dns_provider_name"></a> [dns\_provider\_name](#input\_dns\_provider\_name) | The DNS provider to use with ExternalDNS | `string` | n/a | yes |
| <a name="input_domain_filters"></a> [domain\_filters](#input\_domain\_filters) | The domain filter to limit ExternalDNS to manage DNS records only for specific domains | `string` | n/a | yes |
| <a name="input_external_dns_namespace"></a> [external\_dns\_namespace](#input\_external\_dns\_namespace) | The Kubernetes namespace where ExternalDNS will be deployed | `string` | `"external-dns"` | no |
| <a name="input_external_dns_version"></a> [external\_dns\_version](#input\_external\_dns\_version) | The version of ExternalDNS Helm chart to deploy | `string` | `"1.19.0"` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | The policy to external dns manage the DNS records | `string` | `"upsert-only"` | no |
| <a name="input_private_hosted_zone_id"></a> [private\_hosted\_zone\_id](#input\_private\_hosted\_zone\_id) | The Route53 private hosted zone ID for ExternalDNS to manage (required when dns\_provider\_name is 'aws') | `string` | `null` | no |
| <a name="input_public_hosted_zone_id"></a> [public\_hosted\_zone\_id](#input\_public\_hosted\_zone\_id) | The Route53 public hosted zone ID for ExternalDNS to manage (required when dns\_provider\_name is 'aws') | `string` | `null` | no |
| <a name="input_sources"></a> [sources](#input\_sources) | Array contents the sources to external dns work | `list(string)` | <pre>[<br/>  "crd"<br/>]</pre> | no |
| <a name="input_txt_owner_id"></a> [txt\_owner\_id](#input\_txt\_owner\_id) | The TXT owner ID used by ExternalDNS to identify DNS records it manages | `string` | `"external_dns"` | no |
<!-- END_TF_DOCS -->