# Module: dns

## Description

Creates and manages AWS Route53 public and/or private hosted zones for a given domain name

## Architecture

The module conditionally creates an aws_route53_zone resource for a public hosted zone and a separate aws_route53_zone resource for a private hosted zone based on boolean flags. The private zone resource includes a vpc block referencing the provided vpc_id to associate it with the specified VPC at creation time, with lifecycle ignore_changes on vpc to support additional cross-account associations managed externally. Outputs expose zone IDs, zone names, and nameservers for both zone types using the one() and try() functions to safely return null when a zone is disabled.

## Features

- Creates a public aws_route53_zone hosted zone for internet-facing DNS resolution
- Creates a private aws_route53_zone hosted zone associated with a specified VPC for internal DNS resolution
- Supports simultaneous creation of both public and private zones for the same domain
- Ignores post-creation VPC association changes to support cross-account hub-and-spoke Route53 configurations
- Outputs nameserver records for the public zone to facilitate domain delegation
- Enforces that at least one of the public or private zones must be enabled via input validation

## Basic Usage

```hcl
module "dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/dns?ref=v4.6.0"

  domain_name = "your-domain-name"
  vpc_id      = "your-vpc-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.dns.public_zone_id
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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.36.0 |

## Resources

| Name | Type |
|------|------|
| [aws_route53_zone.private_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route53_zone.public_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name to be managed | `string` | n/a | yes |
| <a name="input_enable_private_zone"></a> [enable\_private\_zone](#input\_enable\_private\_zone) | Whether to create the private dns zone. At least one of enable\_public\_zone or enable\_private\_zone must be true. | `bool` | `true` | no |
| <a name="input_enable_public_zone"></a> [enable\_public\_zone](#input\_enable\_public\_zone) | Whether to create the public dns zone. At least one of enable\_public\_zone or enable\_private\_zone must be true. | `bool` | `true` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nameservers"></a> [nameservers](#output\_nameservers) | NS records for the public hosted zone (null if disabled) |
| <a name="output_private_zone_id"></a> [private\_zone\_id](#output\_private\_zone\_id) | The ID of the private Route 53 hosted zone (null if disabled) |
| <a name="output_private_zone_name"></a> [private\_zone\_name](#output\_private\_zone\_name) | The domain name of the private Route 53 hosted zone (null if disabled) |
| <a name="output_public_zone_id"></a> [public\_zone\_id](#output\_public\_zone\_id) | The ID of the public Route 53 hosted zone (null if disabled) |
| <a name="output_public_zone_name"></a> [public\_zone\_name](#output\_public\_zone\_name) | The domain name of the public Route 53 hosted zone (null if disabled) |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "dns",
  "description": "Creates and manages AWS Route53 public and/or private hosted zones for a given domain name",
  "architecture": "The module conditionally creates an aws_route53_zone resource for a public hosted zone and a separate aws_route53_zone resource for a private hosted zone based on boolean flags. The private zone resource includes a vpc block referencing the provided vpc_id to associate it with the specified VPC at creation time, with lifecycle ignore_changes on vpc to support additional cross-account associations managed externally. Outputs expose zone IDs, zone names, and nameservers for both zone types using the one() and try() functions to safely return null when a zone is disabled.",
  "features": [
    "Creates a public aws_route53_zone hosted zone for internet-facing DNS resolution",
    "Creates a private aws_route53_zone hosted zone associated with a specified VPC for internal DNS resolution",
    "Supports simultaneous creation of both public and private zones for the same domain",
    "Ignores post-creation VPC association changes to support cross-account hub-and-spoke Route53 configurations",
    "Outputs nameserver records for the public zone to facilitate domain delegation",
    "Enforces that at least one of the public or private zones must be enabled via input validation"
  ],
  "inputs": [
    {
      "name": "vpc_id",
      "description": "The ID of the VPC",
      "required": true
    },
    {
      "name": "domain_name",
      "description": "The domain name to be managed",
      "required": true
    },
    {
      "name": "enable_public_zone",
      "description": "Whether to create the public dns zone. At least one of enable_public_zone or enable_private_zone must be true.",
      "required": false
    },
    {
      "name": "enable_private_zone",
      "description": "Whether to create the private dns zone. At least one of enable_public_zone or enable_private_zone must be true.",
      "required": false
    }
  ],
  "outputs": [
    "public_zone_id",
    "public_zone_name",
    "private_zone_id",
    "private_zone_name",
    "nameservers"
  ],
  "hash": "1b46d98a7254246dfd378f789427522f"
}
END_AI_METADATA -->
