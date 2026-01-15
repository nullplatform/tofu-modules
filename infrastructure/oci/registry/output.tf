output "container_repositories" {
  description = "Map of created container repositories with their details"
  value = {
    for key, repo in oci_artifacts_container_repository.repositories : key => {
      id                   = repo.id
      display_name         = repo.display_name
      namespace            = repo.namespace
      is_public            = repo.is_public
      is_immutable         = repo.is_immutable
      image_count          = repo.image_count
      layer_count          = repo.layer_count
      layers_size_in_bytes = repo.layers_size_in_bytes
      billable_size_in_gbs = repo.billable_size_in_gbs
      state                = repo.state
      time_created         = repo.time_created
    }
  }
}

output "container_repository_ids" {
  description = "Map of container repository names to their OCIDs"
  value       = { for key, repo in oci_artifacts_container_repository.repositories : key => repo.id }
}

output "container_repository_urls" {
  description = "Map of container repository names to their full URLs (region.ocir.io/namespace/repo)"
  value = {
    for key, repo in oci_artifacts_container_repository.repositories : key =>
    "${repo.namespace}/${repo.display_name}"
  }
}
