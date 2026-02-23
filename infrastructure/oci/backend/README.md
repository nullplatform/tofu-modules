# Module: backend

## Description

Creates an Oracle Cloud Infrastructure Object Storage bucket configured for storing OpenTofu/Terraform state files with S3-compatible backend support

## Features

- Creates an OCI Object Storage bucket with configurable access controls and storage tiers
- Configures object versioning to maintain state file history and enable rollback capabilities
- Supports multiple storage tiers (Standard and Archive) for cost optimization
- Generates S3-compatible backend configuration for seamless OpenTofu/Terraform integration
- Applies automatic tagging for resource management and tracking
- Provides bucket endpoints and connection details for backend configuration

## Basic Usage

```hcl
module "backend" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/oci/backend?ref=v1.36.0"

  compartment_id = "your-compartment-id"
  namespace      = "your-namespace"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.backend.bucket_name
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | >= 5.0.0 |

## Resources

| Name | Type |
|------|------|
| [oci_objectstorage_bucket.tofu_state](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_bucket) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_type"></a> [access\_type](#input\_access\_type) | Tipo de acceso al bucket (NoPublicAccess, ObjectRead, ObjectReadWithoutList) | `string` | `"NoPublicAccess"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Nombre del bucket para almacenar el estado de OpenTofu | `string` | `"tofu-state"` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID del compartment donde se creará el bucket | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Object Storage namespace (generalmente el nombre del tenancy) | `string` | n/a | yes |
| <a name="input_storage_tier"></a> [storage\_tier](#input\_storage\_tier) | Tier de almacenamiento (Standard, Archive) | `string` | `"Standard"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags de formato libre para el bucket | `map(string)` | `{}` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | Habilitar versionado de objetos para el bucket | `string` | `"Enabled"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_config"></a> [backend\_config](#output\_backend\_config) | Configuración sugerida para el backend de OpenTofu |
| <a name="output_bucket_endpoint"></a> [bucket\_endpoint](#output\_bucket\_endpoint) | Endpoint del bucket para configurar el backend |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | OCID del bucket |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | Nombre del bucket creado |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Object Storage namespace |
<!-- END_TF_DOCS -->
