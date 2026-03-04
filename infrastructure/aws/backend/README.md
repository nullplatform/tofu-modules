# Module: backend

## Description

Creates a secure S3 bucket for storing Terraform state with versioning, encryption, and public access blocking

## Features

- Creates an S3 bucket with a random suffix for unique naming
- Enables versioning to maintain state file history
- Configures server-side encryption with AES256 or KMS
- Blocks all public access to ensure state file security
- Enforces bucket owner object ownership controls
- Supports force destroy option for bucket cleanup
- Outputs bucket name, ARN, and region for backend configuration

## Basic Usage

```hcl
module "backend" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/backend?ref=v1.42.0"
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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.tf_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_object_lock_configuration.tf_state_lock](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.tf_state_sse](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.tf_state_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [random_id.bucket_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
<!-- END_TF_DOCS -->
