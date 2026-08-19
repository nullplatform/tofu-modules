# Module: gke

## Description

Deploys a private GKE cluster with a public endpoint, either as a standard cluster with manually managed node pools or as a GKE Autopilot cluster, with configurable node pools and security defaults

## Architecture

The module conditionally creates one of two mutually-exclusive submodules based on `autopilot_enabled`: `terraform-google-modules/kubernetes-engine/google//modules/private-cluster` for a standard cluster with manually managed `node_pools`, or `terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster` for a GKE Autopilot cluster (which has no `node_pools` concept — GCP provisions and scales nodes automatically per workload). Both submodules are configured with a private endpoint and public access, `authorized_ip_ranges`, and `deletion_protection_enabled`. The standard-mode `node_pools` entries accept `autoscaling`/`min_count`/`max_count` or a fixed `node_count`, plus `spot`/`preemptible` for lower-cost VMs. The module also creates a service account with Artifact Registry access. Standard clusters set `logging_service = "none"`, so Cloud Logging is disabled; the Autopilot submodule exposes no `logging_service` input and Autopilot does not permit disabling it, so an Autopilot cluster ingests system and workload logs. Outputs are sourced from whichever of the two submodules was actually created.

## Features

- Creates GKE cluster with private endpoint and public access, in either standard or Autopilot mode via `autopilot_enabled`
- Configures node pools (standard mode) with machine type, disk size, and either an autoscaling min/max range or a fixed node count
- Supports spot and preemptible VMs per node pool for lower-cost, interruptible capacity, with `node_pools_taints` to keep workloads off them
- Accepts cluster-wide autoscaling bounds via `total_min_count`/`total_max_count`, since `min_count`/`max_count` are per zone
- Sets up security defaults including deletion protection and authorized IP ranges
- Creates service account with Artifact Registry access
- Disables Cloud Logging on standard clusters (`logging_service = "none"`); Autopilot clusters always ingest system and workload logs and cannot disable it

## Basic Usage

```hcl
module "gke" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/gke?ref=v6.18.0"

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
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/gke?ref=v6.18.0"

  cluster_name      = "your-cluster-name"
  ip_range_pods     = "your-ip-range-pods"
  ip_range_services = "your-ip-range-services"
  location          = "your-location"
  project_id        = "your-project-id"
  vpc_name          = "your-vpc-name"
  vpc_subnet_name   = "your-vpc-subnet-name"

  autopilot_enabled = true
  # node_pools is ignored in this mode — GCP provisions and scales nodes per workload.

  # Without this the public control-plane endpoint accepts 0.0.0.0/0.
  authorized_ip_ranges = [{
    cidr_block   = "203.0.113.0/24"
    display_name = "office"
  }]
}
```

> **Switching an existing cluster into or out of Autopilot destroys it.** The two
> modes are different submodules, so flipping `autopilot_enabled` plans a destroy
> of the live cluster and a create of the new one. `deletion_protection_enabled`
> defaults to `false`, so nothing stops it. Treat the mode as fixed for the life of
> the cluster; to migrate, stand up a second cluster and move workloads across.

> **Autopilot clusters ingest system and workload logs.** Standard clusters here run
> with `logging_service = "none"`, but Autopilot does not allow disabling logging, so
> enabling it adds Cloud Logging ingestion cost the standard clusters never had.

## Usage with Mixed On-Demand and Spot Node Pools

```hcl
module "gke" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/gke?ref=v6.18.0"

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
      name         = "pool-spot"
      machine_type = "e2-medium"
      autoscaling  = true
      # Cluster-wide, not per zone. See the note below.
      total_min_count = 0
      total_max_count = 2
      spot            = true
    },
  ]

  # GKE does not taint spot nodes in standard clusters, so without this any pod
  # lacking a nodeSelector can be scheduled onto preemptible capacity.
  node_pools_taints = {
    pool-spot = [{
      key    = "cloud.google.com/gke-spot"
      value  = "true"
      effect = "NO_SCHEDULE"
    }]
  }
}
```

### Node counts are per zone

`location` is passed to the wrapped module as `region`, so every cluster this module
creates is **regional**. `min_count`, `max_count` and `node_count` map onto per-zone
provider attributes, so the effective cluster-wide size is the value multiplied by the
number of zones in the region — three, in most regions. A pool asking for
`node_count = 1` in `us-central1` gets three nodes.

Use `total_min_count`/`total_max_count` (set together) to express cluster-wide bounds
instead; when present they replace the per-zone pair.

### Keeping workloads off spot capacity

In **standard** clusters GKE adds only labels to Spot nodes
(`cloud.google.com/gke-spot=true`, `cloud.google.com/gke-provisioning=spot`) — it does
**not** add a `NoSchedule` taint. That taint is applied only to pools created by node
auto-provisioning, which is not this path. So a spot pool accepts any pod that does not
explicitly avoid it, including nullplatform system workloads, and those pods get
evicted on 15 seconds' notice when GCP reclaims the VM.

Taint the pool via `node_pools_taints` (as above) and add a matching toleration to the
workloads you actually want on spot. Autopilot handles taints and tolerations itself, so
this does not apply in Autopilot mode.

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
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 5.0 |

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
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | List of node pools to create in the GKE cluster (ignored when autopilot\_enabled is true). min\_count, max\_count and node\_count are PER ZONE and the cluster is regional, so they are multiplied by the number of zones in the region; use total\_min\_count/total\_max\_count for cluster-wide bounds | <pre>list(object({<br/>    name         = string<br/>    machine_type = optional(string, "e2-medium")<br/>    disk_size_gb = optional(number, 100)<br/>    # When autoscaling is true (the default), the pool scales between<br/>    # min_count and max_count. When false, it holds a fixed node_count.<br/>    autoscaling = optional(bool, true)<br/>    # PER ZONE. This module creates regional clusters (location is passed as<br/>    # region), so the effective cluster-wide count is these values multiplied by<br/>    # the number of zones in the region — three, in most regions. Use<br/>    # total_min_count/total_max_count instead to express cluster-wide bounds.<br/>    min_count = optional(number, 1)<br/>    max_count = optional(number, 3)<br/>    # PER ZONE, same multiplication as above. Only used when autoscaling is false.<br/>    node_count = optional(number, 1)<br/>    # Cluster-wide autoscaling bounds. When set, they replace the per-zone<br/>    # min_count/max_count. Must be set together.<br/>    total_min_count = optional(number)<br/>    total_max_count = optional(number)<br/>    # spot and preemptible are mutually exclusive lower-cost VM options;<br/>    # leave both false for regular on-demand nodes. Note that GKE does NOT taint<br/>    # spot nodes in standard clusters — it only labels them — so any pod without<br/>    # a nodeSelector can land on preemptible capacity. Use node_pools_taints to<br/>    # keep workloads off them.<br/>    spot        = optional(bool, false)<br/>    preemptible = optional(bool, false)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "name": "default"<br/>  }<br/>]</pre> | no |
| <a name="input_node_pools_taints"></a> [node\_pools\_taints](#input\_node\_pools\_taints) | Node taints by node-pool name, plus an optional 'all' key applied to every pool. Needed to keep ordinary workloads off spot/preemptible pools: GKE adds only labels to Spot nodes in standard clusters, and applies the cloud.google.com/gke-spot NoSchedule taint solely through node auto-provisioning, which is not this path. Pools absent from the map get no taints | <pre>map(list(object({<br/>    key    = string<br/>    value  = string<br/>    effect = string<br/>  })))</pre> | `{}` | no |
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
