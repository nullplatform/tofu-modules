# Module: external_dns

## Description

Deploys ExternalDNS via Helm on Kubernetes with support for Cloudflare, AWS Route53, OCI, and Azure DNS providers

## Architecture

The module creates an optional kubernetes_namespace_v1 resource and a helm_release resource for the external-dns chart from the kubernetes-sigs registry. Provider-specific configurations are assembled in locals.tf by merging a base_config with one of four provider config maps (cloudflare_config, route53_config, oci_config, azure_config) selected by dns_provider_name, then encoded as YAML values passed to the helm_release. Provider secrets (kubernetes_secret_v1 for Cloudflare tokens, OCI config, and Azure config) are created as dependencies that the helm_release waits on before deploying.

## Features

- Deploys ExternalDNS Helm chart with configurable version and namespace into a Kubernetes cluster
- Supports four DNS providers: Cloudflare (API token via Kubernetes secret), AWS Route53 (IRSA with IAM role annotation), OCI (Workload Identity with compartment OCID and zone scope), and Azure (Workload Identity or Service Principal)
- Configures AWS provider with RBAC permissions for DNSEndpoints, Gateways, and HTTPRoutes CRDs
- Mounts OCI and Azure provider credentials as Kubernetes secrets into the ExternalDNS pod via extraVolumes and extraVolumeMounts
- Controls DNS record management behavior via configurable policy (sync, create-only, upsert-only)
- Supports deploying multiple ExternalDNS instances (public and private) in the same cluster via the type variable
- Enables OCI DNS zone scope selection between GLOBAL and PRIVATE with configurable zones cache duration

## Basic Usage

```hcl
module "external_dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/external_dns?ref=v3.2.0"

  dns_provider_name = "your-dns-provider-name"
  domain_filters    = "your-domain-filters"
}
```

### Usage with Cloudflare DNS

```hcl
module "external_dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/external_dns?ref=v3.2.0"

  cloudflare_token  = "your-cloudflare-token"  # Required when dns_provider_name = "cloudflare"
  dns_provider_name = "cloudflare"
  domain_filters    = "your-domain-filters"
}
```

### Usage with AWS Route53 DNS

```hcl
module "external_dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/external_dns?ref=v3.2.0"

  aws_iam_role_arn  = "your-aws-iam-role-arn"  # Required when dns_provider_name = "aws"
  aws_region        = "your-aws-region"  # Required when dns_provider_name = "aws"
  dns_provider_name = "aws"
  domain_filters    = "your-domain-filters"
  zone_id_filter    = "your-zone-id-filter"  # Required when dns_provider_name = "aws"
  zone_type         = "your-zone-type"  # Required when dns_provider_name = "aws"
}
```

### Usage with OCI DNS

```hcl
module "external_dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/external_dns?ref=v3.2.0"

  dns_provider_name        = "oci"
  domain_filters           = "your-domain-filters"
  oci_compartment_ocid     = "your-oci-compartment-ocid"  # Required when dns_provider_name = "oci"
  oci_region               = "your-oci-region"  # Required when dns_provider_name = "oci"
  oci_service_account_name = "your-oci-service-account-name"  # Required when dns_provider_name = "oci"
  oci_zone_scope           = "your-oci-zone-scope"  # Required when dns_provider_name = "oci"
  oci_zones_cache_duration = "your-oci-zones-cache-duration"  # Required when dns_provider_name = "oci"
}
```

### Usage with Azure DNS

