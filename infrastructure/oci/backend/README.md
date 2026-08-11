# Module: backend

## Description

Creates an Oracle Cloud Infrastructure Object Storage bucket with configurable access type, storage tier, and versioning

## Architecture

The module creates an oci_objectstorage_bucket resource, which is configured with the provided compartment_id, namespace, access_type, storage_tier, and versioning variables. The bucket is then connected to the oci_identity_region_subscriptions data source to retrieve the region name, which is used to construct the bucket endpoint. The module also outputs the bucket name, ID, namespace, endpoint, and a suggested backend configuration for OpenTofu.

## Features

- Creates an Oracle Cloud Infrastructure Object Storage bucket with custom access type
- Configures the bucket with a specified storage tier and versioning settings
- Generates a suggested backend configuration for OpenTofu with the created bucket

## Basic Usage

```hcl
module "backend" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/oci/backend?ref=v7.0.1"

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
| <a name="provider_oci"></a> [oci](#provider\_oci) | 7.30.0 |

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

<!-- BEGIN_AI_METADATA
{
  "name": "backend",
  "description": "Creates an Oracle Cloud Infrastructure Object Storage bucket with configurable access type, storage tier, and versioning",
  "architecture": "The module creates an oci_objectstorage_bucket resource, which is configured with the provided compartment_id, namespace, access_type, storage_tier, and versioning variables. The bucket is then connected to the oci_identity_region_subscriptions data source to retrieve the region name, which is used to construct the bucket endpoint. The module also outputs the bucket name, ID, namespace, endpoint, and a suggested backend configuration for OpenTofu.",
  "features": [
    "Creates an Oracle Cloud Infrastructure Object Storage bucket with custom access type",
    "Configures the bucket with a specified storage tier and versioning settings",
    "Generates a suggested backend configuration for OpenTofu with the created bucket"
  ],
  "inputs": [
    {
      "name": "compartment_id",
      "description": "OCID del compartment donde se creará el bucket",
      "required": true
    },
    {
      "name": "namespace",
      "description": "Object Storage namespace (generalmente el nombre del tenancy)",
      "required": true
    },
    {
      "name": "versioning",
      "description": "Habilitar versionado de objetos para el bucket",
      "required": false
    },
    {
      "name": "bucket_name",
      "description": "Nombre del bucket para almacenar el estado de OpenTofu",
      "required": false
    },
    {
      "name": "access_type",
      "description": "Tipo de acceso al bucket (NoPublicAccess, ObjectRead, ObjectReadWithoutList)",
      "required": false
    },
    {
      "name": "storage_tier",
      "description": "Tier de almacenamiento (Standard, Archive)",
      "required": false
    },
    {
      "name": "tags",
      "description": "Tags de formato libre para el bucket",
      "required": false
    }
  ],
  "outputs": [
    "bucket_name",
    "bucket_id",
    "namespace",
    "bucket_endpoint",
    "backend_config"
  ],
  "hash": "ff5581d9726d997de8f1a74fbbfc14f0"
}
END_AI_METADATA -->
