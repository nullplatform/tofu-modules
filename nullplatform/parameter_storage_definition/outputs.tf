output "storage_configuration" {
  description = "Provider specification ID plus the per-instance provider configs (id, nrn, dimensions), keyed by instance key."
  value = {
    specification_id = nullplatform_provider_specification.parameter_storage_specification.id
    instances = {
      for key, instance in var.instances : key => {
        id         = module.parameter_storage_instance[key].provider_config_id
        nrn        = instance.nrn
        dimensions = instance.dimensions
      }
    }
  }
}