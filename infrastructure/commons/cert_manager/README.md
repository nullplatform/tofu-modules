
# Modules: cert_manager

This module installs cert manager and nullplatform configuration using helm chart.

Usage:


```
module "cert_manager" {
  source                       = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/commons/cert_manager?ref=1.0.0"
  
  #DNS in Azure Configuration
  azure_enabled                = true
  azure_subscription_id        = var.subscription_id
  azure_resource_group_name    = var.resource_group_name
  azure_client_id              = var.azure_client_id
  azure_client_secret          = var.azure_client_secret
  azure_tenant_id              = var.azure_tenant_id
  azure_hosted_zone_name       = var.azure_hosted_zone_name

  #DNS in Cloudflare Configuration
  cloudflare_enabled           = true
  cloudflare_secret_name       = var.cloudflare_secret_name
  cloudflare_token             = var.cloudflare_token

  #DNS in GCP Configuration
  gcp_enabled                  = var.gcp_enabled
  gcp_service_account_key      = var.gcp_service_account_key

  #Optional
  hosted_zone_name             = var.hosted_zone_name
  account_slug                 = var.account_slug
  namespacecontroller          = var.namespacecontroller
  

}


```


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
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

### General

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_slug"></a> [account\_slug](#input\_account\_slug) | NullPlatform account slug | `string` | `""` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Cert-manager Helm chart version | `string` | `"1.18.2"` | no |
| <a name="input_cert_manager_config_version"></a> [cert\_manager\_config\_version](#input\_cert\_manager\_config\_version) | Cert-manager configuration chart version | `string` | `"2.10.0"` | no |
| <a name="input_cert_manager_namespace"></a> [cert\_manager\_namespace](#input\_cert\_manager\_namespace) | Kubernetes namespace for cert-manager | `string` | `"cert-manager"` | no |
| <a name="input_hosted_zone_name"></a> [hosted\_zone\_name](#input\_hosted\_zone\_name) | Hosted zone name for DNS validation | `string` | `""` | no |

### Azure DNS

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_enabled"></a> [azure\_enabled](#input\_azure\_enabled) | Enable Azure DNS solver | `bool` | `false` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | Azure Subscription ID | `string` | `""` | no |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | Azure Tenant ID | `string` | `""` | no |
| <a name="input_azure_client_id"></a> [azure\_client\_id](#input\_azure\_client\_id) | Azure App (Client) ID | `string` | `""` | no |
| <a name="input_azure_client_secret"></a> [azure\_client\_secret](#input\_azure\_client\_secret) | Azure Client Secret | `string` | `""` | no |
| <a name="input_azure_resource_group_name"></a> [azure\_resource\_group\_name](#input\_azure\_resource\_group\_name) | Azure Resource Group containing DNS zone | `string` | `""` | no |
| <a name="input_azure_hosted_zone_name"></a> [azure\_hosted\_zone\_name](#input\_azure\_hosted\_zone\_name) | Azure DNS zone name | `string` | `""` | no |
| <a name="input_azure_secret_key"></a> [azure\_secret\_key](#input\_azure\_secret\_key) | Key name for Azure Secret | `string` | `"client-secret"` | no |

### Cloudflare DNS

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudflare_enabled"></a> [cloudflare\_enabled](#input\_cloudflare\_enabled) | Enable Cloudflare DNS-01 solver | `bool` | `false` | no |
| <a name="input_cloudflare_token"></a> [cloudflare\_token](#input\_cloudflare\_token) | Cloudflare API Token (Zone:DNS:Edit + Zone:Read permissions) | `string` | `""` | no |
| <a name="input_cloudflare_secret_name"></a> [cloudflare\_secret\_name](#input\_cloudflare\_secret\_name) | Kubernetes Secret name for Cloudflare token | `string` | `"cloudflare-api-token-secret"` | no |

### GCP Cloud DNS

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gcp_enabled"></a> [gcp\_enabled](#input\_gcp\_enabled) | Enable GCP Cloud DNS solver | `bool` | `false` | no |
| <a name="input_gcp_service_account_key"></a> [gcp\_service\_account\_key](#input\_gcp\_service\_account\_key) | GCP Service Account JSON key contents | `string` | `""` | no |

## Outputs

No outputs.

<!-- END_TF_DOCS -->
