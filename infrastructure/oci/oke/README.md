# Module: oke

## Description

Creates an Oracle Kubernetes Engine (OKE) cluster in an existing VCN with configurable CNI types, worker pools, and optional OCIR image pull integration via workload identity

## Architecture

The module instantiates the oracle-terraform-modules/oke/oci module to create an oci_containerengine_cluster resource with enhanced cluster type and OIDC discovery enabled. When enable_ocir_pull is true, it creates oci_identity_policy and oci_identity_dynamic_group resources to grant workload identity permissions for OCIR access, and injects cloud-init scripts into worker nodes to install the OCIR credential provider with kubelet configuration. The module references existing subnet IDs for control plane (cp), workers, and load balancers (pub_lb), and conditionally adds a pods subnet when cni_type is set to npn for Native Pod Networking.

## Features

- Creates OKE enhanced cluster with OIDC discovery enabled for workload identity integration
- Configures CNI networking with either Flannel or Native Pod Networking (NPN) modes
- Integrates OCIR credential provider via cloud-init scripts with kubelet extra arguments for authenticated image pulls
- Provisions dynamic groups and IAM policies for workload-level OCIR access control per namespace
- Supports custom worker pool configurations with flexible shape, OCPU, memory, and boot volume sizing
- Manages control plane endpoint visibility with configurable public IP assignment and NSG associations

## Basic Usage

