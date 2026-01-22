locals {
  dynamic_group_name = "${var.name_prefix}-${var.workload_name}"

  # Matching rule for OKE Enhanced Workload Identity
  # Matches specific pods based on cluster, namespace and service account
  matching_rule = "ALL {resource.type='workloadidentity',resource.compartment.id='${var.compartment_id}',resource.cluster.id='${var.cluster_id}',resource.kubernetes.namespace='${var.namespace}',resource.kubernetes.serviceaccount='${var.service_account}'}"
}
