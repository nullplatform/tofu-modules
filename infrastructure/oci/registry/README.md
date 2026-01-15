<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | >= 5.0.0 |

## Resources

| Name | Type |
|------|------|
| [oci_artifacts_container_repository.repositories](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/artifacts_container_repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | The OCID of the compartment where the container repositories will be created | `string` | n/a | yes |
| <a name="input_container_repositories"></a> [container\_repositories](#input\_container\_repositories) | Map of container repositories to create. Key is used as identifier. | <pre>map(object({<br/>    display_name = string<br/>    is_public    = optional(bool, false)<br/>    is_immutable = optional(bool, false)<br/>    readme = optional(object({<br/>      content = string<br/>      format  = optional(string, "TEXT_MARKDOWN")<br/>    }), null)<br/>    defined_tags  = optional(map(string), {})<br/>    freeform_tags = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags to apply to all container repositories | `map(string)` | `{}` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags to apply to all container repositories | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_repositories"></a> [container\_repositories](#output\_container\_repositories) | Map of created container repositories with their details |
| <a name="output_container_repository_ids"></a> [container\_repository\_ids](#output\_container\_repository\_ids) | Map of container repository names to their OCIDs |
| <a name="output_container_repository_urls"></a> [container\_repository\_urls](#output\_container\_repository\_urls) | Map of container repository names to their full URLs (region.ocir.io/namespace/repo) |
<!-- END_TF_DOCS -->