# Module: dynamic_groups

## Description

Creates OCI dynamic groups and IAM policies for OKE Enhanced Workload Identity, enabling Kubernetes workloads to authenticate and access OCI resources

## Features

- Creates dynamic groups at tenancy level for OKE workload identity matching rules
- Generates IAM policies scoped to tenancy or compartment based on the compartment configuration
- Supports automatic DNS permissions for dns-zones and dns-records management
- Allows custom additional IAM policy statements for flexible resource access control
- Configures workload identity conditions based on cluster ID, namespace, and service account
- Automatically detects tenancy root compartment for proper policy scope configuration
- Provides reusable workload identity conditions output for custom policy creation

## Basic Usage

```hcl
module "dynamic_groups" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/oci/dynamic_groups?ref=v1.43.0"

  cluster_id      = "your-cluster-id"
  compartment_id  = "your-compartment-id"
  namespace       = "your-namespace"
  service_account = "your-service-account"
  tenancy_id      = "your-tenancy-id"
  workload_name   = "your-workload-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.dynamic_groups.dynamic_group_id
}
```

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
| [oci_identity_dynamic_group.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_dynamic_group) | resource |
| [oci_identity_policy.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_policy_statements"></a> [additional\_policy\_statements](#input\_additional\_policy\_statements) | Additional custom OCI IAM policy statements to apply | `list(string)` | `[]` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | OCID of the OKE cluster | `string` | n/a | yes |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment where resources are located | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags for resources | `map(string)` | `{}` | no |
| <a name="input_enable_dns_permissions"></a> [enable\_dns\_permissions](#input\_enable\_dns\_permissions) | Enable automatic DNS policy statements (inspect, read, use dns-zones and manage dns-records) | `bool` | `false` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags for resources | `map(string)` | `{}` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for resource names | `string` | `"oke"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace where the workload runs | `string` | n/a | yes |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | Name of the Kubernetes service account | `string` | n/a | yes |
| <a name="input_tenancy_id"></a> [tenancy\_id](#input\_tenancy\_id) | OCID of the tenancy (dynamic groups are created at tenancy level) | `string` | n/a | yes |
| <a name="input_workload_name"></a> [workload\_name](#input\_workload\_name) | Name of the workload (e.g., external-dns, cert-manager) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamic_group_id"></a> [dynamic\_group\_id](#output\_dynamic\_group\_id) | OCID of the created dynamic group |
| <a name="output_dynamic_group_name"></a> [dynamic\_group\_name](#output\_dynamic\_group\_name) | Name of the dynamic group |
| <a name="output_policy_id"></a> [policy\_id](#output\_policy\_id) | OCID of the created policy |
| <a name="output_policy_name"></a> [policy\_name](#output\_policy\_name) | Name of the policy |
| <a name="output_policy_scope"></a> [policy\_scope](#output\_policy\_scope) | The policy scope (tenancy or compartment) |
| <a name="output_policy_statements"></a> [policy\_statements](#output\_policy\_statements) | The policy statements applied |
| <a name="output_workload_identity_conditions"></a> [workload\_identity\_conditions](#output\_workload\_identity\_conditions) | The workload identity conditions for use in custom policies |
<!-- END_TF_DOCS -->
