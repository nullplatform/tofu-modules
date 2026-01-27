################################################################################
# Nullplatform Service Definition Agent Association API Key
################################################################################

locals {
  nrn_without_namespace = replace(var.nrn, ":namespace=.*$", "")

  # Parse NRN parts into individual tags: "organization=123:account=456:namespace=789"
  nrn_parts = { for part in split(":", var.nrn) : split("=", part)[0] => split("=", part)[1] }
  nrn_tags = [
    for key in ["organization", "account", "namespace"] : {
      key   = key
      value = local.nrn_parts[key]
    } if contains(keys(local.nrn_parts), key)
  ]
}

module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v1.24.0"

  name = "SERVICE-NOTIFICATION-CHANNEL-${upper(var.service_specification_slug)}"

  grants = [
    {
      nrn       = local.nrn_without_namespace
      role_slug = "controlplane:agent"
    },
    {
      nrn       = local.nrn_without_namespace
      role_slug = "admin"
    },
    {
      nrn       = local.nrn_without_namespace
      role_slug = "ops"
    }
  ]

  tags = concat(
    [
      {
        key   = "managedBy"
        value = "IaC"
      },
      {
        key   = "usedBy"
        value = upper(var.service_specification_slug)
      }
    ],
    local.nrn_tags
  )
}
