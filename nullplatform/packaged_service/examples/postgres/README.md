<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_packaged_service"></a> [packaged\_service](#module\_packaged\_service) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [nullplatform_link_specification.postgres_link](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/link_specification) | resource |
| [nullplatform_service_specification.postgres_service](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/service_specification) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | n/a | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Owner NRN — organization=…:account=…:namespace=… the package lives in. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_package_default_version"></a> [package\_default\_version](#output\_package\_default\_version) | n/a |
| <a name="output_package_id"></a> [package\_id](#output\_package\_id) | n/a |
| <a name="output_package_slug"></a> [package\_slug](#output\_package\_slug) | n/a |
<!-- END_TF_DOCS -->