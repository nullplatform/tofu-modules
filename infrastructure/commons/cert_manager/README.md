# Module: cert_manager

## Description

Deploys cert-manager and its DNS01 solver configuration via Helm across multiple cloud providers (GCP, AWS, Azure, Cloudflare, OCI) with provider-specific service account annotations and workload identity support

## Architecture

The module creates two core helm_release resources: cert-manager from charts.jetstack.io and nullplatform-cert-manager-config from the nullplatform Helm registry, with the config release depending on cert-manager. A third helm_release for cert-manager-webhook-oci is conditionally created (count = 1) only when cloud_provider is 'oci'. Provider-specific values are assembled in locals.tf by merging a common context with a provider_context map and rendering provider-specific YAML templates, then injecting them into the helm_release values blocks. Service account annotations are dynamically constructed per provider (e.g., eks.amazonaws.com/role-arn for AWS IRSA, iam.gke.io/gcp-service-account for GCP, azure.workload.identity/client-id for Azure) and merged into the cert_manager_values local.

## Features

- Deploys cert-manager Helm chart with CRDs enabled and pinned version via helm_release
- Deploys provider-specific cert-manager configuration chart with templated DNS01 solver values per cloud provider
- Configures service account annotations dynamically for GCP Workload Identity, AWS IRSA or Pod Identity, Azure Workload Identity, and OCI Workload Identity
- Conditionally deploys cert-manager-webhook-oci helm_release when cloud_provider is set to oci
- Supports Azure Workload Identity with pod labels injection and falls back to Service Principal auth when disabled
- Enforces pinned Helm chart versions for cert-manager, cert-manager-config, and OCI webhook via validation rules

## Basic Usage

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v9.16.0"

  account_slug                = "your-account-slug"
  cert_manager_config_version = "your-cert-manager-config-version"
  cert_manager_version        = "your-cert-manager-version"
  cloud_provider              = "your-cloud-provider"
  hosted_zone_name            = "your-hosted-zone-name"
  private_domain_name         = "your-private-domain-name"
}
```

### Usage with GCP Provider

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v9.16.0"

  account_slug                = "your-account-slug"
  cert_manager_config_version = "your-cert-manager-config-version"
  cert_manager_version        = "your-cert-manager-version"
  cloud_provider              = "gcp"
  hosted_zone_name            = "your-hosted-zone-name"
  private_domain_name         = "your-private-domain-name"
}
```

### Usage with Azure Provider

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v9.16.0"

  account_slug                = "your-account-slug"
  cert_manager_config_version = "your-cert-manager-config-version"
  cert_manager_version        = "your-cert-manager-version"
  cloud_provider              = "azure"
  hosted_zone_name            = "your-hosted-zone-name"
  private_domain_name         = "your-private-domain-name"
}
```

### Usage with Cloudflare Provider

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v9.16.0"

  account_slug                = "your-account-slug"
  cert_manager_config_version = "your-cert-manager-config-version"
  cert_manager_version        = "your-cert-manager-version"
  cloud_provider              = "cloudflare"
  hosted_zone_name            = "your-hosted-zone-name"
  private_domain_name         = "your-private-domain-name"
}
```

