# Module: cloud

## Description

Configures a nullplatform Azure provider by creating a nullplatform_provider_config resource with authentication credentials and networking settings for Azure infrastructure

## Architecture

The module creates a single nullplatform_provider_config resource of type 'azure-configuration' that encodes Azure authentication and networking attributes as a JSON payload. Authentication fields (client_id, client_secret, subscription_id, tenant_id) are conditionally included only when non-null, enforced by a lifecycle precondition requiring all-or-none credential provisioning. Networking attributes including public and private DNS zone names and their respective resource group names are wired directly from input variables into the jsonencode attributes block. The resource is bound to a nullplatform NRN and optional dimensions map to scope the configuration within the nullplatform hierarchy.

## Features

- Creates a nullplatform_provider_config resource of type 'azure-configuration' scoped to a specific NRN
- Configures Azure Service Principal authentication with client_id, client_secret, subscription_id, and tenant_id supporting inheritance from parent providers when omitted
- Enforces all-or-nothing credential validation ensuring authentication fields are either all set or all null via lifecycle precondition
- Configures public and private DNS zone names with their respective Azure resource group references for networking
- Supports optional dimensions map for scoping the provider configuration within nullplatform hierarchy
- Marks client_secret as sensitive to prevent exposure in Terraform state output
- Ignores post-creation attribute drift via ignore_changes to prevent unintended updates

## Basic Usage

```hcl
module "cloud" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/cloud/azure/cloud?ref=v6.19.1"

  azure_resource_group_name       = "your-azure-resource-group-name"
  nrn                             = "your-nrn"
  private_dns_resource_group_name = "your-private-dns-resource-group-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.cloud.id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.95 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.azure](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_domain"></a> [application\_domain](#input\_application\_domain) | Apply application domain or not | `bool` | `false` | no |
| <a name="input_azure_resource_group_name"></a> [azure\_resource\_group\_name](#input\_azure\_resource\_group\_name) | Your Azure resource group name | `string` | n/a | yes |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | Azure Service Principal client ID. If omitted, inherits from a parent cloud provider. | `string` | `null` | no |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | Azure Service Principal client secret. If omitted, inherits from a parent cloud provider. | `string` | `null` | no |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Define dimensions. For more information, see https://docs.nullplatform.com/docs/dimensions | `map(any)` | `{}` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name to be used | `string` | `""` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | The NRN of your nullplatform account | `string` | n/a | yes |
| <a name="input_private_dns_resource_group_name"></a> [private\_dns\_resource\_group\_name](#input\_private\_dns\_resource\_group\_name) | Azure resource group name for the DNS private | `string` | n/a | yes |
| <a name="input_private_domain_name"></a> [private\_domain\_name](#input\_private\_domain\_name) | The private domain name to be used | `string` | `""` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription ID. If omitted, inherits from a parent cloud provider. | `string` | `null` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure Active Directory tenant ID. If omitted, inherits from a parent cloud provider. | `string` | `null` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "cloud",
  "description": "Configures a nullplatform Azure provider by creating a nullplatform_provider_config resource with authentication credentials and networking settings for Azure infrastructure",
  "architecture": "The module creates a single nullplatform_provider_config resource of type 'azure-configuration' that encodes Azure authentication and networking attributes as a JSON payload. Authentication fields (client_id, client_secret, subscription_id, tenant_id) are conditionally included only when non-null, enforced by a lifecycle precondition requiring all-or-none credential provisioning. Networking attributes including public and private DNS zone names and their respective resource group names are wired directly from input variables into the jsonencode attributes block. The resource is bound to a nullplatform NRN and optional dimensions map to scope the configuration within the nullplatform hierarchy.",
  "features": [
    "Creates a nullplatform_provider_config resource of type 'azure-configuration' scoped to a specific NRN",
    "Configures Azure Service Principal authentication with client_id, client_secret, subscription_id, and tenant_id supporting inheritance from parent providers when omitted",
    "Enforces all-or-nothing credential validation ensuring authentication fields are either all set or all null via lifecycle precondition",
    "Configures public and private DNS zone names with their respective Azure resource group references for networking",
    "Supports optional dimensions map for scoping the provider configuration within nullplatform hierarchy",
    "Marks client_secret as sensitive to prevent exposure in Terraform state output",
    "Ignores post-creation attribute drift via ignore_changes to prevent unintended updates"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "The NRN of your nullplatform account",
      "required": true
    },
    {
      "name": "azure_resource_group_name",
      "description": "Your Azure resource group name",
      "required": true
    },
    {
      "name": "private_dns_resource_group_name",
      "description": "Azure resource group name for the DNS private",
      "required": true
    },
    {
      "name": "client_id",
      "description": "Azure Service Principal client ID. If omitted, inherits from a parent cloud provider.",
      "required": false
    },
    {
      "name": "client_secret",
      "description": "Azure Service Principal client secret. If omitted, inherits from a parent cloud provider.",
      "required": false
    },
    {
      "name": "subscription_id",
      "description": "Azure subscription ID. If omitted, inherits from a parent cloud provider.",
      "required": false
    },
    {
      "name": "tenant_id",
      "description": "Azure Active Directory tenant ID. If omitted, inherits from a parent cloud provider.",
      "required": false
    },
    {
      "name": "domain_name",
      "description": "The domain name to be used",
      "required": false
    },
    {
      "name": "application_domain",
      "description": "Apply application domain or not",
      "required": false
    },
    {
      "name": "dimensions",
      "description": "Define dimensions. For more information, see https://docs.nullplatform.com/docs/dimensions",
      "required": false
    },
    {
      "name": "private_domain_name",
      "description": "The private domain name to be used",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "02119a8630f0bd1a785f49967ff9291d"
}
END_AI_METADATA -->
