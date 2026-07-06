locals {
  config = jsondecode(data.external.parameter_storage_spec.result.json)

  spec_visible_to = distinct(concat(
    [var.nrn],
    var.extra_visible_to_nrns,
  ))
}
