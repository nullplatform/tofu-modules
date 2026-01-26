################################################################################
# Nullplatform Service Definition Agent Association API Key
################################################################################

locals {
  nrn_without_namespace = replace(var.nrn, ":namespace=.*$", "")
}

module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=main"

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

  tags = [
    {
      key   = "managedBy"
      value = "IaC"
    },
    {
      key   = "level"
      value = var.nrn
    },
    {
      key   = "usedBy"
      value = "${upper(var.service_specification_slug)}"
    }
  ]
}
