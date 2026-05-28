# Module: s3

## Description

Attaches an S3 bucket policy that enforces secure transport (HTTPS-only) and optionally merges additional IAM policy statements

## Architecture

The module creates an aws_s3_bucket_policy resource attached to an existing S3 bucket. It uses aws_iam_policy_document data sources to construct the policy: one generates a mandatory Deny statement for aws:SecureTransport=false (rejecting non-HTTPS requests), and another merges this with any additional policy JSON provided via input. The merged policy document flows into the aws_s3_bucket_policy resource, which applies it to the bucket identified by bucket_id.

## Features

- Enforces HTTPS-only access by denying all S3 actions when aws:SecureTransport is false
- Merges caller-supplied IAM policy statements with the mandatory secure transport policy
- Prevents unrestricted public access by disallowing Principal '*' with Effect 'Allow'
- Outputs the final merged policy JSON for verification and audit purposes

## Basic Usage

```hcl
module "s3" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/s3?ref=v3.3.0"

  bucket_arn = "your-bucket-arn"
  bucket_id  = "your-bucket-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.s3.bucket_id
}
```

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_policy_json"></a> [additional\_policy\_json](#input\_additional\_policy\_json) | Optional JSON policy document to merge with the mandatory secure transport policy.<br/>Must NOT contain statements with Principal \"*\" and Effect \"Allow\", as that grants<br/>unrestricted public access. Use specific principals (IAM roles, accounts) instead. | `string` | `null` | no |
| <a name="input_bucket_arn"></a> [bucket\_arn](#input\_bucket\_arn) | ARN of the S3 bucket. Used to build the resource ARNs in the secure transport statement. | `string` | n/a | yes |
| <a name="input_bucket_id"></a> [bucket\_id](#input\_bucket\_id) | ID (name) of the S3 bucket to which the policy will be applied. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | ID of the S3 bucket to which the policy was applied. |
| <a name="output_policy_json"></a> [policy\_json](#output\_policy\_json) | The final bucket policy JSON applied to the bucket. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "s3",
  "description": "Attaches an S3 bucket policy that enforces secure transport (HTTPS-only) and optionally merges additional IAM policy statements",
  "architecture": "The module creates an aws_s3_bucket_policy resource attached to an existing S3 bucket. It uses aws_iam_policy_document data sources to construct the policy: one generates a mandatory Deny statement for aws:SecureTransport=false (rejecting non-HTTPS requests), and another merges this with any additional policy JSON provided via input. The merged policy document flows into the aws_s3_bucket_policy resource, which applies it to the bucket identified by bucket_id.",
  "features": [
    "Enforces HTTPS-only access by denying all S3 actions when aws:SecureTransport is false",
    "Merges caller-supplied IAM policy statements with the mandatory secure transport policy",
    "Prevents unrestricted public access by disallowing Principal '*' with Effect 'Allow'",
    "Outputs the final merged policy JSON for verification and audit purposes"
  ],
  "inputs": [
    {
      "name": "bucket_id",
      "description": "ID (name) of the S3 bucket to which the policy will be applied.",
      "required": true
    },
    {
      "name": "bucket_arn",
      "description": "ARN of the S3 bucket. Used to build the resource ARNs in the secure transport statement.",
      "required": true
    },
    {
      "name": "additional_policy_json",
      "description": "",
      "required": false
    }
  ],
  "outputs": [
    "bucket_id",
    "policy_json"
  ],
  "hash": "ce11b8c0d0b0f01c1bb738d0c11d0e4c"
}
END_AI_METADATA -->
