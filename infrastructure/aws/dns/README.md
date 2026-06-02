# Module: dns

## Description

Creates public and private Route 53 zones for a given domain name and VPC ID

## Architecture

This module creates two aws_route53_zone resources, one for a public zone and one for a private zone, with the private zone associated with the provided VPC ID. The domain name is used to configure both zones. The module also outputs the IDs and names of both zones, as well as the nameservers for the public zone. The internal data flow involves creating the zones and then outputting their properties.

## Features

- Creates public Route 53 zone with DNS validation
- Configures private Route 53 zone with VPC association
- Outputs zone IDs and names for further use

## Basic Usage

```hcl
module "dns" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/dns?ref=v3.5.2"

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
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nameservers"></a> [nameservers](#output\_nameservers) | NS records for the public hosted zone |
| <a name="output_private_zone_id"></a> [private\_zone\_id](#output\_private\_zone\_id) | The ID of the private Route 53 hosted zone |
| <a name="output_private_zone_name"></a> [private\_zone\_name](#output\_private\_zone\_name) | The domain name of the private Route 53 hosted zone |
| <a name="output_public_zone_id"></a> [public\_zone\_id](#output\_public\_zone\_id) | The ID of the public Route 53 hosted zone |
| <a name="output_public_zone_name"></a> [public\_zone\_name](#output\_public\_zone\_name) | The domain name of the public Route 53 hosted zone |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "dns",
  "description": "Creates public and private Route 53 zones for a given domain name and VPC ID",
  "architecture": "This module creates two aws_route53_zone resources, one for a public zone and one for a private zone, with the private zone associated with the provided VPC ID. The domain name is used to configure both zones. The module also outputs the IDs and names of both zones, as well as the nameservers for the public zone. The internal data flow involves creating the zones and then outputting their properties.",
  "features": [
    "Creates public Route 53 zone with DNS validation",
    "Configures private Route 53 zone with VPC association",
    "Outputs zone IDs and names for further use"
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
    }
  ],
  "outputs": [
    "public_zone_id",
    "public_zone_name",
    "private_zone_id",
    "private_zone_name",
    "acm_certificate_arn",
    "nameservers"
  ],
  "hash": "c3e8245ecf0fd53ae95cc03303b5bf9b"
}
END_AI_METADATA -->
