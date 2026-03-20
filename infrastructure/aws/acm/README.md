# Module: acm

## Description

Creates an AWS ACM wildcard certificate with DNS validation via Route53

## Features

- Creates a wildcard ACM certificate for the specified domain
- Configures DNS validation using Route53 records
- Supports subject alternative names for additional domain coverage
- Automatically creates and manages validation records in Route53
- Implements lifecycle policy for safe certificate replacement
- Waits for certificate validation to complete before marking as ready

## Basic Usage

```hcl
module "acm" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/acm?ref=v1.46.0"

  domain_name = "your-domain-name"
  zone_id     = "your-zone-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.acm.acm_certificate_arn
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

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.cert_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.cert_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name for which to request the SSL certificate | `string` | n/a | yes |
| <a name="input_subject_alternative_names"></a> [subject\_alternative\_names](#input\_subject\_alternative\_names) | Alternative DNS to add | `list(string)` | `[]` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Route53 Zone ID where certificate will be validated | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_certificate_arn"></a> [acm\_certificate\_arn](#output\_acm\_certificate\_arn) | The ARN of the ACM certificate |
| <a name="output_acm_certificate_domain_name"></a> [acm\_certificate\_domain\_name](#output\_acm\_certificate\_domain\_name) | The domain name for which the ACM certificate is issued |
<!-- END_TF_DOCS -->
