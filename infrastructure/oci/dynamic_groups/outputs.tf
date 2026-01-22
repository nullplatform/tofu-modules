output "dynamic_group_id" {
  description = "OCID of the created dynamic group"
  value       = oci_identity_dynamic_group.this.id
}

output "dynamic_group_name" {
  description = "Name of the dynamic group"
  value       = oci_identity_dynamic_group.this.name
}

output "policy_id" {
  description = "OCID of the created policy"
  value       = length(oci_identity_policy.this) > 0 ? oci_identity_policy.this[0].id : null
}

output "policy_name" {
  description = "Name of the policy"
  value       = length(oci_identity_policy.this) > 0 ? oci_identity_policy.this[0].name : null
}

output "policy_statements" {
  description = "The policy statements applied"
  value       = local.final_policy_statements
}

output "policy_scope" {
  description = "The policy scope (tenancy or compartment)"
  value       = local.policy_scope
}

output "workload_identity_conditions" {
  description = "The workload identity conditions for use in custom policies"
  value       = local.workload_identity_conditions
}
