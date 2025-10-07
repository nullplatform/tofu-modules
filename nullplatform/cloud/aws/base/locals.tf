locals {
  nullplatform_base_values = templatefile("${path.module}/templates/nullplatform-base-values.tmpl.yaml", {
    api_key = nullplatform_api_key.nullplatform-agent-api-key.api_key
  })
}
