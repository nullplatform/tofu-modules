mock_provider "helm" {}
mock_provider "kubernetes" {}

variables {
  dns_provider_name             = "azure"
  domain_filters                = "myorg.example.com"
  external_dns_namespace        = "external-dns"
  azure_client_id               = "00000000-0000-0000-0000-000000000001"
  azure_federated_credential_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/external-dns/federatedIdentityCredentials/external-dns"
  azure_subscription_id         = "00000000-0000-0000-0000-000000000002"
  azure_resource_group          = "rg-dns"
  azure_tenant_id               = "00000000-0000-0000-0000-000000000003"
}

run "azure_without_filters_renders_no_extra_args" {
  command = plan

  assert {
    condition     = !contains(keys(local.external_dns_values), "extraArgs")
    error_message = "Azure without label_filter or gateway_name must not render extraArgs, so existing releases see no values change"
  }
}

run "azure_zone_type_does_not_imply_label_filter" {
  command = plan

  variables {
    zone_type = "public"
  }

  assert {
    condition     = !contains(keys(local.external_dns_values), "extraArgs")
    error_message = "On Azure only an explicit label_filter adds --label-filter; zone_type must not derive one"
  }
}

run "azure_label_filter_adds_arg" {
  command = plan

  variables {
    label_filter = "dns/zone-type!=private"
  }

  assert {
    condition     = local.external_dns_values.extraArgs == tolist(["--label-filter=dns/zone-type!=private"])
    error_message = "Azure with label_filter should render exactly --label-filter=<label_filter>"
  }
}

run "azure_gateway_name_adds_arg" {
  command = plan

  variables {
    gateway_name = "gateway-public"
  }

  assert {
    condition     = local.external_dns_values.extraArgs == tolist(["--gateway-name=gateway-public"])
    error_message = "Azure with gateway_name should render exactly --gateway-name=<gateway_name>"
  }
}

run "azure_public_split_horizon_instance" {
  command = plan

  variables {
    sources      = ["gateway-httproute", "crd"]
    label_filter = "dns/zone-type!=private"
    gateway_name = "gateway-public"
  }

  assert {
    condition = local.external_dns_values.extraArgs == tolist([
      "--label-filter=dns/zone-type!=private",
      "--gateway-name=gateway-public",
    ])
    error_message = "Public split-horizon instance should filter DNSEndpoints by label and HTTPRoutes by gateway"
  }

  assert {
    condition     = local.external_dns_values.provider.name == "azure"
    error_message = "Public instance should keep the azure provider"
  }
}

run "azure_private_dns_label_filter_adds_arg" {
  command = plan

  variables {
    dns_provider_name = "azure-private-dns"
    type              = "private"
    label_filter      = "dns/zone-type=private"
  }

  assert {
    condition     = local.external_dns_values.extraArgs == tolist(["--label-filter=dns/zone-type=private"])
    error_message = "azure-private-dns should honor label_filter like azure"
  }

  assert {
    condition     = helm_release.external_dns.name == "external-dns-private"
    error_message = "Private instance release name should carry the type suffix"
  }
}

run "azure_private_dns_without_filters_renders_no_extra_args" {
  command = plan

  variables {
    dns_provider_name = "azure-private-dns"
    type              = "private"
  }

  assert {
    condition     = !contains(keys(local.external_dns_values), "extraArgs")
    error_message = "azure-private-dns without filters must not render extraArgs"
  }
}

run "azure_empty_label_filter_renders_no_arg" {
  command = plan

  variables {
    label_filter = ""
  }

  assert {
    condition     = !contains(keys(local.external_dns_values), "extraArgs")
    error_message = "An empty label_filter disables filtering and must not render --label-filter="
  }
}
