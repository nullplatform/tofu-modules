# Module: oke

## Description

Provisions an Oracle Container Engine for Kubernetes (OKE) cluster on an existing VCN with configurable CNI, worker pools, and optional OCIR image pull authentication via workload identity

## Architecture

The module delegates cluster creation to the oracle-terraform-modules/oke/oci community module (v5.3.3), passing existing subnet IDs for the control plane, worker nodes, and service load balancers — and optionally a pod subnet when CNI is set to NPN. When enable_ocir_pull is true, the module also creates oci_identity_dynamic_group and oci_identity_policy resources for both workload identity and node-level OCIR access, and injects a credential provider cloud-init snippet into the worker_cloud_init list passed to the OKE module. OIDC discovery is unconditionally enabled on the cluster to support workload identity federation.

## Features

- Creates an OKE enhanced cluster reusing an existing VCN and pre-provisioned subnets for the API endpoint, worker nodes, and service load balancers
- Configures CNI as either Flannel or Native Pod Networking (NPN), conditionally attaching a dedicated pod subnet when NPN is selected
- Provisions OCI IAM dynamic groups and policies to allow worker nodes and Kubernetes workloads to pull images from OCIR using workload identity
- Injects an OCIR credential provider cloud-init script and kubelet extra arguments into worker nodes when OCIR pull is enabled
- Enables OIDC discovery on the cluster endpoint to support OCI workload identity federation for pod-level IAM access
- Supports fully customizable worker pool definitions including shape, OCPU, memory, boot volume size, and OS configuration
- Exposes cluster CA certificate, API endpoints, and all OCIR policy OCIDs as outputs for downstream consumer modules

## Basic Usage

```hcl
module "oke" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/oci/oke?ref=v9.13.1"

  api_endpoint_subnet_id = "your-api-endpoint-subnet-id"
  cluster_name           = "your-cluster-name"
  compartment_id         = "your-compartment-id"
  existing_vcn_id        = "your-existing-vcn-id"
  kubernetes_version     = "your-kubernetes-version"
  node_pool_subnet_id    = "your-node-pool-subnet-id"
  region                 = "your-region"
  service_lb_subnet_id   = "your-service-lb-subnet-id"
}
```

### Usage with Flannel CNI

```hcl
module "oke" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/oci/oke?ref=v9.13.1"

  api_endpoint_subnet_id = "your-api-endpoint-subnet-id"
  cluster_name           = "your-cluster-name"
  compartment_id         = "your-compartment-id"
  existing_vcn_id        = "your-existing-vcn-id"
  kubernetes_version     = "latest"
  node_pool_subnet_id    = "your-node-pool-subnet-id"
  region                 = "your-region"
  service_lb_subnet_id   = "your-service-lb-subnet-id"
}
```

### Usage with Fixed Kubernetes Version

```hcl
module "oke" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/oci/oke?ref=v9.13.1"

  api_endpoint_subnet_id = "your-api-endpoint-subnet-id"
  cluster_name           = "your-cluster-name"
  compartment_id         = "your-compartment-id"
  existing_vcn_id        = "your-existing-vcn-id"
  kubernetes_version     = "v1.34.1"
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
| <a name="provider_oci.home"></a> [oci.home](#provider\_oci.home) | 7.29.0 |

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
| <a name="input_home_region"></a> [home\_region](#input\_home\_region) | Deprecated, ignored: the module never read it. The home region reaches the module through the oci.home provider the caller passes in. | `string` | `null` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | No default: every install pins this deliberately — see VERSIONS.md. Kubernetes version of the OKE cluster, with the leading v. A default here would upgrade the control plane of every cluster that never set it the day the default moved, so the version is always the caller's decision. | `string` | n/a | yes |
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
  "description": "Provisions an Oracle Container Engine for Kubernetes (OKE) cluster on an existing VCN with configurable CNI, worker pools, and optional OCIR image pull authentication via workload identity",
  "architecture": "The module delegates cluster creation to the oracle-terraform-modules/oke/oci community module (v5.3.3), passing existing subnet IDs for the control plane, worker nodes, and service load balancers — and optionally a pod subnet when CNI is set to NPN. When enable_ocir_pull is true, the module also creates oci_identity_dynamic_group and oci_identity_policy resources for both workload identity and node-level OCIR access, and injects a credential provider cloud-init snippet into the worker_cloud_init list passed to the OKE module. OIDC discovery is unconditionally enabled on the cluster to support workload identity federation.",
  "features": [
    "Creates an OKE enhanced cluster reusing an existing VCN and pre-provisioned subnets for the API endpoint, worker nodes, and service load balancers",
    "Configures CNI as either Flannel or Native Pod Networking (NPN), conditionally attaching a dedicated pod subnet when NPN is selected",
    "Provisions OCI IAM dynamic groups and policies to allow worker nodes and Kubernetes workloads to pull images from OCIR using workload identity",
    "Injects an OCIR credential provider cloud-init script and kubelet extra arguments into worker nodes when OCIR pull is enabled",
    "Enables OIDC discovery on the cluster endpoint to support OCI workload identity federation for pod-level IAM access",
    "Supports fully customizable worker pool definitions including shape, OCPU, memory, boot volume size, and OS configuration",
    "Exposes cluster CA certificate, API endpoints, and all OCIR policy OCIDs as outputs for downstream consumer modules"
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
      "name": "kubernetes_version",
      "description": "No default: every install pins this deliberately — see VERSIONS.md. Kubernetes version of the OKE cluster, with the leading v. A default here would upgrade the control plane of every cluster that never set it the day the default moved, so the version is always the caller's decision.",
      "required": true
    },
    {
      "name": "cni_type",
      "description": "CNI type for the OKE cluster. Valid values: 'flannel' or 'npn' (Native Pod Networking).",
      "required": false
    },
    {
      "name": "home_region",
      "description": "Deprecated, ignored: the module never read it. The home region reaches the module through the oci.home provider the caller passes in.",
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
  "hash": "a99a4be01354845703aafec6d29a6025"
}
END_AI_METADATA -->
