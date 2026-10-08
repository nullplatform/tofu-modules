resource "terraform_data" "zone" {
  input = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/dnsZones/example.com"
}

module "iam" {
  source = "../../.."

  resource_group_name  = "rg-test"
  location             = "eastus2"
  name                 = "mi-test"
  oidc_issuer_url      = "https://oidc.example.com/abc/"
  namespace            = "nullplatform-tools"
  service_account_name = "nullplatform-agent"
  role_definition_name = "DNS Zone Contributor"
  scope                = terraform_data.zone.output
}

output "client_id" {
  value = module.iam.client_id
}
