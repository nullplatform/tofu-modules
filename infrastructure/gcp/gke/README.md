# Module: gke

## Description

Provisions a private GKE cluster on GCP in either standard (manually managed node pools) or Autopilot mode, deployed into an existing VPC with private nodes and a public API endpoint

## Architecture

The module conditionally creates either a `terraform-google-modules/kubernetes-engine/google//modules/private-cluster` resource (standard mode) or a `terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster` resource (Autopilot mode) using count-based toggling on `var.autopilot_enabled`. In standard mode, node pools are derived from `var.node_pools` via a local that strips null-valued optional attributes before passing them to the wrapped module, which creates the cluster with private nodes, a dedicated service account with Artifact Registry access, and cloud logging disabled. A `moved` block preserves state addresses for consumers upgrading from a module version that lacked the count meta-argument, preventing destroy-and-recreate plans.

## Features

- Creates a private GKE cluster with private nodes and a public API endpoint using secondary IP ranges for pods and services
- Supports both standard clusters with manually managed node pools and fully managed Autopilot clusters via a single boolean toggle
- Configures per-pool autoscaling with both per-zone (min_count/max_count) and cluster-wide (total_min_count/total_max_count) bounds
- Creates a dedicated GCP service account with Artifact Registry read access for node image pulls
- Supports Spot and Preemptible node pool configurations with mutual exclusivity validation
- Applies node taints per pool and globally via node_pools_taints to control workload scheduling on cost-optimized nodes
- Restricts Kubernetes API server access to configurable authorized IP CIDR ranges

## Basic Usage

```hcl
module "gke" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/gke?ref=v7.2.0"

  cluster_name      = "your-cluster-name"
  ip_range_pods     = "your-ip-range-pods"
  ip_range_services = "your-ip-range-services"
  location          = "your-location"
  project_id        = "your-project-id"
  vpc_name          = "your-vpc-name"
  vpc_subnet_name   = "your-vpc-subnet-name"
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
  "description": "Provisions a private GKE cluster on GCP in either standard (manually managed node pools) or Autopilot mode, deployed into an existing VPC with private nodes and a public API endpoint",
  "architecture": "The module conditionally creates either a `terraform-google-modules/kubernetes-engine/google//modules/private-cluster` resource (standard mode) or a `terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster` resource (Autopilot mode) using count-based toggling on `var.autopilot_enabled`. In standard mode, node pools are derived from `var.node_pools` via a local that strips null-valued optional attributes before passing them to the wrapped module, which creates the cluster with private nodes, a dedicated service account with Artifact Registry access, and cloud logging disabled. A `moved` block preserves state addresses for consumers upgrading from a module version that lacked the count meta-argument, preventing destroy-and-recreate plans.",
  "features": [
    "Creates a private GKE cluster with private nodes and a public API endpoint using secondary IP ranges for pods and services",
    "Supports both standard clusters with manually managed node pools and fully managed Autopilot clusters via a single boolean toggle",
    "Configures per-pool autoscaling with both per-zone (min_count/max_count) and cluster-wide (total_min_count/total_max_count) bounds",
    "Creates a dedicated GCP service account with Artifact Registry read access for node image pulls",
    "Supports Spot and Preemptible node pool configurations with mutual exclusivity validation",
    "Applies node taints per pool and globally via node_pools_taints to control workload scheduling on cost-optimized nodes",
    "Restricts Kubernetes API server access to configurable authorized IP CIDR ranges"
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
      "description": "List of node pools to create in the GKE cluster (ignored when autopilot_enabled is true). min_count, max_count and node_count are PER ZONE and the cluster is regional, so they are multiplied by the number of zones in the region; use total_min_count/total_max_count for cluster-wide bounds",
      "required": false
    },
    {
      "name": "autopilot_enabled",
      "description": "Create a GKE Autopilot cluster instead of a standard cluster with manually managed node pools. When true, node_pools is ignored — Autopilot provisions and scales nodes automatically per workload.",
      "required": false
    },
    {
      "name": "node_pools_taints",
      "description": "Node taints by node-pool name, plus an optional 'all' key applied to every pool. Needed to keep ordinary workloads off spot/preemptible pools: GKE adds only labels to Spot nodes in standard clusters, and applies the cloud.google.com/gke-spot NoSchedule taint solely through node auto-provisioning, which is not this path. Pools absent from the map get no taints",
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
  "hash": "17a26f6dc8bf9c68938305ee95135be3"
}
END_AI_METADATA -->
