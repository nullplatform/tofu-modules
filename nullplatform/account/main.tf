resource "nullplatform_account" "nullplatform_account" {
  for_each = var.nullplatform_accounts

  name                = each.value.name
  repository_prefix   = each.value.repository_prefix
  repository_provider = each.value.repository_provider
  slug                = each.value.slug
}