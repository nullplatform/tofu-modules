
# Module: Azure Cloud
This resource defines an Oracle Cloud Infrastructure (OCI) provider configuration in Nullplatform. It registers the OCI account, compartment, and networking details required for Nullplatform to manage resources in OCI.

The configuration includes account and region information, the target compartment, and domain settings for networking. Attributes are JSON-encoded and changes to them are ignored after creation to prevent unnecessary updates.

### Basic example

```hcl
module "cloud_azure" {
  source                    = "git::https://github.com/nullplatform/tofu-modules.git///nullplatform/cloud/oci/cloud?ref=v1.0.0"
  nrn                       = "organization=xxxxx:account=xxxx"
  account_id                = "ocid1.tenancy.oc1..aaaaaaaaim2j6bxtwrlc7s4ii4gntgbwhyoxtvm4cf7zzmvyar3on2ba3olq"
  account_name              = "nullplatformoci"
  account_region            = "us-ashburn-1"
  compartment_id            = "ocid1.compartment.oc1..aaaaaaaexamplecompartmentocid1234567890abcdefghijk"
  compartment_name          = "oci"
  domain_name               = "oci.domain.com"
  private_domain_name       = "internal.domian.com"

}
```



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | ~> 0.0.63 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.oci](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | OCI tenancy/account OCID | `string` | n/a | yes |
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | OCI account/tenancy name | `string` | n/a | yes |
| <a name="input_account_region"></a> [account\_region](#input\_account\_region) | OCI region where resources will be deployed | `string` | n/a | yes |
| <a name="input_application_domain"></a> [application\_domain](#input\_application\_domain) | Whether to apply application domain | `bool` | `false` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCI compartment OCID where resources will be created | `string` | n/a | yes |
| <a name="input_compartment_name"></a> [compartment\_name](#input\_compartment\_name) | OCI compartment name | `string` | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimensions for the provider configuration | `map(any)` | `{}` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name for the configuration | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Identifier Nullplatform Resources Name | `string` | n/a | yes |
| <a name="input_private_domain_name"></a> [private\_domain\_name](#input\_private\_domain\_name) | Private domain name | `string` | `""` | no |
<!-- END_TF_DOCS -->