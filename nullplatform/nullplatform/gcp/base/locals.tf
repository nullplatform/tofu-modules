locals {
  nrn_without_namespace = join(":", slice(split(":", var.nrn), 0, 2))
  nullplatform_base_values = templatefile("${path.module}/templates/nullplatform-base-values.tmpl.yaml", {
    api_key = nullplatform_api_key.nullplatform-base-api-key.api_key

  })
}