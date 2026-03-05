# Module: cert_manager

## Description

Deploys and configures cert-manager on Kubernetes with multi-cloud DNS provider support for automated TLS certificate management

## Features

- Deploys cert-manager Helm chart with CRDs and service account configuration
- Configures DNS01 challenge solvers for multiple cloud providers (GCP, AWS, Azure, Cloudflare, OCI)
- Creates provider-specific IAM role annotations and workload identity bindings
- Deploys cert-manager configuration chart with custom cluster issuers
- Installs OCI webhook for cert-manager when using Oracle Cloud Infrastructure
- Supports both public and private domain certificate issuance
- Configures recursive DNS nameservers for DNS01 challenge resolution

## Basic Usage

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v1.42.0"

  account_slug        = var.account_slug
  cloud_provider      = var.cloud_provider
  hosted_zone_name    = local.domain_name
  private_domain_name = "private.${local.domain_name}"
}
```

### Usage with GCP Provider

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v1.42.0"

  account_slug        = var.account_slug
  cloud_provider      = "gcp"
  gcp_sa_email        = var.gcp_sa_email  # Required when cloud_provider = "gcp"
  hosted_zone_name    = local.domain_name
  private_domain_name = "private.${local.domain_name}"
  project_id          = var.gcp_project_id  # Required when cloud_provider = "gcp"
}
```

### Usage with Azure Provider

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v1.42.0"

  account_slug              = var.account_slug
  azure_client_id           = var.azure_client_id  # Required when cloud_provider = "azure"
  azure_hosted_zone_name    = local.domain_name  # Required when cloud_provider = "azure"
  azure_resource_group_name = var.azure_resource_group  # Required when cloud_provider = "azure"
  azure_subscription_id     = var.azure_subscription_id  # Required when cloud_provider = "azure"
  azure_tenant_id           = var.azure_tenant_id  # Required when cloud_provider = "azure"
  cloud_provider            = "azure"
  hosted_zone_name          = local.domain_name
  private_domain_name       = "private.${local.domain_name}"
}
```

### Usage with Cloudflare Provider

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v1.42.0"

  account_slug        = var.account_slug
  cloud_provider      = "cloudflare"
  cloudflare_token    = var.cloudflare_token  # Required when cloud_provider = "cloudflare"
  hosted_zone_name    = local.domain_name
  private_domain_name = "private.${local.domain_name}"
}
```

### Usage with AWS Provider

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v1.42.0"

  account_slug        = var.account_slug
  aws_region          = var.aws_region  # Required when cloud_provider = "aws"
  aws_sa_arn          = module.cert_manager_iam.nullplatform_cert_manager_role_arn  # Required when cloud_provider = "aws"
  cloud_provider      = "aws"
  hosted_zone_name    = local.domain_name
  private_domain_name = "private.${local.domain_name}"
}
```

### Usage with OCI Provider

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v1.42.0"

  account_slug         = var.account_slug
  cloud_provider       = "oci"
  hosted_zone_name     = local.domain_name
  oci_compartment_ocid = var.compartment_id  # Required when cloud_provider = "oci"
  oci_region           = var.oci_region  # Required when cloud_provider = "oci"
  private_domain_name  = "private.${local.domain_name}"
}
```

## Using Outputs

```hcl
# This module deploys cert-manager and cluster issuers via Helm and has no outputs.
# Once deployed, cert-manager automatically issues TLS certificates for your domains.
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
| [helm_release.cert_manager_webhook_oci](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

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
| <a name="input_cert_manager_config_version"></a> [cert\_manager\_config\_version](#input\_cert\_manager\_config\_version) | The version of the cert-manager configuration Helm chart | `string` | `"2.29.2"` | no |
| <a name="input_cert_manager_namespace"></a> [cert\_manager\_namespace](#input\_cert\_manager\_namespace) | The Kubernetes namespace where cert-manager will be deployed | `string` | `"cert-manager"` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | The version of cert-manager Helm chart to deploy | `string` | `"1.18.2"` | no |
| <a name="input_cert_manager_webhook_oci_namespace"></a> [cert\_manager\_webhook\_oci\_namespace](#input\_cert\_manager\_webhook\_oci\_namespace) | n/a | `string` | `"cert-manager"` | no |
| <a name="input_cert_manager_webhook_oci_version"></a> [cert\_manager\_webhook\_oci\_version](#input\_cert\_manager\_webhook\_oci\_version) | #########web hook | `string` | `"1.4.1"` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | The cloud provider to use: gcp, azure, aws, cloudflare, or oci | `string` | n/a | yes |
| <a name="input_cloudflare_secret_name"></a> [cloudflare\_secret\_name](#input\_cloudflare\_secret\_name) | The name of the Kubernetes secret that stores the Cloudflare API token. | `string` | `"cloudflare-api-token-secret"` | no |
| <a name="input_cloudflare_token"></a> [cloudflare\_token](#input\_cloudflare\_token) | The Cloudflare API token (minimum permissions: Zone:DNS:Edit and Zone:Read). | `string` | `""` | no |
| <a name="input_gcp_sa_email"></a> [gcp\_sa\_email](#input\_gcp\_sa\_email) | The GCP service account email for cert-manager | `string` | `""` | no |
| <a name="input_hosted_zone_name"></a> [hosted\_zone\_name](#input\_hosted\_zone\_name) | The hosted zone name (if applicable). | `string` | n/a | yes |
| <a name="input_oci_compartment_ocid"></a> [oci\_compartment\_ocid](#input\_oci\_compartment\_ocid) | The OCID of the OCI compartment where the DNS zone is located. | `string` | `""` | no |
| <a name="input_oci_region"></a> [oci\_region](#input\_oci\_region) | The OCI region for DNS operations (e.g., us-ashburn-1). | `string` | `""` | no |
| <a name="input_oci_sa_ocid"></a> [oci\_sa\_ocid](#input\_oci\_sa\_ocid) | The OCID of the OCI workload identity principal for cert-manager. Optional when using Dynamic Groups with Workload Identity. | `string` | `""` | no |
| <a name="input_private_domain_name"></a> [private\_domain\_name](#input\_private\_domain\_name) | The private domain name for internal certificate issuance | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID for cert-manager DNS01 solver | `string` | `""` | no |
<!-- END_TF_DOCS -->
