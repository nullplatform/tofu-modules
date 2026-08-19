locals {
  # Strip null-valued attributes before handing the pools to the wrapped module.
  #
  # A declared `optional(...)` attribute with no default is not absent — it is
  # present as a key holding null. The wrapped module decides whether the caller
  # opted into cluster-wide autoscaling with `contains(keys(autoscaling.value),
  # "total_min_count")` rather than a null check (private-cluster/cluster.tf:558),
  # so passing the nulls through would read as "set" for every pool and null out
  # both the per-zone and the total node counts, leaving autoscaling unbounded.
  node_pools = [
    for pool in var.node_pools : { for k, v in pool : k => v if v != null }
  ]
}
