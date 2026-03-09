# Module: backend

## Description

Creates a secure S3 bucket configured as a Terraform remote state backend with versioning, encryption, and optional KMS key management

## Features

- Creates an S3 bucket with a randomly generated suffix for Terraform state storage
- Enables versioning on the S3 bucket to track state file changes
- Configures server-side encryption with support for AES256 or KMS encryption
- Blocks all public access to the S3 bucket using AWS public access block settings
- Optionally creates a dedicated KMS key with automatic rotation for bucket encryption
- Supports IAM-based access control with optional bucket policies for specific ARNs
- Enforces SSL/TLS for all bucket access through bucket policy conditions

## Basic Usage

```hcl
module "backend" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/backend?ref=v1.43.0"
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
