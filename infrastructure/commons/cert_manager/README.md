
# Modules: cert_manager

This module installs cert manager and nullplatform configuration using helm chart.

Usage:


```
module "cert_manager" {
  source                       = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/commons/cert_manager?ref=v1.0.0"
  namespace                    = var.cert_manager_namespace
  cert_manager_version         = var.cert_manager_version
  cert_manager_config_version  = var.cert_manager_config_version
  namespace                    = var.cert_manager_namespace
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
| <a name="input_account_slug"></a> [account\_slug](#input\_account\_slug) | NullPlatform account slug. | `string` | `""` | no |
| <a name="input_azure_client_id"></a> [azure\_client\_id](#input\_azure\_client\_id) | Azure App (Client) ID for authentication. | `string` | `""` | no |
| <a name="input_azure_client_secret"></a> [azure\_client\_secret](#input\_azure\_client\_secret) | Azure App Client Secret (value). | `string` | `""` | no |
| <a name="input_azure_enabled"></a> [azure\_enabled](#input\_azure\_enabled) | Enable Azure DNS solver in cert-manager. | `bool` | `false` | no |
| <a name="input_azure_hosted_zone_name"></a> [azure\_hosted\_zone\_name](#input\_azure\_hosted\_zone\_name) | Hosted zone name in Azure DNS. | `string` | `""` | no |
| <a name="input_azure_resource_group_name"></a> [azure\_resource\_group\_name](#input\_azure\_resource\_group\_name) | Azure Resource Group that contains the DNS zone. | `string` | `""` | no |
| <a name="input_azure_secret_key"></a> [azure\_secret\_key](#input\_azure\_secret\_key) | Key name inside the Azure Secret that holds the client secret (default 'client-secret'). | `string` | `"client-secret"` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | Azure Subscription ID. | `string` | `""` | no |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | Azure Tenant ID. | `string` | `""` | no |
| <a name="input_cert_manager_config_version"></a> [cert\_manager\_config\_version](#input\_cert\_manager\_config\_version) | n/a | `string` | `"2.10.0"` | no |
| <a name="input_cert_manager_namespace"></a> [cert\_manager\_namespace](#input\_cert\_manager\_namespace) | n/a | `string` | `"cert-manager"` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | n/a | `string` | `"1.18.2"` | no |
| <a name="input_cloudflare_enabled"></a> [cloudflare\_enabled](#input\_cloudflare\_enabled) | Enable Cloudflare DNS-01 solver in cert-manager. | `bool` | `false` | no |
| <a name="input_cloudflare_secret_name"></a> [cloudflare\_secret\_name](#input\_cloudflare\_secret\_name) | Kubernetes Secret name that stores the Cloudflare API Token. | `string` | `"cloudflare-api-token-secret"` | no |
| <a name="input_cloudflare_token"></a> [cloudflare\_token](#input\_cloudflare\_token) | Cloudflare API Token (minimum permissions: Zone:DNS:Edit + Zone:Read). | `string` | `""` | no |
| <a name="input_gcp_enabled"></a> [gcp\_enabled](#input\_gcp\_enabled) | Enable GCP (Cloud DNS) solver in cert-manager. | `bool` | `false` | no |
| <a name="input_gcp_service_account_key"></a> [gcp\_service\_account\_key](#input\_gcp\_service\_account\_key) | Contents of the Service Account JSON for Cloud DNS (use file() if reading from disk). | `string` | `""` | no |
| <a name="input_hosted_zone_name"></a> [hosted\_zone\_name](#input\_hosted\_zone\_name) | Hosted zone name (if applicable). | `string` | `""` | no |
| <a name="input_namespacecontroller_name"></a> [namespacecontroller\_name](#input\_namespacecontroller\_name) | name of the namespace where the certificate will be installed | `string` | `" "` | no |
<!-- END_TF_DOCS -->