# Module: gke

## Description

Deploys a private GKE cluster with a public endpoint, either as a standard cluster with manually managed node pools or as a GKE Autopilot cluster, with configurable node pools and security defaults

## Architecture

The module conditionally creates one of two mutually-exclusive submodules based on `autopilot_enabled`: `terraform-google-modules/kubernetes-engine/google//modules/private-cluster` for a standard cluster with manually managed `node_pools`, or `terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster` for a GKE Autopilot cluster (which has no `node_pools` concept — GCP provisions and scales nodes automatically per workload). Both submodules are configured with a private endpoint and public access, `authorized_ip_ranges`, and `deletion_protection_enabled`. The standard-mode `node_pools` entries accept `autoscaling`/`min_count`/`max_count` or a fixed `node_count`, plus `spot`/`preemptible` for lower-cost VMs. The module also creates a service account with Artifact Registry access and sets up logging and monitoring. Outputs are sourced from whichever of the two submodules was actually created.

## Features

- Creates GKE cluster with private endpoint and public access, in either standard or Autopilot mode via `autopilot_enabled`
- Configures node pools (standard mode) with machine type, disk size, and either an autoscaling min/max range or a fixed node count
- Supports spot and preemptible VMs per node pool for lower-cost, interruptible capacity
- Sets up security defaults including deletion protection and authorized IP ranges
- Creates service account with Artifact Registry access
- Configures logging and monitoring for the GKE cluster (standard mode)

## Basic Usage

```hcl
module "gke" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/gke?ref=v6.14.0"

  cluster_name      = "your-cluster-name"
  ip_range_pods     = "your-ip-range-pods"
  ip_range_services = "your-ip-range-services"
  location          = "your-location"
  project_id        = "your-project-id"
  vpc_name          = "your-vpc-name"
  vpc_subnet_name   = "your-vpc-subnet-name"
}
```

## Usage with Autopilot

```hcl
module "gke" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/gke?ref=v6.11.3"

  cluster_name      = "your-cluster-name"
  ip_range_pods     = "your-ip-range-pods"
  ip_range_services = "your-ip-range-services"
  location          = "your-location"
  project_id        = "your-project-id"
  vpc_name          = "your-vpc-name"
  vpc_subnet_name   = "your-vpc-subnet-name"

  autopilot_enabled = true
  # node_pools is ignored in this mode — GCP provisions and scales nodes per workload.
}
```

## Usage with Mixed On-Demand and Spot Node Pools