### Usage with AWS Provider

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v9.16.0"

  account_slug                = "your-account-slug"
  cert_manager_config_version = "your-cert-manager-config-version"
  cert_manager_version        = "your-cert-manager-version"
  cloud_provider              = "aws"
  hosted_zone_name            = "your-hosted-zone-name"
  private_domain_name         = "your-private-domain-name"
}
```

### Usage with OCI Provider

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v9.16.0"

  account_slug                     = "your-account-slug"
  cert_manager_config_version      = "your-cert-manager-config-version"
  cert_manager_version             = "your-cert-manager-version"
  cert_manager_webhook_oci_version = "your-cert-manager-webhook-oci-version"  # Required when cloud_provider = "oci"
  cloud_provider                   = "oci"
  hosted_zone_name                 = "your-hosted-zone-name"
  private_domain_name              = "your-private-domain-name"
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
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.1.1 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cert_manager_config](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cert_manager_webhook_oci](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [terraform_data.provider_validation](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_slug"></a> [account\_slug](#input\_account\_slug) | The nullplatform account slug. | `string` | n/a | yes |
| <a name="input_aws_identity_mode"></a> [aws\_identity\_mode](#input\_aws\_identity\_mode) | AWS identity mechanism for the cert-manager service account: "irsa" sets the eks.amazonaws.com/role-arn annotation; "pod\_identity" omits it (EKS Pod Identity injects credentials via the Pod Identity agent). | `string` | `"irsa"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region. | `string` | `""` | no |
| <a name="input_aws_sa_arn"></a> [aws\_sa\_arn](#input\_aws\_sa\_arn) | The AWS IAM role ARN for cert-manager. | `string` | `""` | no |
| <a name="input_azure_client_id"></a> [azure\_client\_id](#input\_azure\_client\_id) | The Azure client ID for cert-manager. | `string` | `""` | no |
| <a name="input_azure_client_secret"></a> [azure\_client\_secret](#input\_azure\_client\_secret) | Azure AD client secret for Service Principal auth (required when cloud\_provider is 'azure' and azure\_workload\_identity\_enabled is false). | `string` | `""` | no |
| <a name="input_azure_federated_credential_id"></a> [azure\_federated\_credential\_id](#input\_azure\_federated\_credential\_id) | Resource ID of the Azure federated identity credential for cert-manager (required when cloud\_provider is 'azure' and azure\_workload\_identity\_enabled is true). Pass module.iam\_cert\_manager.id to enforce dependency ordering. | `string` | `""` | no |
| <a name="input_azure_hosted_zone_name"></a> [azure\_hosted\_zone\_name](#input\_azure\_hosted\_zone\_name) | The hosted zone name in Azure DNS. | `string` | `""` | no |
| <a name="input_azure_resource_group_name"></a> [azure\_resource\_group\_name](#input\_azure\_resource\_group\_name) | The name of the Azure resource group that contains the DNS zone. | `string` | `""` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | The Azure subscription ID. | `string` | `""` | no |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | The Azure tenant ID. | `string` | `""` | no |
| <a name="input_azure_workload_identity_enabled"></a> [azure\_workload\_identity\_enabled](#input\_azure\_workload\_identity\_enabled) | Enable Workload Identity for Azure DNS solver. When false, Service Principal auth is used and azure\_client\_secret is required. | `bool` | `true` | no |
| <a name="input_cert_manager_config_version"></a> [cert\_manager\_config\_version](#input\_cert\_manager\_config\_version) | No default: every install pins this deliberately — see VERSIONS.md. The version of the cert-manager configuration Helm chart | `string` | n/a | yes |
| <a name="input_cert_manager_namespace"></a> [cert\_manager\_namespace](#input\_cert\_manager\_namespace) | The Kubernetes namespace where cert-manager will be deployed | `string` | `"cert-manager"` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | No default: every install pins this deliberately — see VERSIONS.md. The version of cert-manager Helm chart to deploy. Was declared but never wired to the helm\_release, so installs tracked whatever the chart repository served; the default is the version that resolved to as of 2026-08-27, which keeps behaviour unchanged while removing the drift. | `string` | n/a | yes |
| <a name="input_cert_manager_webhook_oci_namespace"></a> [cert\_manager\_webhook\_oci\_namespace](#input\_cert\_manager\_webhook\_oci\_namespace) | Kubernetes namespace where the cert-manager OCI webhook is deployed | `string` | `"cert-manager"` | no |
| <a name="input_cert_manager_webhook_oci_version"></a> [cert\_manager\_webhook\_oci\_version](#input\_cert\_manager\_webhook\_oci\_version) | No default: every install pins this deliberately — see VERSIONS.md. Required when cloud\_provider is 'oci', ignored otherwise. Helm chart version for the cert-manager OCI webhook | `string` | `null` | no |
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

<!-- BEGIN_AI_METADATA
{
  "name": "cert_manager",
  "description": "Deploys cert-manager and its DNS01 solver configuration via Helm across multiple cloud providers (GCP, AWS, Azure, Cloudflare, OCI) with provider-specific service account annotations and workload identity support",
  "architecture": "The module creates two core helm_release resources: cert-manager from charts.jetstack.io and nullplatform-cert-manager-config from the nullplatform Helm registry, with the config release depending on cert-manager. A third helm_release for cert-manager-webhook-oci is conditionally created (count = 1) only when cloud_provider is 'oci'. Provider-specific values are assembled in locals.tf by merging a common context with a provider_context map and rendering provider-specific YAML templates, then injecting them into the helm_release values blocks. Service account annotations are dynamically constructed per provider (e.g., eks.amazonaws.com/role-arn for AWS IRSA, iam.gke.io/gcp-service-account for GCP, azure.workload.identity/client-id for Azure) and merged into the cert_manager_values local.",
  "features": [
    "Deploys cert-manager Helm chart with CRDs enabled and pinned version via helm_release",
    "Deploys provider-specific cert-manager configuration chart with templated DNS01 solver values per cloud provider",
    "Configures service account annotations dynamically for GCP Workload Identity, AWS IRSA or Pod Identity, Azure Workload Identity, and OCI Workload Identity",
    "Conditionally deploys cert-manager-webhook-oci helm_release when cloud_provider is set to oci",
    "Supports Azure Workload Identity with pod labels injection and falls back to Service Principal auth when disabled",
    "Enforces pinned Helm chart versions for cert-manager, cert-manager-config, and OCI webhook via validation rules"
  ],
  "inputs": [
    {
      "name": "private_domain_name",
      "description": "The private domain name for internal certificate issuance",
      "required": true
    },
    {
      "name": "hosted_zone_name",
      "description": "The hosted zone name (if applicable).",
      "required": true
    },
    {
      "name": "account_slug",
      "description": "The nullplatform account slug.",
      "required": true
    },
    {
      "name": "cloud_provider",
      "description": "The cloud provider to use: gcp, azure, aws, cloudflare, or oci",
      "required": true
    },
    {
      "name": "cert_manager_version",
      "description": "No default: every install pins this deliberately — see VERSIONS.md. The version of cert-manager Helm chart to deploy. Was declared but never wired to the helm_release, so installs tracked whatever the chart repository served; the default is the version that resolved to as of 2026-08-27, which keeps behaviour unchanged while removing the drift.",
      "required": true
    },
    {
      "name": "cert_manager_config_version",
      "description": "No default: every install pins this deliberately — see VERSIONS.md. The version of the cert-manager configuration Helm chart",
      "required": true
    },
    {
      "name": "aws_identity_mode",
      "description": "AWS identity mechanism for the cert-manager service account: \\",
      "required": false
    },
    {
      "name": "cert_manager_webhook_oci_version",
      "description": "No default: every install pins this deliberately — see VERSIONS.md. Required when cloud_provider is 'oci', ignored otherwise. Helm chart version for the cert-manager OCI webhook",
      "required": false
    },
    {
      "name": "gcp_sa_email",
      "description": "The GCP service account email for cert-manager",
      "required": false
    },
    {
      "name": "project_id",
      "description": "The GCP project ID for cert-manager DNS01 solver",
      "required": false
    },
    {
      "name": "aws_sa_arn",
      "description": "The AWS IAM role ARN for cert-manager.",
      "required": false
    },
    {
      "name": "azure_client_id",
      "description": "The Azure client ID for cert-manager.",
      "required": false
    },
    {
      "name": "azure_workload_identity_enabled",
      "description": "Enable Workload Identity for Azure DNS solver. When false, Service Principal auth is used and azure_client_secret is required.",
      "required": false
    },
    {
      "name": "azure_federated_credential_id",
      "description": "Resource ID of the Azure federated identity credential for cert-manager (required when cloud_provider is 'azure' and azure_workload_identity_enabled is true). Pass module.iam_cert_manager.id to enforce dependency ordering.",
      "required": false
    },
    {
      "name": "azure_client_secret",
      "description": "Azure AD client secret for Service Principal auth (required when cloud_provider is 'azure' and azure_workload_identity_enabled is false).",
      "required": false
    },
    {
      "name": "cert_manager_namespace",
      "description": "The Kubernetes namespace where cert-manager will be deployed",
      "required": false
    },
    {
      "name": "azure_subscription_id",
      "description": "The Azure subscription ID.",
      "required": false
    },
    {
      "name": "azure_resource_group_name",
      "description": "The name of the Azure resource group that contains the DNS zone.",
      "required": false
    },
    {
      "name": "azure_tenant_id",
      "description": "The Azure tenant ID.",
      "required": false
    },
    {
      "name": "azure_hosted_zone_name",
      "description": "The hosted zone name in Azure DNS.",
      "required": false
    },
    {
      "name": "cloudflare_secret_name",
      "description": "The name of the Kubernetes secret that stores the Cloudflare API token.",
      "required": false
    },
    {
      "name": "cloudflare_token",
      "description": "The Cloudflare API token (minimum permissions: Zone:DNS:Edit and Zone:Read).",
      "required": false
    },
    {
      "name": "aws_region",
      "description": "The AWS region.",
      "required": false
    },
    {
      "name": "oci_compartment_ocid",
      "description": "The OCID of the OCI compartment where the DNS zone is located.",
      "required": false
    },
    {
      "name": "oci_region",
      "description": "The OCI region for DNS operations (e.g., us-ashburn-1).",
      "required": false
    },
    {
      "name": "oci_sa_ocid",
      "description": "The OCID of the OCI workload identity principal for cert-manager. Optional when using Dynamic Groups with Workload Identity.",
      "required": false
    },
    {
      "name": "cert_manager_webhook_oci_namespace",
      "description": "Kubernetes namespace where the cert-manager OCI webhook is deployed",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "c0573d078db907972e00429a9aaa0936"
}
END_AI_METADATA -->
