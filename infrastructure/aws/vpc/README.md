# Module: VPC

This module creates a Virtual Private Cloud (VPC) with public and private subnets across multiple availability zones.  
It includes NAT gateway configuration for internet access from private subnets and appropriate tags for Kubernetes
integration.

## Usage

```hcl
module "vpc" {
  source       = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/aws/vpc?ref=v1.0.0"
  organization = var.organization
  account      = var.account

  vpc = var.vpc
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 6.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | The account name | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | The organization name | `string` | n/a | yes |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | The VPC configuration settings | <pre>object({<br/>    cidr_block      = string<br/>    azs             = list(string)<br/>    private_subnets = list(string)<br/>    public_subnets  = list(string)<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | The private subnets |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | The public subnets |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END_TF_DOCS -->