locals {
  nullplatform_routing_values = templatefile(
    "${path.module}/templates/nullplatform_routing_values.tmpl.yaml",
    {
      # ---- global ----
      k8s_provider        = var.k8s_provider
      installGatewayV2Crd = var.install_gateway_v2_crd ? "true" : "false"
      awsRegion           = var.aws_region

      # ---- namespaces ----
      nullplatformTools = var.namespace
      gateway_namespace = var.gateway_namespace

      # ---- ingress controllers ----
      ingress_public_enabled = var.ingressControllers.public.enabled ? "true" : "false"
      ingress_public_name    = var.ingressControllers.public.name
      ingress_public_scope   = var.ingressControllers.public.scope
      ingress_public_domain  = var.ingressControllers.public.domain

      ingress_private_enabled = var.ingressControllers.private.enabled ? "true" : "false"
      ingress_private_name    = var.ingressControllers.private.name
      ingress_private_scope   = var.ingressControllers.private.scope
      ingress_private_domain  = var.ingressControllers.private.domain

      # ---- gateway ----
      gateway_use_cluster_ip                      = var.gateway_use_cluster_ip ? "true" : "false"
      gateway_enabled                             = var.gateway_enabled ? "true" : "false"
      gateway_internal_enabled                    = var.gateway_internal_enabled ? "true" : "false"
      gateway_public_enabled                      = var.gateway_public_enabled ? "true" : "false"
      gateway_internal_azure_load_balancer_subnet = var.internal_azure_load_balancer_subnet
      gateway_public_aws_name                     = var.gateway_public_aws_name
      gateway_internal_aws_name                   = var.gateway_internal_aws_name
      gateway_public_aws_dns_name                 = var.gateway_public_aws_dns_name
      gateway_private_aws_dns_name                = var.gateway_private_aws_dns_name

      # ---- gateway security (AWS) ----
      gateway_public_aws_security_groups  = var.gateway_public_aws_security_group_id
      gateway_private_aws_security_groups = var.gateway_private_aws_security_group_id

      # ---- gateway security (Azure) ----
      gateway_public_azure_nsg  = var.gateway_public_azure_nsg_id
      gateway_private_azure_nsg = var.gateway_private_azure_nsg_id

      # ---- gateway security (GCP) ----
      gateway_public_gcp_firewall  = var.gateway_public_gcp_firewall_name
      gateway_private_gcp_firewall = var.gateway_private_gcp_firewall_name

      # ---- gateway security (OCI) ----
      gateway_public_oci_security_list_management_mode  = var.gateway_public_oci_security_list_management_mode
      gateway_private_oci_security_list_management_mode = var.gateway_private_oci_security_list_management_mode

      # ---- gateways / gateway api ----
      gateways_enabled        = var.gateways_enabled ? "true" : "false"
      gatewayapi_enabled      = var.gateway_api_enabled ? "true" : "false"
      gatewayapi_crds_install = var.gateway_api_crds_install ? "true" : "false"
    }
  )
}