```hcl
module "gke" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/gke?ref=v6.11.3"

  cluster_name      = "your-cluster-name"
  ip_range_pods     = "your-ip-range-pods"
  ip_range_services = "your-ip-range-services"
  location          = "your-location"
  project_id        = "your-project-id"
  vpc_name          = "your-vpc-name"
  vpc_subnet_name   = "your-vpc-subnet-name"

  node_pools = [
    {
      name         = "pool-default"
      machine_type = "e2-medium"
      autoscaling  = false
      node_count   = 1
    },
    {
      name        = "pool-spot"
      machine_type = "e2-medium"
      autoscaling = true
      min_count   = 0
      max_count   = 2
      spot        = true
    },
  ]
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.gke.cluster_name
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gke"></a> [gke](#module\_gke) | terraform-google-modules/kubernetes-engine/google//modules/private-cluster | ~> 33.0 |
| <a name="module_gke_autopilot"></a> [gke\_autopilot](#module\_gke\_autopilot) | terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster | ~> 33.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorized_ip_ranges"></a> [authorized\_ip\_ranges](#input\_authorized\_ip\_ranges) | List of authorized IP ranges allowed to access the Kubernetes API server | <pre>list(object({<br/>    cidr_block   = string<br/>    display_name = string<br/>  }))</pre> | `[]` | no |
| <a name="input_autopilot_enabled"></a> [autopilot\_enabled](#input\_autopilot\_enabled) | Create a GKE Autopilot cluster instead of a standard cluster with manually managed node pools. When true, node\_pools is ignored — Autopilot provisions and scales nodes automatically per workload. | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the GKE cluster | `string` | n/a | yes |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | Whether to enable deletion protection for the GKE cluster | `bool` | `false` | no |
| <a name="input_ip_range_pods"></a> [ip\_range\_pods](#input\_ip\_range\_pods) | The name of the secondary IP range for pods | `string` | n/a | yes |
| <a name="input_ip_range_services"></a> [ip\_range\_services](#input\_ip\_range\_services) | The name of the secondary IP range for services | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The GCP region where the GKE cluster will be deployed (e.g., us-central1, europe-west1) | `string` | n/a | yes |
| <a name="input_master_ipv4_cidr_block"></a> [master\_ipv4\_cidr\_block](#input\_master\_ipv4\_cidr\_block) | The IP range in CIDR notation for the hosted master network (e.g., 172.16.0.0/28) | `string` | `"172.16.0.0/28"` | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | List of node pools to create in the GKE cluster (ignored when autopilot\_enabled is true) | <pre>list(object({<br/>    name         = string<br/>    machine_type = optional(string, "e2-medium")<br/>    disk_size_gb = optional(number, 100)<br/>    # When autoscaling is true (the default), the pool scales between<br/>    # min_count and max_count. When false, it holds a fixed node_count.<br/>    autoscaling = optional(bool, true)<br/>    min_count   = optional(number, 1)<br/>    max_count   = optional(number, 3)<br/>    node_count  = optional(number, 1)<br/>    # spot and preemptible are mutually exclusive lower-cost VM options;<br/>    # leave both false for regular on-demand nodes.<br/>    spot        = optional(bool, false)<br/>    preemptible = optional(bool, false)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "name": "default"<br/>  }<br/>]</pre> | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of labels to assign to the GKE cluster and related resources | `map(string)` | `{}` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the virtual private network | `string` | n/a | yes |
| <a name="input_vpc_subnet_name"></a> [vpc\_subnet\_name](#input\_vpc\_subnet\_name) | The name of the subnet where GKE nodes will be deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | The cluster CA certificate in base64 |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the GKE cluster |
| <a name="output_host"></a> [host](#output\_host) | The API server endpoint |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "gke",
  "description": "Deploys a private GKE cluster with a public endpoint and configures node pools and security defaults",
  "architecture": "The module uses the google-modules/kubernetes-engine/google//modules/private-cluster Terraform module to create a GKE cluster with a private endpoint and public access, and configures node pools and security defaults using variables such as node_pools, authorized_ip_ranges, and deletion_protection_enabled, the module also creates a service account with Artifact Registry access and sets up logging and monitoring",
  "features": [
    "Creates GKE cluster with private endpoint and public access",
    "Configures node pools with machine type, min and max count, and disk size",
    "Sets up security defaults including deletion protection and authorized IP ranges",
    "Creates service account with Artifact Registry access",
    "Configures logging and monitoring for the GKE cluster"
  ],
  "inputs": [
    {
      "name": "project_id",
      "description": "The GCP project ID",
      "required": true
    },
    {
      "name": "cluster_name",
      "description": "The name of the GKE cluster",
      "required": true
    },
    {
      "name": "location",
      "description": "The GCP region where the GKE cluster will be deployed (e.g., us-central1, europe-west1)",
      "required": true
    },
    {
      "name": "vpc_name",
      "description": "The name of the virtual private network",
      "required": true
    },
    {
      "name": "vpc_subnet_name",
      "description": "The name of the subnet where GKE nodes will be deployed",
      "required": true
    },
    {
      "name": "ip_range_pods",
      "description": "The name of the secondary IP range for pods",
      "required": true
    },
    {
      "name": "ip_range_services",
      "description": "The name of the secondary IP range for services",
      "required": true
    },
    {
      "name": "node_pools",
      "description": "List of node pools to create in the GKE cluster",
      "required": false
    },
    {
      "name": "authorized_ip_ranges",
      "description": "List of authorized IP ranges allowed to access the Kubernetes API server",
      "required": false
    },
    {
      "name": "master_ipv4_cidr_block",
      "description": "The IP range in CIDR notation for the hosted master network (e.g., 172.16.0.0/28)",
      "required": false
    },
    {
      "name": "deletion_protection_enabled",
      "description": "Whether to enable deletion protection for the GKE cluster",
      "required": false
    },
    {
      "name": "tags",
      "description": "A mapping of labels to assign to the GKE cluster and related resources",
      "required": false
    }
  ],
  "outputs": [
    "cluster_name",
    "host",
    "cluster_ca_certificate"
  ],
  "hash": "3a8f88496f630d3a62f596c796484df5"
}
END_AI_METADATA -->
