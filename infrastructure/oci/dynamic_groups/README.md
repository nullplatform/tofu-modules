<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | >= 5.0.0 |

## Resources

| Name | Type |
|------|------|
| [oci_identity_dynamic_group.external_dns](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_dynamic_group) | resource |
| [oci_identity_policy.external_dns](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | OCID del cluster OKE | `string` | n/a | yes |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID del compartment donde están los recursos (cluster, DNS zones) | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags para los recursos | `map(string)` | `{}` | no |
| <a name="input_dns_zone_ids"></a> [dns\_zone\_ids](#input\_dns\_zone\_ids) | Lista de OCIDs de las DNS zones que external-dns puede gestionar (opcional, si no se especifica permite todas en el compartment) | `list(string)` | `[]` | no |
| <a name="input_external_dns_namespace"></a> [external\_dns\_namespace](#input\_external\_dns\_namespace) | Namespace de Kubernetes donde corre external-dns | `string` | `"external-dns"` | no |
| <a name="input_external_dns_service_account"></a> [external\_dns\_service\_account](#input\_external\_dns\_service\_account) | Nombre del service account de external-dns | `string` | `"external-dns"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags para los recursos | `map(string)` | `{}` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefijo para los nombres de los recursos | `string` | `"oke"` | no |
| <a name="input_tenancy_id"></a> [tenancy\_id](#input\_tenancy\_id) | OCID del tenancy (los dynamic groups se crean a nivel de tenancy) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamic_group_id"></a> [dynamic\_group\_id](#output\_dynamic\_group\_id) | OCID del dynamic group creado |
| <a name="output_dynamic_group_name"></a> [dynamic\_group\_name](#output\_dynamic\_group\_name) | Nombre del dynamic group |
| <a name="output_external_dns_helm_values"></a> [external\_dns\_helm\_values](#output\_external\_dns\_helm\_values) | Valores sugeridos para el Helm chart de external-dns |
| <a name="output_policy_id"></a> [policy\_id](#output\_policy\_id) | OCID de la policy creada |
| <a name="output_policy_name"></a> [policy\_name](#output\_policy\_name) | Nombre de la policy |
<!-- END_TF_DOCS -->