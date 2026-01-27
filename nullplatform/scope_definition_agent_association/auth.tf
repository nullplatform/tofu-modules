################################################################################
# Nullplatform Scope Definition Agent Association API Key
################################################################################

module "api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v1.24.0"

  name = "SCOPE-NOTIFICATION-CHANNEL-${upper(var.scope_specification_slug)}"

  grants = [
    {
      nrn       = local.nrn_without_namespace
      role_slug = "controlplane:agent"
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
        value = upper(var.scope_specification_slug)
      }
    ],
    local.nrn_tags
  )
}