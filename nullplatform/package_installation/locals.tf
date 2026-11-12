locals {
  specification_ids = [
    for component in data.nullplatform_package.this.components : component.resource_id
    if component.resource_type == "service_specification"
  ]
}
