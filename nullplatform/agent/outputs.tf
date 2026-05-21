############################################
# Rendered Helm Values (used in tests)
############################################

output "rendered_values" {
  description = "The rendered Helm values passed to the agent chart."
  value       = local.nullplatform_agent_values
  sensitive   = true
}
