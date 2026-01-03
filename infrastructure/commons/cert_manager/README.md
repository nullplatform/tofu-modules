
# Modules: cert_manager

This module installs cert-manager and applies the nullplatform configuration using Helm charts.

## Usage
<!-- BEGIN_MODULE_USAGE -->

### AWS example

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v1.0.0"

  cloud_provider      = "aws"
  aws_sa_arn          = var.aws_sa_arn
  aws_region          = var.aws_region
  hosted_zone_name    = var.hosted_zone_name
  private_domain_name = var.private_domain_name
  account_slug        = var.account_slug
}
```

### Azure example

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v1.0.0"

  cloud_provider            = "azure"
  azure_client_id           = var.azure_client_id
  azure_subscription_id     = var.azure_subscription_id
  azure_resource_group_name = var.azure_resource_group_name
  azure_tenant_id           = var.azure_tenant_id
  azure_hosted_zone_name    = var.azure_hosted_zone_name
  hosted_zone_name          = var.hosted_zone_name
  private_domain_name       = var.private_domain_name
  account_slug              = var.account_slug
}
```

### GCP example

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v1.0.0"

  cloud_provider      = "gcp"
  gcp_sa_email        = var.gcp_sa_email
  project_id          = var.project_id
  hosted_zone_name    = var.hosted_zone_name
  private_domain_name = var.private_domain_name
  account_slug        = var.account_slug
}
```

### Cloudflare example

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v1.0.0"

  cloud_provider      = "cloudflare"
  cloudflare_token    = var.cloudflare_token
  hosted_zone_name    = var.hosted_zone_name
  private_domain_name = var.private_domain_name
  account_slug        = var.account_slug
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

## Resources

| Name | Type |
|------|------|
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cert_manager_config](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_slug"></a> [account\_slug](#input\_account\_slug) | The nullplatform account slug. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region. | `string` | `""` | no |
| <a name="input_aws_sa_arn"></a> [aws\_sa\_arn](#input\_aws\_sa\_arn) | The AWS IAM role ARN for cert-manager. | `string` | `""` | no |
| <a name="input_azure_client_id"></a> [azure\_client\_id](#input\_azure\_client\_id) | The Azure client ID for cert-manager. | `string` | `""` | no |
| <a name="input_azure_hosted_zone_name"></a> [azure\_hosted\_zone\_name](#input\_azure\_hosted\_zone\_name) | The hosted zone name in Azure DNS. | `string` | `""` | no |
| <a name="input_azure_resource_group_name"></a> [azure\_resource\_group\_name](#input\_azure\_resource\_group\_name) | The name of the Azure resource group that contains the DNS zone. | `string` | `""` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | The Azure subscription ID. | `string` | `""` | no |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | The Azure tenant ID. | `string` | `""` | no |
| <a name="input_cert_manager_config_version"></a> [cert\_manager\_config\_version](#input\_cert\_manager\_config\_version) | The version of the cert-manager configuration Helm chart | `string` | `"2.28.0"` | no |
| <a name="input_cert_manager_namespace"></a> [cert\_manager\_namespace](#input\_cert\_manager\_namespace) | The Kubernetes namespace where cert-manager will be deployed | `string` | `"cert-manager"` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | The version of cert-manager Helm chart to deploy | `string` | `"1.18.2"` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | El proveedor de nube a utilizar: gcp, azure, aws, o cloudflare | `string` | n/a | yes |
| <a name="input_cloudflare_secret_name"></a> [cloudflare\_secret\_name](#input\_cloudflare\_secret\_name) | The name of the Kubernetes secret that stores the Cloudflare API token. | `string` | `"cloudflare-api-token-secret"` | no |
| <a name="input_cloudflare_token"></a> [cloudflare\_token](#input\_cloudflare\_token) | The Cloudflare API token (minimum permissions: Zone:DNS:Edit and Zone:Read). | `string` | `""` | no |
| <a name="input_gcp_sa_email"></a> [gcp\_sa\_email](#input\_gcp\_sa\_email) | The GCP service account email for cert-manager | `string` | `""` | no |
| <a name="input_hosted_zone_name"></a> [hosted\_zone\_name](#input\_hosted\_zone\_name) | The hosted zone name (if applicable). | `string` | n/a | yes |
| <a name="input_private_domain_name"></a> [private\_domain\_name](#input\_private\_domain\_name) | The private domain name for internal certificate issuance | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID for cert-manager DNS01 solver | `string` | `""` | no |
<!-- END_TF_DOCS -->
