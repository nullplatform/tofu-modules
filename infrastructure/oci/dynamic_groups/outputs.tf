output "dynamic_group_id" {
  description = "OCID of the created dynamic group"
  value       = oci_identity_dynamic_group.external_dns.id
}

output "dynamic_group_name" {
  description = "Name of the dynamic group"
  value       = oci_identity_dynamic_group.external_dns.name
}

output "policy_id" {
  description = "OCID of the created policy"
  value       = oci_identity_policy.external_dns.id
}

output "policy_name" {
  description = "Name of the policy"
  value       = oci_identity_policy.external_dns.name
}

output "external_dns_helm_values" {
  description = "Suggested values for the external-dns Helm chart"
  value       = <<-EOT
    provider: oracle
    oracle:
      compartmentOCID: ${var.compartment_id}
    serviceAccount:
      create: true
      name: ${var.external_dns_service_account}
      annotations:
        oci.oraclecloud.com/workload-identity: "true"
    extraArgs:
      - --txt-owner-id=${var.name_prefix}
  EOT
}