```hcl
module "external_dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/external_dns?ref=v3.2.0"

  azure_client_id                 = "your-azure-client-id"  # Required when dns_provider_name = "azure"
  azure_federated_credential_id   = "your-azure-federated-credential-id"  # Required when dns_provider_name = "azure"
  azure_resource_group            = "your-azure-resource-group"  # Required when dns_provider_name = "azure"
  azure_subscription_id           = "your-azure-subscription-id"  # Required when dns_provider_name = "azure"
  azure_tenant_id                 = "your-azure-tenant-id"  # Required when dns_provider_name = "azure"
  azure_workload_identity_enabled = "your-azure-workload-identity-enabled"  # Required when dns_provider_name = "azure"
  dns_provider_name               = "azure"
  domain_filters                  = "your-domain-filters"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.external_dns.id
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
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 3.0.1 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.external_dns](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace_v1.external_dns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_secret_v1.external_dns_azure_config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_secret_v1.external_dns_cloudflare](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_secret_v1.external_dns_oci_config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [terraform_data.provider_validation](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_iam_role_arn"></a> [aws\_iam\_role\_arn](#input\_aws\_iam\_role\_arn) | The IAM role ARN for ExternalDNS to assume for Route53 access (required when dns\_provider\_name is 'aws') | `string` | `""` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region where the Route53 hosted zones are located | `string` | `""` | no |
| <a name="input_azure_client_id"></a> [azure\_client\_id](#input\_azure\_client\_id) | Client ID of the Azure Managed Identity for Workload Identity (required when dns\_provider\_name is 'azure' and azure\_workload\_identity\_enabled is true) | `string` | `""` | no |
| <a name="input_azure_client_secret"></a> [azure\_client\_secret](#input\_azure\_client\_secret) | Azure AD client secret for Service Principal auth (required when dns\_provider\_name is 'azure' and azure\_workload\_identity\_enabled is false). | `string` | `""` | no |
| <a name="input_azure_federated_credential_id"></a> [azure\_federated\_credential\_id](#input\_azure\_federated\_credential\_id) | Resource ID of the Azure federated identity credential for external-dns (required when dns\_provider\_name is 'azure' and azure\_workload\_identity\_enabled is true). Pass module.iam\_external\_dns.id to enforce dependency ordering. | `string` | `""` | no |
| <a name="input_azure_resource_group"></a> [azure\_resource\_group](#input\_azure\_resource\_group) | Azure resource group containing the DNS zone (required when dns\_provider\_name is 'azure') | `string` | `""` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | Azure subscription ID where the DNS zone is located (required when dns\_provider\_name is 'azure') | `string` | `""` | no |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | Azure tenant ID (required when dns\_provider\_name is 'azure') | `string` | `""` | no |
| <a name="input_azure_workload_identity_enabled"></a> [azure\_workload\_identity\_enabled](#input\_azure\_workload\_identity\_enabled) | Enable Workload Identity for Azure DNS provider. When false, Service Principal auth is used and azure\_client\_secret is required. | `bool` | `true` | no |
| <a name="input_cloudflare_token"></a> [cloudflare\_token](#input\_cloudflare\_token) | The Cloudflare API token for DNS management (required when dns\_provider\_name is 'cloudflare') | `string` | `""` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Whether to create the Kubernetes namespace. Set to false if the namespace already exists (e.g., when deploying multiple instances) | `bool` | `true` | no |
| <a name="input_dns_provider_name"></a> [dns\_provider\_name](#input\_dns\_provider\_name) | The DNS provider to use with ExternalDNS | `string` | n/a | yes |
| <a name="input_domain_filters"></a> [domain\_filters](#input\_domain\_filters) | The domain filter to limit ExternalDNS to manage DNS records only for specific domains | `string` | n/a | yes |
| <a name="input_external_dns_namespace"></a> [external\_dns\_namespace](#input\_external\_dns\_namespace) | The Kubernetes namespace where ExternalDNS will be deployed | `string` | `"external-dns"` | no |
| <a name="input_external_dns_version"></a> [external\_dns\_version](#input\_external\_dns\_version) | The version of ExternalDNS Helm chart to deploy | `string` | `"1.19.0"` | no |
| <a name="input_oci_compartment_ocid"></a> [oci\_compartment\_ocid](#input\_oci\_compartment\_ocid) | The OCI compartment OCID where the DNS zones are located (required when dns\_provider\_name is 'oci') | `string` | `""` | no |
| <a name="input_oci_region"></a> [oci\_region](#input\_oci\_region) | The OCI region for workload identity configuration (required when dns\_provider\_name is 'oci') | `string` | `""` | no |
| <a name="input_oci_service_account_name"></a> [oci\_service\_account\_name](#input\_oci\_service\_account\_name) | The Kubernetes service account name for OCI Workload Identity | `string` | `"external-dns"` | no |
| <a name="input_oci_zone_scope"></a> [oci\_zone\_scope](#input\_oci\_zone\_scope) | The scope of the DNS zones in OCI (GLOBAL or PRIVATE) | `string` | `"GLOBAL"` | no |
| <a name="input_oci_zones_cache_duration"></a> [oci\_zones\_cache\_duration](#input\_oci\_zones\_cache\_duration) | The duration to cache OCI DNS zones (e.g., '30s', '1m'). Set to '0s' to disable caching. | `string` | `"30s"` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | The policy to external dns manage the DNS records | `string` | `"sync"` | no |
| <a name="input_sources"></a> [sources](#input\_sources) | Array contents the sources to external dns work | `list(string)` | <pre>[<br/>  "crd",<br/>  "gateway-httproute"<br/>]</pre> | no |
| <a name="input_txt_owner_id"></a> [txt\_owner\_id](#input\_txt\_owner\_id) | The TXT owner ID used by ExternalDNS to identify DNS records it manages | `string` | `"external_dns"` | no |
| <a name="input_type"></a> [type](#input\_type) | Determines whether the external-dns deployment is public or private | `string` | `"public"` | no |
| <a name="input_zone_id_filter"></a> [zone\_id\_filter](#input\_zone\_id\_filter) | The Route53 public or private hosted zone ID for ExternalDNS to manage (required when dns\_provider\_name is 'aws') | `string` | `""` | no |
| <a name="input_zone_type"></a> [zone\_type](#input\_zone\_type) | The Route53 hosted zone type for ExternalDNS to manage (public or private) | `string` | `""` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "external_dns",
  "description": "Deploys ExternalDNS via Helm on Kubernetes with support for Cloudflare, AWS Route53, OCI, and Azure DNS providers",
  "architecture": "The module creates an optional kubernetes_namespace_v1 resource and a helm_release resource for the external-dns chart from the kubernetes-sigs registry. Provider-specific configurations are assembled in locals.tf by merging a base_config with one of four provider config maps (cloudflare_config, route53_config, oci_config, azure_config) selected by dns_provider_name, then encoded as YAML values passed to the helm_release. Provider secrets (kubernetes_secret_v1 for Cloudflare tokens, OCI config, and Azure config) are created as dependencies that the helm_release waits on before deploying.",
  "features": [
    "Deploys ExternalDNS Helm chart with configurable version and namespace into a Kubernetes cluster",
    "Supports four DNS providers: Cloudflare (API token via Kubernetes secret), AWS Route53 (IRSA with IAM role annotation), OCI (Workload Identity with compartment OCID and zone scope), and Azure (Workload Identity or Service Principal)",
    "Configures AWS provider with RBAC permissions for DNSEndpoints, Gateways, and HTTPRoutes CRDs",
    "Mounts OCI and Azure provider credentials as Kubernetes secrets into the ExternalDNS pod via extraVolumes and extraVolumeMounts",
    "Controls DNS record management behavior via configurable policy (sync, create-only, upsert-only)",
    "Supports deploying multiple ExternalDNS instances (public and private) in the same cluster via the type variable",
    "Enables OCI DNS zone scope selection between GLOBAL and PRIVATE with configurable zones cache duration"
  ],
  "inputs": [
    {
      "name": "domain_filters",
      "description": "The domain filter to limit ExternalDNS to manage DNS records only for specific domains",
      "required": true
    },
    {
      "name": "dns_provider_name",
      "description": "The DNS provider to use with ExternalDNS ",
      "required": true
    },
    {
      "name": "policy",
      "description": "The policy to external dns manage the DNS records",
      "required": false
    },
    {
      "name": "type",
      "description": "Determines whether the external-dns deployment is public or private",
      "required": false
    },
    {
      "name": "oci_zone_scope",
      "description": "The scope of the DNS zones in OCI (GLOBAL or PRIVATE)",
      "required": false
    },
    {
      "name": "external_dns_version",
      "description": "The version of ExternalDNS Helm chart to deploy",
      "required": false
    },
    {
      "name": "external_dns_namespace",
      "description": "The Kubernetes namespace where ExternalDNS will be deployed",
      "required": false
    },
    {
      "name": "create_namespace",
      "description": "Whether to create the Kubernetes namespace. Set to false if the namespace already exists (e.g., when deploying multiple instances)",
      "required": false
    },
    {
      "name": "txt_owner_id",
      "description": "The TXT owner ID used by ExternalDNS to identify DNS records it manages",
      "required": false
    },
    {
      "name": "sources",
      "description": "Array contents the sources to external dns work",
      "required": false
    },
    {
      "name": "cloudflare_token",
      "description": "The Cloudflare API token for DNS management (required when dns_provider_name is 'cloudflare')",
      "required": false
    },
    {
      "name": "aws_region",
      "description": "The AWS region where the Route53 hosted zones are located",
      "required": false
    },
    {
      "name": "aws_iam_role_arn",
      "description": "The IAM role ARN for ExternalDNS to assume for Route53 access (required when dns_provider_name is 'aws')",
      "required": false
    },
    {
      "name": "zone_id_filter",
      "description": "The Route53 public or private hosted zone ID for ExternalDNS to manage (required when dns_provider_name is 'aws')",
      "required": false
    },
    {
      "name": "zone_type",
      "description": "The Route53 hosted zone type for ExternalDNS to manage (public or private)",
      "required": false
    },
    {
      "name": "oci_compartment_ocid",
      "description": "The OCI compartment OCID where the DNS zones are located (required when dns_provider_name is 'oci')",
      "required": false
    },
    {
      "name": "oci_region",
      "description": "The OCI region for workload identity configuration (required when dns_provider_name is 'oci')",
      "required": false
    },
    {
      "name": "oci_service_account_name",
      "description": "The Kubernetes service account name for OCI Workload Identity",
      "required": false
    },
    {
      "name": "oci_zones_cache_duration",
      "description": "The duration to cache OCI DNS zones (e.g., '30s', '1m'). Set to '0s' to disable caching.",
      "required": false
    },
    {
      "name": "azure_workload_identity_enabled",
      "description": "Enable Workload Identity for Azure DNS provider. When false, Service Principal auth is used and azure_client_secret is required.",
      "required": false
    },
    {
      "name": "azure_federated_credential_id",
      "description": "Resource ID of the Azure federated identity credential for external-dns (required when dns_provider_name is 'azure' and azure_workload_identity_enabled is true). Pass module.iam_external_dns.id to enforce dependency ordering.",
      "required": false
    },
    {
      "name": "azure_client_secret",
      "description": "Azure AD client secret for Service Principal auth (required when dns_provider_name is 'azure' and azure_workload_identity_enabled is false).",
      "required": false
    },
    {
      "name": "azure_client_id",
      "description": "Client ID of the Azure Managed Identity for Workload Identity (required when dns_provider_name is 'azure' and azure_workload_identity_enabled is true)",
      "required": false
    },
    {
      "name": "azure_subscription_id",
      "description": "Azure subscription ID where the DNS zone is located (required when dns_provider_name is 'azure')",
      "required": false
    },
    {
      "name": "azure_resource_group",
      "description": "Azure resource group containing the DNS zone (required when dns_provider_name is 'azure')",
      "required": false
    },
    {
      "name": "azure_tenant_id",
      "description": "Azure tenant ID (required when dns_provider_name is 'azure')",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "3543fe48f4d68094d3fb00e2c088917a"
}
END_AI_METADATA -->
