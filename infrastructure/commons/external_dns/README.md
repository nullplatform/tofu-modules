# Module: external_dns

## Description

Deploys ExternalDNS to manage DNS records for specific domains with various DNS providers

## Architecture

The module creates a Kubernetes namespace and deploys ExternalDNS using Helm, configuring it with the specified DNS provider and other parameters, it uses Terraform resources such as kubernetes_namespace_v1 and helm_release to manage the deployment, and it also uses locals to configure the provider-specific settings, the module also depends on kubernetes_secret_v1 resources for Cloudflare and OCI configurations

## Features

- Creates ExternalDNS deployment with specified DNS provider
- Configures ExternalDNS with domain filters and policy
- Supports Cloudflare, AWS, and OCI as DNS providers
- Manages DNS records for specific domains

## Basic Usage

```hcl
module "external_dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/external_dns?ref=v1.48.1"

  dns_provider_name = "your-dns-provider-name"
  domain_filters    = "your-domain-filters"
}
```

### Usage with Cloudflare Configuration

```hcl
module "external_dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/external_dns?ref=v1.48.1"

  cloudflare_token  = "your-cloudflare-token"  # Required when dns_provider_name = "cloudflare"
  dns_provider_name = "cloudflare"
  domain_filters    = "your-domain-filters"
}
```

### Usage with AWS Configuration

```hcl
module "external_dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/external_dns?ref=v1.48.1"

  aws_iam_role_arn  = "your-aws-iam-role-arn"  # Required when dns_provider_name = "aws"
  aws_region        = "your-aws-region"  # Required when dns_provider_name = "aws"
  dns_provider_name = "aws"
  domain_filters    = "your-domain-filters"
  zone_id_filter    = "your-zone-id-filter"  # Required when dns_provider_name = "aws"
  zone_type         = "your-zone-type"  # Required when dns_provider_name = "aws"
}
```

### Usage with OCI Configuration

```hcl
module "external_dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/external_dns?ref=v1.48.1"

  dns_provider_name    = "oci"
  domain_filters       = "your-domain-filters"
  oci_compartment_ocid = "your-oci-compartment-ocid"  # Required when dns_provider_name = "oci"
  oci_region           = "your-oci-region"  # Required when dns_provider_name = "oci"
  oci_zone_scope       = "your-oci-zone-scope"  # Required when dns_provider_name = "oci"
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
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.external_dns](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace_v1.external_dns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_secret_v1.external_dns_cloudflare](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_secret_v1.external_dns_oci_config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_iam_role_arn"></a> [aws\_iam\_role\_arn](#input\_aws\_iam\_role\_arn) | The IAM role ARN for ExternalDNS to assume for Route53 access (required when dns\_provider\_name is 'aws') | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region where the Route53 hosted zones are located | `string` | `null` | no |
| <a name="input_cloudflare_token"></a> [cloudflare\_token](#input\_cloudflare\_token) | The Cloudflare API token for DNS management (required when dns\_provider\_name is 'cloudflare') | `string` | `null` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Whether to create the Kubernetes namespace. Set to false if the namespace already exists (e.g., when deploying multiple instances) | `bool` | `true` | no |
| <a name="input_dns_provider_name"></a> [dns\_provider\_name](#input\_dns\_provider\_name) | The DNS provider to use with ExternalDNS | `string` | n/a | yes |
| <a name="input_domain_filters"></a> [domain\_filters](#input\_domain\_filters) | The domain filter to limit ExternalDNS to manage DNS records only for specific domains | `string` | n/a | yes |
| <a name="input_external_dns_namespace"></a> [external\_dns\_namespace](#input\_external\_dns\_namespace) | The Kubernetes namespace where ExternalDNS will be deployed | `string` | `"external-dns"` | no |
| <a name="input_external_dns_version"></a> [external\_dns\_version](#input\_external\_dns\_version) | The version of ExternalDNS Helm chart to deploy | `string` | `"1.19.0"` | no |
| <a name="input_oci_compartment_ocid"></a> [oci\_compartment\_ocid](#input\_oci\_compartment\_ocid) | The OCI compartment OCID where the DNS zones are located (required when dns\_provider\_name is 'oci') | `string` | `" "` | no |
| <a name="input_oci_region"></a> [oci\_region](#input\_oci\_region) | The OCI region for workload identity configuration (required when dns\_provider\_name is 'oci') | `string` | `""` | no |
| <a name="input_oci_service_account_name"></a> [oci\_service\_account\_name](#input\_oci\_service\_account\_name) | The Kubernetes service account name for OCI Workload Identity | `string` | `"external-dns"` | no |
| <a name="input_oci_zone_scope"></a> [oci\_zone\_scope](#input\_oci\_zone\_scope) | The scope of the DNS zones in OCI (GLOBAL or PRIVATE) | `string` | `"GLOBAL"` | no |
| <a name="input_oci_zones_cache_duration"></a> [oci\_zones\_cache\_duration](#input\_oci\_zones\_cache\_duration) | The duration to cache OCI DNS zones (e.g., '30s', '1m'). Set to '0s' to disable caching. | `string` | `"30s"` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | The policy to external dns manage the DNS records | `string` | `"upsert-only"` | no |
| <a name="input_sources"></a> [sources](#input\_sources) | Array contents the sources to external dns work | `list(string)` | <pre>[<br/>  "crd"<br/>]</pre> | no |
| <a name="input_txt_owner_id"></a> [txt\_owner\_id](#input\_txt\_owner\_id) | The TXT owner ID used by ExternalDNS to identify DNS records it manages | `string` | `"external_dns"` | no |
| <a name="input_type"></a> [type](#input\_type) | Determines whether the external-dns deployment is public or private | `string` | `"public"` | no |
| <a name="input_zone_id_filter"></a> [zone\_id\_filter](#input\_zone\_id\_filter) | The Route53 public or private hosted zone ID for ExternalDNS to manage (required when dns\_provider\_name is 'aws') | `string` | `""` | no |
| <a name="input_zone_type"></a> [zone\_type](#input\_zone\_type) | The Route53 hosted zone type for ExternalDNS to manage (public or private) | `string` | `""` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "external_dns",
  "description": "Deploys ExternalDNS to manage DNS records for specific domains with various DNS providers",
  "architecture": "The module creates a Kubernetes namespace and deploys ExternalDNS using Helm, configuring it with the specified DNS provider and other parameters, it uses Terraform resources such as kubernetes_namespace_v1 and helm_release to manage the deployment, and it also uses locals to configure the provider-specific settings, the module also depends on kubernetes_secret_v1 resources for Cloudflare and OCI configurations",
  "features": [
    "Creates ExternalDNS deployment with specified DNS provider",
    "Configures ExternalDNS with domain filters and policy",
    "Supports Cloudflare, AWS, and OCI as DNS providers",
    "Manages DNS records for specific domains"
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
      "name": "oci_service_account_name",
      "description": "The Kubernetes service account name for OCI Workload Identity",
      "required": false
    },
    {
      "name": "oci_zones_cache_duration",
      "description": "The duration to cache OCI DNS zones (e.g., '30s', '1m'). Set to '0s' to disable caching.",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "dc5f0b5fd765b71004c66fb4eb229625"
}
END_AI_METADATA -->
