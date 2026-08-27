############################################
# Rendered Helm Values (used in tests)
############################################

output "rendered_values" {
  description = "The rendered Helm values passed to the agent chart."
  value       = local.nullplatform_agent_values
  sensitive   = true
}

output "agent_repos" {
  description = "The comma-separated repository list handed to the agent's git command executor."
  value       = local.agent_repos
}