```hcl
module "oke" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/oci/oke?ref=v1.50.0"

  api_endpoint_subnet_id = "your-api-endpoint-subnet-id"
  cluster_name           = "your-cluster-name"
  compartment_id         = "your-compartment-id"
  existing_vcn_id        = "your-existing-vcn-id"
  home_region            = "your-home-region"
  node_pool_subnet_id    = "your-node-pool-subnet-id"
  region                 = "your-region"
  service_lb_subnet_id   = "your-service-lb-subnet-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.oke.cluster_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci.home"></a> [oci.home](#provider\_oci.home) | >= 5.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_oke"></a> [oke](#module\_oke) | oracle-terraform-modules/oke/oci | 5.3.3 |

## Resources

| Name | Type |
|------|------|
| [oci_identity_dynamic_group.ocir_nodes](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_dynamic_group) | resource |
| [oci_identity_policy.ocir_nodes](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) | resource |
| [oci_identity_policy.ocir_workload_identity](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_endpoint_subnet_id"></a> [api\_endpoint\_subnet\_id](#input\_api\_endpoint\_subnet\_id) | Subnet ID for the Kubernetes API endpoint (public subnet) | `string` | n/a | yes |
| <a name="input_assign_public_ip_to_control_plane"></a> [assign\_public\_ip\_to\_control\_plane](#input\_assign\_public\_ip\_to\_control\_plane) | Whether to assign a public IP to the control plane endpoint | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the OKE cluster | `string` | n/a | yes |
| <a name="input_cni_type"></a> [cni\_type](#input\_cni\_type) | CNI type for the OKE cluster. Valid values: 'flannel' or 'npn' (Native Pod Networking). | `string` | `"flannel"` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCI compartment ID where the OKE cluster will be created | `string` | n/a | yes |
| <a name="input_control_plane_is_public"></a> [control\_plane\_is\_public](#input\_control\_plane\_is\_public) | Whether the control plane endpoint is publicly accessible | `bool` | `false` | no |
| <a name="input_control_plane_nsg_ids"></a> [control\_plane\_nsg\_ids](#input\_control\_plane\_nsg\_ids) | Set of NSG IDs to associate with the control plane | `set(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_enable_ocir_pull"></a> [enable\_ocir\_pull](#input\_enable\_ocir\_pull) | Enable IAM policy to allow workloads to pull images from OCIR | `bool` | `false` | no |
| <a name="input_existing_vcn_id"></a> [existing\_vcn\_id](#input\_existing\_vcn\_id) | ID of the existing VCN to use for the OKE cluster | `string` | n/a | yes |
| <a name="input_home_region"></a> [home\_region](#input\_home\_region) | The tenancy's home region | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version for the OKE cluster | `string` | `"v1.34.1"` | no |
| <a name="input_node_pool_subnet_id"></a> [node\_pool\_subnet\_id](#input\_node\_pool\_subnet\_id) | Subnet ID for the worker node pool (private subnet) | `string` | n/a | yes |
| <a name="input_ocir_pull_namespaces"></a> [ocir\_pull\_namespaces](#input\_ocir\_pull\_namespaces) | List of Kubernetes namespaces allowed to pull from OCIR. If empty, all namespaces in the cluster are allowed. | `list(string)` | `[]` | no |
| <a name="input_pod_subnet_id"></a> [pod\_subnet\_id](#input\_pod\_subnet\_id) | Subnet ID for pod networking (required when cni\_type = 'npn'). | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | OCI region where the cluster is deployed | `string` | n/a | yes |
| <a name="input_service_lb_subnet_id"></a> [service\_lb\_subnet\_id](#input\_service\_lb\_subnet\_id) | Subnet ID for service load balancers (typically public subnet) | `string` | n/a | yes |
| <a name="input_tenancy_id"></a> [tenancy\_id](#input\_tenancy\_id) | The tenancy OCID (required when enable\_ocir\_pull is true) | `string` | `null` | no |
| <a name="input_worker_cloud_init"></a> [worker\_cloud\_init](#input\_worker\_cloud\_init) | Cloud init configuration for worker nodes. See: https://cloudinit.readthedocs.io/en/latest/reference/modules.html | `list(map(string))` | `[]` | no |
| <a name="input_worker_pool_size"></a> [worker\_pool\_size](#input\_worker\_pool\_size) | Default number of worker nodes per pool | `number` | `2` | no |
| <a name="input_worker_pools"></a> [worker\_pools](#input\_worker\_pools) | Map of worker pool configurations for the OKE cluster | `any` | <pre>{<br/>  "pool_principal": {<br/>    "boot_volume_size": 50,<br/>    "image_type": "platform",<br/>    "memory": 16,<br/>    "mode": "node-pool",<br/>    "ocpus": 2,<br/>    "os": "Oracle Linux",<br/>    "os_version": "8",<br/>    "shape": "VM.Standard.E4.Flex",<br/>    "size": 2<br/>  }<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_ca_cert"></a> [cluster\_ca\_cert](#output\_cluster\_ca\_cert) | OKE cluster CA certificate |
| <a name="output_cluster_endpoints"></a> [cluster\_endpoints](#output\_cluster\_endpoints) | Endpoints for the OKE cluster |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The OCID of the OKE cluster |
| <a name="output_ocir_credential_provider_cloud_init"></a> [ocir\_credential\_provider\_cloud\_init](#output\_ocir\_credential\_provider\_cloud\_init) | Cloud-init script to install OCIR credential provider on worker nodes (if enabled) |
| <a name="output_ocir_dynamic_group_id"></a> [ocir\_dynamic\_group\_id](#output\_ocir\_dynamic\_group\_id) | The OCID of the OCIR nodes dynamic group (if enabled) |
| <a name="output_ocir_kubelet_extra_args"></a> [ocir\_kubelet\_extra\_args](#output\_ocir\_kubelet\_extra\_args) | Extra kubelet arguments needed for OCIR credential provider |
| <a name="output_ocir_nodes_policy_id"></a> [ocir\_nodes\_policy\_id](#output\_ocir\_nodes\_policy\_id) | The OCID of the OCIR nodes policy (if enabled) |
| <a name="output_ocir_policy_statements"></a> [ocir\_policy\_statements](#output\_ocir\_policy\_statements) | All OCIR policy statements (if enabled) |
| <a name="output_ocir_workload_policy_id"></a> [ocir\_workload\_policy\_id](#output\_ocir\_workload\_policy\_id) | The OCID of the OCIR workload identity policy (if enabled) |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "oke",
  "description": "Creates an Oracle Kubernetes Engine (OKE) cluster in an existing VCN with configurable CNI types, worker pools, and optional OCIR image pull integration via workload identity",
  "architecture": "The module instantiates the oracle-terraform-modules/oke/oci module to create an oci_containerengine_cluster resource with enhanced cluster type and OIDC discovery enabled. When enable_ocir_pull is true, it creates oci_identity_policy and oci_identity_dynamic_group resources to grant workload identity permissions for OCIR access, and injects cloud-init scripts into worker nodes to install the OCIR credential provider with kubelet configuration. The module references existing subnet IDs for control plane (cp), workers, and load balancers (pub_lb), and conditionally adds a pods subnet when cni_type is set to npn for Native Pod Networking.",
  "features": [
    "Creates OKE enhanced cluster with OIDC discovery enabled for workload identity integration",
    "Configures CNI networking with either Flannel or Native Pod Networking (NPN) modes",
    "Integrates OCIR credential provider via cloud-init scripts with kubelet extra arguments for authenticated image pulls",
    "Provisions dynamic groups and IAM policies for workload-level OCIR access control per namespace",
    "Supports custom worker pool configurations with flexible shape, OCPU, memory, and boot volume sizing",
    "Manages control plane endpoint visibility with configurable public IP assignment and NSG associations"
  ],
  "inputs": [
    {
      "name": "compartment_id",
      "description": "OCI compartment ID where the OKE cluster will be created",
      "required": true
    },
    {
      "name": "region",
      "description": "OCI region where the cluster is deployed",
      "required": true
    },
    {
      "name": "existing_vcn_id",
      "description": "ID of the existing VCN to use for the OKE cluster",
      "required": true
    },
    {
      "name": "api_endpoint_subnet_id",
      "description": "Subnet ID for the Kubernetes API endpoint (public subnet)",
      "required": true
    },
    {
      "name": "node_pool_subnet_id",
      "description": "Subnet ID for the worker node pool (private subnet)",
      "required": true
    },
    {
      "name": "home_region",
      "description": "The tenancy's home region",
      "required": true
    },
    {
      "name": "cluster_name",
      "description": "Name of the OKE cluster",
      "required": true
    },
    {
      "name": "service_lb_subnet_id",
      "description": "Subnet ID for service load balancers (typically public subnet)",
      "required": true
    },
    {
      "name": "cni_type",
      "description": "CNI type for the OKE cluster. Valid values: 'flannel' or 'npn' (Native Pod Networking).",
      "required": false
    },
    {
      "name": "assign_public_ip_to_control_plane",
      "description": "Whether to assign a public IP to the control plane endpoint",
      "required": false
    },
    {
      "name": "control_plane_is_public",
      "description": "Whether the control plane endpoint is publicly accessible",
      "required": false
    },
    {
      "name": "control_plane_nsg_ids",
      "description": "Set of NSG IDs to associate with the control plane",
      "required": false
    },
    {
      "name": "worker_pools",
      "description": "Map of worker pool configurations for the OKE cluster",
      "required": false
    },
    {
      "name": "worker_pool_size",
      "description": "Default number of worker nodes per pool",
      "required": false
    },
    {
      "name": "kubernetes_version",
      "description": "Kubernetes version for the OKE cluster",
      "required": false
    },
    {
      "name": "pod_subnet_id",
      "description": "Subnet ID for pod networking (required when cni_type = 'npn').",
      "required": false
    },
    {
      "name": "worker_cloud_init",
      "description": "Cloud init configuration for worker nodes. See: https://cloudinit.readthedocs.io/en/latest/reference/modules.html",
      "required": false
    },
    {
      "name": "enable_ocir_pull",
      "description": "Enable IAM policy to allow workloads to pull images from OCIR",
      "required": false
    },
    {
      "name": "ocir_pull_namespaces",
      "description": "List of Kubernetes namespaces allowed to pull from OCIR. If empty, all namespaces in the cluster are allowed.",
      "required": false
    },
    {
      "name": "tenancy_id",
      "description": "The tenancy OCID (required when enable_ocir_pull is true)",
      "required": false
    }
  ],
  "outputs": [
    "cluster_id",
    "cluster_endpoints",
    "cluster_ca_cert",
    "ocir_workload_policy_id",
    "ocir_nodes_policy_id",
    "ocir_policy_statements",
    "ocir_dynamic_group_id",
    "ocir_credential_provider_cloud_init",
    "ocir_kubelet_extra_args"
  ],
  "hash": "6cc8d3c76707f0797f42c719103062c5"
}
END_AI_METADATA -->
