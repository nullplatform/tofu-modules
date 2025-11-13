
# Modules: cert_manager

This module installs cert-manager and applies the nullplatform configuration using Helm charts.

## Usage

### Basic example

```hcl
module "cert_manager" {
  source                       = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/commons/cert_manager?ref=1.0.0"


  #Azure DNS configuration
  azure_enabled                = true
  azure_subscription_id        = var.subscription_id
  azure_resource_group_name    = var.resource_group_name
  azure_client_id              = var.azure_client_id
  azure_client_secret          = var.azure_client_secret
  azure_tenant_id              = var.azure_tenant_id
  azure_hosted_zone_name       = var.azure_hosted_zone_name
  gcp_enabled                  = false
  cloudflare_enabled            = false

  #Cloudflare DNS configuration
  cloudflare_enabled           = true
  cloudflare_secret_name       = var.cloudflare_secret_name
  cloudflare_token             = var.cloudflare_token
  azure_subscription_id        = var.azure_subscription_id
  gcp_enabled                  = false
  azure_enabled                = false

  #GCP Cloud DNS configuration
  gcp_enabled                  = var.gcp_enabled
  gcp_service_account_key      = var.gcp_service_account_key

  hosted_zone_name             = var.hosted_zone_name
  account_slug                 = "var.account_slug"

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
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cert_manager_config](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_slug"></a> [account\_slug](#input\_account\_slug) | The nullplatform account slug. | `string` | `""` | no |
| <a name="input_azure_client_id"></a> [azure\_client\_id](#input\_azure\_client\_id) | The Azure application (client) ID for authentication. | `string` | `""` | no |
| <a name="input_azure_client_secret"></a> [azure\_client\_secret](#input\_azure\_client\_secret) | The Azure application client secret value. | `string` | `""` | no |
| <a name="input_azure_enabled"></a> [azure\_enabled](#input\_azure\_enabled) | Whether to enable the Azure DNS solver in cert-manager. | `bool` | `false` | no |
| <a name="input_azure_hosted_zone_name"></a> [azure\_hosted\_zone\_name](#input\_azure\_hosted\_zone\_name) | The hosted zone name in Azure DNS. | `string` | `""` | no |
| <a name="input_azure_resource_group_name"></a> [azure\_resource\_group\_name](#input\_azure\_resource\_group\_name) | The name of the Azure resource group that contains the DNS zone. | `string` | `""` | no |
| <a name="input_azure_secret_key"></a> [azure\_secret\_key](#input\_azure\_secret\_key) | The key name inside the Azure secret that holds the client secret (default: 'client-secret'). | `string` | `"client-secret"` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | The Azure subscription ID. | `string` | `""` | no |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | The Azure tenant ID. | `string` | `""` | no |
| <a name="input_cert_manager_config_version"></a> [cert\_manager\_config\_version](#input\_cert\_manager\_config\_version) | n/a | `string` | `"2.10.0"` | no |
| <a name="input_cert_manager_namespace"></a> [cert\_manager\_namespace](#input\_cert\_manager\_namespace) | n/a | `string` | `"cert-manager"` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | n/a | `string` | `"1.18.2"` | no |
| <a name="input_cloudflare_enabled"></a> [cloudflare\_enabled](#input\_cloudflare\_enabled) | Whether to enable the Cloudflare DNS-01 solver in cert-manager. | `bool` | `false` | no |
| <a name="input_cloudflare_secret_name"></a> [cloudflare\_secret\_name](#input\_cloudflare\_secret\_name) | The name of the Kubernetes secret that stores the Cloudflare API token. | `string` | `"cloudflare-api-token-secret"` | no |
| <a name="input_cloudflare_token"></a> [cloudflare\_token](#input\_cloudflare\_token) | The Cloudflare API token (minimum permissions: Zone:DNS:Edit and Zone:Read). | `string` | `""` | no |
| <a name="input_gcp_enabled"></a> [gcp\_enabled](#input\_gcp\_enabled) | Whether to enable the GCP (Cloud DNS) solver in cert-manager. | `bool` | `false` | no |
| <a name="input_gcp_service_account_key"></a> [gcp\_service\_account\_key](#input\_gcp\_service\_account\_key) | The contents of the service account JSON for Cloud DNS (use file() if reading from disk). | `string` | `""` | no |
| <a name="input_hosted_zone_name"></a> [hosted\_zone\_name](#input\_hosted\_zone\_name) | The hosted zone name (if applicable). | `string` | `""` | no |
<!-- END_TF_DOCS -->
