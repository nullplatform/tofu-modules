# Module: dns

## Description

Creates AWS Route53 public and/or private hosted zones for a given domain name

## Architecture

The module conditionally creates an aws_route53_zone resource for a public hosted zone and/or a private hosted zone based on boolean flags. The private aws_route53_zone includes a vpc block that associates it with the specified VPC using var.vpc_id. Both zones share the same domain name but differ in visibility, and outputs expose each zone's ID, name, and nameservers using Terraform's one() function for safe conditional access.

## Features

- Creates a public Route53 hosted zone for internet-facing DNS resolution
- Creates a private Route53 hosted zone scoped to a specific VPC for internal DNS resolution
- Supports enabling both public and private zones simultaneously for split-horizon DNS
- Validates that at least one of the public or private zone options is enabled
- Outputs nameservers for the public hosted zone to facilitate domain delegation

## Basic Usage

```hcl
module "dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/dns?ref=v4.5.0"

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
  "description": "Creates AWS Route53 public and/or private hosted zones for a given domain name",
  "architecture": "The module conditionally creates an aws_route53_zone resource for a public hosted zone and/or a private hosted zone based on boolean flags. The private aws_route53_zone includes a vpc block that associates it with the specified VPC using var.vpc_id. Both zones share the same domain name but differ in visibility, and outputs expose each zone's ID, name, and nameservers using Terraform's one() function for safe conditional access.",
  "features": [
    "Creates a public Route53 hosted zone for internet-facing DNS resolution",
    "Creates a private Route53 hosted zone scoped to a specific VPC for internal DNS resolution",
    "Supports enabling both public and private zones simultaneously for split-horizon DNS",
    "Validates that at least one of the public or private zone options is enabled",
    "Outputs nameservers for the public hosted zone to facilitate domain delegation"
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
  "hash": "07140b3e460ec51726b5dbccc4f7b627"
}
END_AI_METADATA -->
