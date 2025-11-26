# Module: Route53

This module creates both public and private Route 53 hosted zones for DNS management. It also integrates with the
ACM module to automatically provision SSL certificates with DNS validation for the specified domain.

##Usage:

```hcl
module "route53" {
  source      = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/aws/route53?ref=v1.0.0"
  domain_name = var.domain_name
  vpc_id      = var.vpc_id
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

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_route53_acm"></a> [aws\_route53\_acm](#module\_aws\_route53\_acm) | ../acm | n/a |

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
| <a name="output_acm_certificate_arn"></a> [acm\_certificate\_arn](#output\_acm\_certificate\_arn) | The ARN of the ACM certificate associated with the Route 53 hosted zone |
| <a name="output_private_zone_id"></a> [private\_zone\_id](#output\_private\_zone\_id) | The ID of the private Route 53 hosted zone |
| <a name="output_private_zone_name"></a> [private\_zone\_name](#output\_private\_zone\_name) | The domain name of the private Route 53 hosted zone |
| <a name="output_public_zone_id"></a> [public\_zone\_id](#output\_public\_zone\_id) | The ID of the public Route 53 hosted zone |
| <a name="output_public_zone_name"></a> [public\_zone\_name](#output\_public\_zone\_name) | The domain name of the public Route 53 hosted zone |
<!-- END_TF_DOCS -->