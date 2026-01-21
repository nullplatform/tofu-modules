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
