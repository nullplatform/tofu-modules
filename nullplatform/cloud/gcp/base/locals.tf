locals {
  nrn_without_namespace = join(":", slice(split(":", var.nrn), 0, 2))
  nullplatform_base_values = templatefile("${path.module}/templates/nullplatform_base_values.tmpl.yaml", {
    api_key = nullplatform_api_key.nullplatform_base_api_key.api_key

  })
}