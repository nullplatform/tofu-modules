# Module: cert_manager

## Description

Deploys cert-manager with multi-cloud DNS provider support for automated TLS certificate management in Kubernetes

## Architecture

Creates three helm_release resources: the core cert-manager chart with CRDs and service account annotations, a nullplatform-cert-manager-config chart that templates provider-specific DNS01 solver configurations from locals, and conditionally an OCI webhook chart. The module merges cloud provider contexts (GCP project_id, Azure client_id/tenant_id, AWS region, Cloudflare token, OCI compartment_ocid) into templated YAML values that configure ClusterIssuer resources with appropriate RBAC annotations (iam.gke.io/gcp-service-account for GCP, eks.amazonaws.com/role-arn for AWS, azure.workload.identity/client-id for Azure, oci.oraclecloud.com/workload-identity-principal for OCI). Each helm_release includes atomic deployment settings with dependency chains ensuring cert-manager deploys before configuration and webhooks.

## Features

- Deploys cert-manager Helm chart with CRDs and configurable namespace isolation
- Configures cloud-specific workload identity annotations for GCP, AWS, Azure, and OCI service accounts
- Templates DNS01 solver configurations per cloud provider using hosted zone and account context
- Deploys provider-specific configuration via nullplatform-cert-manager-config Helm chart
- Installs OCI DNS webhook chart conditionally when cloud_provider is set to oci
- Configures recursive DNS nameservers (8.8.8.8, 1.1.1.1) for DNS01 challenge validation
- Supports private domain certificate issuance alongside public hosted zone certificates

## Basic Usage

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v2.3.0"

  account_slug        = "your-account-slug"
  cloud_provider      = "your-cloud-provider"
  hosted_zone_name    = "your-hosted-zone-name"
  private_domain_name = "your-private-domain-name"
}
```

### Usage with GCP Configuration

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v2.3.0"

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
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v2.3.0"

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
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v2.3.0"

  account_slug           = "your-account-slug"
  cloud_provider         = "cloudflare"
  cloudflare_secret_name = "your-cloudflare-secret-name"  # Required when cloud_provider = "cloudflare"
  cloudflare_token       = "your-cloudflare-token"  # Required when cloud_provider = "cloudflare"
  hosted_zone_name       = "your-hosted-zone-name"
  private_domain_name    = "your-private-domain-name"
}
```

### Usage with AWS Configuration

```hcl
module "cert_manager" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v2.3.0"

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
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v2.3.0"

  account_slug         = "your-account-slug"
  cloud_provider       = "oci"
  hosted_zone_name     = "your-hosted-zone-name"
  oci_compartment_ocid = "your-oci-compartment-ocid"  # Required when cloud_provider = "oci"
  oci_region           = "your-oci-region"  # Required when cloud_provider = "oci"
  oci_sa_ocid          = "your-oci-sa-ocid"  # Required when cloud_provider = "oci"
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
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region. | `string` | `""` | no |
| <a name="input_aws_sa_arn"></a> [aws\_sa\_arn](#input\_aws\_sa\_arn) | The AWS IAM role ARN for cert-manager. | `string` | `""` | no |
| <a name="input_azure_client_id"></a> [azure\_client\_id](#input\_azure\_client\_id) | The Azure client ID for cert-manager. | `string` | `""` | no |
| <a name="input_azure_hosted_zone_name"></a> [azure\_hosted\_zone\_name](#input\_azure\_hosted\_zone\_name) | The hosted zone name in Azure DNS. | `string` | `""` | no |
| <a name="input_azure_resource_group_name"></a> [azure\_resource\_group\_name](#input\_azure\_resource\_group\_name) | The name of the Azure resource group that contains the DNS zone. | `string` | `""` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | The Azure subscription ID. | `string` | `""` | no |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | The Azure tenant ID. | `string` | `""` | no |
| <a name="input_cert_manager_config_version"></a> [cert\_manager\_config\_version](#input\_cert\_manager\_config\_version) | The version of the cert-manager configuration Helm chart | `string` | `"2.35.0"` | no |
| <a name="input_cert_manager_namespace"></a> [cert\_manager\_namespace](#input\_cert\_manager\_namespace) | The Kubernetes namespace where cert-manager will be deployed | `string` | `"cert-manager"` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | The version of cert-manager Helm chart to deploy | `string` | `"1.18.2"` | no |
| <a name="input_cert_manager_webhook_oci_namespace"></a> [cert\_manager\_webhook\_oci\_namespace](#input\_cert\_manager\_webhook\_oci\_namespace) | Kubernetes namespace where the cert-manager OCI webhook is deployed | `string` | `"cert-manager"` | no |
| <a name="input_cert_manager_webhook_oci_version"></a> [cert\_manager\_webhook\_oci\_version](#input\_cert\_manager\_webhook\_oci\_version) | Helm chart version for the cert-manager OCI webhook | `string` | `"1.4.1"` | no |
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
  "description": "Deploys cert-manager with multi-cloud DNS provider support for automated TLS certificate management in Kubernetes",
  "architecture": "Creates three helm_release resources: the core cert-manager chart with CRDs and service account annotations, a nullplatform-cert-manager-config chart that templates provider-specific DNS01 solver configurations from locals, and conditionally an OCI webhook chart. The module merges cloud provider contexts (GCP project_id, Azure client_id/tenant_id, AWS region, Cloudflare token, OCI compartment_ocid) into templated YAML values that configure ClusterIssuer resources with appropriate RBAC annotations (iam.gke.io/gcp-service-account for GCP, eks.amazonaws.com/role-arn for AWS, azure.workload.identity/client-id for Azure, oci.oraclecloud.com/workload-identity-principal for OCI). Each helm_release includes atomic deployment settings with dependency chains ensuring cert-manager deploys before configuration and webhooks.",
  "features": [
    "Deploys cert-manager Helm chart with CRDs and configurable namespace isolation",
    "Configures cloud-specific workload identity annotations for GCP, AWS, Azure, and OCI service accounts",
    "Templates DNS01 solver configurations per cloud provider using hosted zone and account context",
    "Deploys provider-specific configuration via nullplatform-cert-manager-config Helm chart",
    "Installs OCI DNS webhook chart conditionally when cloud_provider is set to oci",
    "Configures recursive DNS nameservers (8.8.8.8, 1.1.1.1) for DNS01 challenge validation",
    "Supports private domain certificate issuance alongside public hosted zone certificates"
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
      "name": "cert_manager_version",
      "description": "The version of cert-manager Helm chart to deploy",
      "required": false
    },
    {
      "name": "cert_manager_namespace",
      "description": "The Kubernetes namespace where cert-manager will be deployed",
      "required": false
    },
    {
      "name": "cert_manager_config_version",
      "description": "The version of the cert-manager configuration Helm chart",
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
      "name": "cert_manager_webhook_oci_version",
      "description": "Helm chart version for the cert-manager OCI webhook",
      "required": false
    },
    {
      "name": "cert_manager_webhook_oci_namespace",
      "description": "Kubernetes namespace where the cert-manager OCI webhook is deployed",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "4ac3fa13fc1ecf081ce4182a81b4e3d3"
}
END_AI_METADATA -->
