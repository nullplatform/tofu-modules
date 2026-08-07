# Module: dynamic_groups

## Description

Creates and configures OCI resources for OKE workload identity

## Architecture

This module creates an OCI dynamic group and an OCI identity policy, connecting them internally through the dynamic group's matching rule and the policy's statements. The dynamic group is created at the tenancy level, while the policy is created in the specified compartment. The module uses Terraform resources such as oci_identity_dynamic_group and oci_identity_policy to manage these OCI resources. The inputs, such as tenancy ID, compartment ID, cluster ID, workload name, namespace, and service account, flow into these resources to configure them correctly.

## Features

- Creates OCI dynamic group for workload identity
- Configures OCI identity policy with custom statements
- Supports automatic DNS policy statements for workload identity
- Manages OCI resources with defined and freeform tags

## Basic Usage

```hcl
module "dynamic_groups" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/oci/dynamic_groups?ref=v6.11.0"

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
| <a name="provider_oci"></a> [oci](#provider\_oci) | 7.30.0 |

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

<!-- BEGIN_AI_METADATA
{
  "name": "dynamic_groups",
  "description": "Creates and configures OCI resources for OKE workload identity",
  "architecture": "This module creates an OCI dynamic group and an OCI identity policy, connecting them internally through the dynamic group's matching rule and the policy's statements. The dynamic group is created at the tenancy level, while the policy is created in the specified compartment. The module uses Terraform resources such as oci_identity_dynamic_group and oci_identity_policy to manage these OCI resources. The inputs, such as tenancy ID, compartment ID, cluster ID, workload name, namespace, and service account, flow into these resources to configure them correctly.",
  "features": [
    "Creates OCI dynamic group for workload identity",
    "Configures OCI identity policy with custom statements",
    "Supports automatic DNS policy statements for workload identity",
    "Manages OCI resources with defined and freeform tags"
  ],
  "inputs": [
    {
      "name": "tenancy_id",
      "description": "OCID of the tenancy (dynamic groups are created at tenancy level)",
      "required": true
    },
    {
      "name": "compartment_id",
      "description": "OCID of the compartment where resources are located",
      "required": true
    },
    {
      "name": "cluster_id",
      "description": "OCID of the OKE cluster",
      "required": true
    },
    {
      "name": "workload_name",
      "description": "Name of the workload (e.g., external-dns, cert-manager)",
      "required": true
    },
    {
      "name": "namespace",
      "description": "Kubernetes namespace where the workload runs",
      "required": true
    },
    {
      "name": "service_account",
      "description": "Name of the Kubernetes service account",
      "required": true
    },
    {
      "name": "enable_dns_permissions",
      "description": "Enable automatic DNS policy statements (inspect, read, use dns-zones and manage dns-records)",
      "required": false
    },
    {
      "name": "additional_policy_statements",
      "description": "Additional custom OCI IAM policy statements to apply",
      "required": false
    },
    {
      "name": "name_prefix",
      "description": "Prefix for resource names",
      "required": false
    },
    {
      "name": "defined_tags",
      "description": "Defined tags for resources",
      "required": false
    },
    {
      "name": "freeform_tags",
      "description": "Freeform tags for resources",
      "required": false
    }
  ],
  "outputs": [
    "dynamic_group_id",
    "dynamic_group_name",
    "policy_id",
    "policy_name",
    "policy_statements",
    "policy_scope",
    "workload_identity_conditions"
  ],
  "hash": "096e324935eddde4906185f61174b43d"
}
END_AI_METADATA -->
