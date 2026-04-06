# Module: acm

## Description

This module creates an ACM certificate with DNS validation in Route53

## Architecture

The module creates an aws_acm_certificate resource with DNS validation, which is then validated using an aws_acm_certificate_validation resource. The validation is performed by creating aws_route53_record resources for each domain validation option. The zone_id and domain_name variables are used to configure the aws_route53_record resources and the aws_acm_certificate resource, respectively. The subject_alternative_names variable is used to configure the subject alternative names for the ACM certificate.

## Features

- Creates ACM certificate with DNS validation in Route53
- Configures DNS validation records in Route53
- Supports wildcard certificates via subject alternative names

## Basic Usage

```hcl
module "acm" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/acm?ref=v1.51.0"

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

<!-- BEGIN_AI_METADATA
{
  "name": "acm",
  "description": "This module creates an ACM certificate with DNS validation in Route53",
  "architecture": "The module creates an aws_acm_certificate resource with DNS validation, which is then validated using an aws_acm_certificate_validation resource. The validation is performed by creating aws_route53_record resources for each domain validation option. The zone_id and domain_name variables are used to configure the aws_route53_record resources and the aws_acm_certificate resource, respectively. The subject_alternative_names variable is used to configure the subject alternative names for the ACM certificate.",
  "features": [
    "Creates ACM certificate with DNS validation in Route53",
    "Configures DNS validation records in Route53",
    "Supports wildcard certificates via subject alternative names"
  ],
  "inputs": [
    {
      "name": "zone_id",
      "description": "Route53 Zone ID where certificate will be validated",
      "required": true
    },
    {
      "name": "domain_name",
      "description": "The domain name for which to request the SSL certificate",
      "required": true
    },
    {
      "name": "subject_alternative_names",
      "description": "Alternative DNS to add",
      "required": false
    }
  ],
  "outputs": [
    "acm_certificate_arn",
    "acm_certificate_domain_name"
  ],
  "hash": "10bfabad3403adb463c8d774069a1d04"
}
END_AI_METADATA -->
