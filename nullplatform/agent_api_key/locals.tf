locals {
  nrn_without_namespace = join(":", slice(split(":", var.nrn), 0, 2))
  nrn_parts             = { for part in split(":", var.nrn) : split("=", part)[0] => split("=", part)[1] }
  nrn_tags = [
    for key in ["organization", "account", "namespace"] : {
      key   = key
      value = local.nrn_parts[key]
    } if contains(keys(local.nrn_parts), key)
  ]
}
