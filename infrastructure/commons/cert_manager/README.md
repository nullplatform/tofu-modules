# Module: cert_manager

## Description

Deploys and configures cert-manager with DNS01 ACME challenge support across multiple cloud providers (GCP, AWS, Azure, Cloudflare, OCI)

## Features

- Deploys cert-manager Helm chart with CRDs in a Kubernetes cluster
- Configures cloud-specific DNS01 challenge solvers for automated certificate issuance
- Supports multiple cloud providers including GCP, AWS, Azure, Cloudflare, and OCI
- Manages private domain certificate issuance for internal services
- Configures cloud provider authentication using workload identity or service accounts
- Deploys OCI-specific webhook for cert-manager DNS01 challenges when using Oracle Cloud Infrastructure
- Applies provider-specific service account annotations for seamless cloud integration

## Basic Usage

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v1.38.1"

  account_slug        = "your-account-slug"
  cloud_provider      = "your-cloud-provider"
  hosted_zone_name    = "your-hosted-zone-name"
  private_domain_name = "your-private-domain-name"
}
```

### Usage with GCP Configuration

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v1.38.1"

  account_slug        = "your-account-slug"
  cloud_provider      = "gcp"
  gcp_sa_email        = "your-gcp-sa-email"  # Required when cloud_provider = "gcp"
  hosted_zone_name    = "your-hosted-zone-name"
  private_domain_name = "your-private-domain-name"
  project_id          = "your-project-id"  # Required when cloud_provider = "gcp"
}
```

### Usage with Azure Configuration

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v1.38.1"

  account_slug              = "your-account-slug"
  azure_client_id           = "your-azure-client-id"  # Required when cloud_provider = "azure"
  azure_hosted_zone_name    = "your-azure-hosted-zone-name"  # Required when cloud_provider = "azure"
  azure_resource_group_name = "your-azure-resource-group-name"  # Required when cloud_provider = "azure"
  azure_subscription_id     = "your-azure-subscription-id"  # Required when cloud_provider = "azure"
  azure_tenant_id           = "your-azure-tenant-id"  # Required when cloud_provider = "azure"
  cloud_provider            = "azure"
  hosted_zone_name          = "your-hosted-zone-name"
  private_domain_name       = "your-private-domain-name"
}
```

### Usage with Cloudflare Configuration

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v1.38.1"

  account_slug        = "your-account-slug"
  cloud_provider      = "cloudflare"
  cloudflare_token    = "your-cloudflare-token"  # Required when cloud_provider = "cloudflare"
  hosted_zone_name    = "your-hosted-zone-name"
  private_domain_name = "your-private-domain-name"
}
```

### Usage with AWS Configuration

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v1.38.1"

  account_slug        = "your-account-slug"
  aws_region          = "your-aws-region"  # Required when cloud_provider = "aws"
  aws_sa_arn          = "your-aws-sa-arn"  # Required when cloud_provider = "aws"
  cloud_provider      = "aws"
  hosted_zone_name    = "your-hosted-zone-name"
  private_domain_name = "your-private-domain-name"
}
```

### Usage with OCI Configuration

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v1.38.1"

  account_slug         = "your-account-slug"
  cloud_provider       = "oci"
  hosted_zone_name     = "your-hosted-zone-name"
  oci_compartment_ocid = "your-oci-compartment-ocid"  # Required when cloud_provider = "oci"
  oci_region           = "your-oci-region"  # Required when cloud_provider = "oci"
  private_domain_name  = "your-private-domain-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.cert_manager.id
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
