locals {
  nullplatform_base_values = templatefile("${path.module}/templates/nullplatform_base_values.tmpl.yaml", {
    api_key = nullplatform_api_key.nullplatform_agent_api_key.api_key
  })
}
