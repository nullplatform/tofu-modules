output "np_basepath" {
  description = "Directory the agent clones repos into. Pass it to scope_definition_agent_association.repo_path (with /nullplatform/scopes appended) and service_definition_agent_association.base_clone_path so legacy channel cmdlines match the image."
  value       = local.np_basepath
}
