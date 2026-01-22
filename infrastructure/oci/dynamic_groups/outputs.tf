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
  value       = oci_identity_policy.this.id
}

output "policy_name" {
  description = "Name of the policy"
  value       = oci_identity_policy.this.name
}
