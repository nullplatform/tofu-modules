# Module: backend

## Description

Creates and configures an S3 bucket for Terraform state with optional KMS encryption and IAM access controls

## Architecture

This module creates an S3 bucket with versioning and server-side encryption enabled, and optionally creates a KMS key for encryption. The S3 bucket is configured with a public access block and ownership controls. The module also creates an IAM policy for the S3 bucket and KMS key if allowed IAM ARNs are specified. The resources are connected internally through the use of Terraform resource types such as aws_s3_bucket, aws_kms_key, and aws_iam_policy. The inputs flow into the resources through variables such as bucket_prefix, force_destroy, and allowed_iam_arns, and the outputs are exposed through values such as bucket_name, bucket_arn, and kms_key_arn.

## Features

- Creates S3 bucket with versioning and server-side encryption
- Configures public access block and ownership controls for the S3 bucket
- Creates KMS key for encryption if specified
- Creates IAM policy for the S3 bucket and KMS key if allowed IAM ARNs are specified
- Supports unrestricted access to the S3 bucket if no allowed IAM ARNs are specified

## Basic Usage

```hcl
module "backend" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/backend?ref=v6.11.2"
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
| [aws_kms_alias.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.tf_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_ownership_controls.tf_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.tf_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.tf_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.tf_state_sse](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.tf_state_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [random_id.bucket_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_iam_arns"></a> [allowed\_iam\_arns](#input\_allowed\_iam\_arns) | List of IAM ARNs allowed to access the S3 bucket and KMS key. When empty, no bucket policy is created and access is unrestricted | `list(string)` | `[]` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region where the backend resources will be created | `string` | `"us-east-1"` | no |
| <a name="input_bucket_prefix"></a> [bucket\_prefix](#input\_bucket\_prefix) | Prefix for the S3 bucket name. A random suffix will be appended | `string` | `"tf-state"` | no |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Create a dedicated KMS key for S3 bucket encryption. Overrides sse\_algorithm to aws:kms | `bool` | `false` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Allow destruction of the S3 bucket even if it contains objects | `bool` | `true` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key ARN for S3 bucket encryption. Required when sse\_algorithm is aws:kms and create\_kms\_key is false | `string` | `null` | no |
| <a name="input_sse_algorithm"></a> [sse\_algorithm](#input\_sse\_algorithm) | Server-side encryption algorithm for the S3 bucket (AES256 or aws:kms) | `string` | `"AES256"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region"></a> [aws\_region](#output\_aws\_region) | AWS region where the backend was created |
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | ARN of the S3 bucket for Terraform state |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | Name of the S3 bucket for Terraform state |
| <a name="output_kms_key_alias"></a> [kms\_key\_alias](#output\_kms\_key\_alias) | Alias of the KMS key (null if not created) |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | ARN of the KMS key used for bucket encryption (null if not created) |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "backend",
  "description": "Creates and configures an S3 bucket for Terraform state with optional KMS encryption and IAM access controls",
  "architecture": "This module creates an S3 bucket with versioning and server-side encryption enabled, and optionally creates a KMS key for encryption. The S3 bucket is configured with a public access block and ownership controls. The module also creates an IAM policy for the S3 bucket and KMS key if allowed IAM ARNs are specified. The resources are connected internally through the use of Terraform resource types such as aws_s3_bucket, aws_kms_key, and aws_iam_policy. The inputs flow into the resources through variables such as bucket_prefix, force_destroy, and allowed_iam_arns, and the outputs are exposed through values such as bucket_name, bucket_arn, and kms_key_arn.",
  "features": [
    "Creates S3 bucket with versioning and server-side encryption",
    "Configures public access block and ownership controls for the S3 bucket",
    "Creates KMS key for encryption if specified",
    "Creates IAM policy for the S3 bucket and KMS key if allowed IAM ARNs are specified",
    "Supports unrestricted access to the S3 bucket if no allowed IAM ARNs are specified"
  ],
  "inputs": [
    {
      "name": "aws_region",
      "description": "AWS region where the backend resources will be created",
      "required": false
    },
    {
      "name": "bucket_prefix",
      "description": "Prefix for the S3 bucket name. A random suffix will be appended",
      "required": false
    },
    {
      "name": "force_destroy",
      "description": "Allow destruction of the S3 bucket even if it contains objects",
      "required": false
    },
    {
      "name": "sse_algorithm",
      "description": "Server-side encryption algorithm for the S3 bucket (AES256 or aws:kms)",
      "required": false
    },
    {
      "name": "kms_key_id",
      "description": "KMS key ARN for S3 bucket encryption. Required when sse_algorithm is aws:kms and create_kms_key is false",
      "required": false
    },
    {
      "name": "create_kms_key",
      "description": "Create a dedicated KMS key for S3 bucket encryption. Overrides sse_algorithm to aws:kms",
      "required": false
    },
    {
      "name": "allowed_iam_arns",
      "description": "List of IAM ARNs allowed to access the S3 bucket and KMS key. When empty, no bucket policy is created and access is unrestricted",
      "required": false
    }
  ],
  "outputs": [
    "bucket_name",
    "bucket_arn",
    "aws_region",
    "kms_key_arn",
    "kms_key_alias"
  ],
  "hash": "59c7d71cbd7103481e0503944b444408"
}
END_AI_METADATA -->
