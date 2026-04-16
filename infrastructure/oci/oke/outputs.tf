output "cluster_id" {
  description = "The OCID of the OKE cluster"
  value       = module.oke.cluster_id
}

output "cluster_endpoints" {
  description = "Endpoints for the OKE cluster"
  value       = module.oke.cluster_endpoints
}

output "cluster_ca_cert" {
  description = "OKE cluster CA certificate"
  value       = module.oke.cluster_ca_cert
}

output "ocir_workload_policy_id" {
  description = "The OCID of the OCIR workload identity policy (if enabled)"
  value       = var.enable_ocir_pull ? oci_identity_policy.ocir_workload_identity[0].id : null
}

output "ocir_nodes_policy_id" {
  description = "The OCID of the OCIR nodes policy (if enabled)"
  value       = var.enable_ocir_pull ? oci_identity_policy.ocir_nodes[0].id : null
}

output "ocir_policy_statements" {
  description = "All OCIR policy statements (if enabled)"
  value       = concat(local.ocir_workload_policy_statements, local.ocir_nodes_policy_statements)
}

output "ocir_dynamic_group_id" {
  description = "The OCID of the OCIR nodes dynamic group (if enabled)"
  value       = var.enable_ocir_pull ? oci_identity_dynamic_group.ocir_nodes[0].id : null
}

output "ocir_credential_provider_cloud_init" {
  description = "Cloud-init script to install OCIR credential provider on worker nodes (if enabled)"
  value       = local.ocir_credential_provider_cloud_init
}

output "ocir_kubelet_extra_args" {
  description = "Extra kubelet arguments needed for OCIR credential provider"
  value       = var.enable_ocir_pull ? "--image-credential-provider-bin-dir=/usr/local/bin/ --image-credential-provider-config=/etc/kubernetes/credential-provider-config.yaml" : ""
}
