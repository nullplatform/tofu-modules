locals {
  nullplatform_base_values = templatefile(
    "${path.module}/templates/nullplatform_base_values.tmpl.yaml",
    {
      # ---- global ----
      k8s_provider        = var.k8s_provider
      installGatewayV2Crd = var.install_gateway_v2_crd ? "true" : "false"
      awsRegion           = var.aws_region

      # ---- tls ----
      tls_required = var.tls_required ? "true" : "false"

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
      gateway_public_oci_subnet                         = var.gateway_public_oci_subnet
      gateway_private_oci_subnet                        = var.gateway_private_oci_subnet

      # ---- nullplatform ----
      np_api_key = var.np_api_key
      # You left secretName empty in the template; if you want to make it configurable, add var.nullplatform_secret_name

      # ---- controlPlane ----
      controlPlane_enabled = var.control_plane_enabled ? "true" : "false"

      # ---- logging ----
      logging_enabled = var.logging_enabled ? "true" : "false"

      prometheus_enabled       = var.prometheus_enabled ? "true" : "false"
      exporter_prometheus_port = var.exporter_prometheus_port

      gelf_enabled = var.gelf_enabled ? "true" : "false"
      gelf_host    = var.gelf_host
      gelf_port    = var.gelf_port

      loki_enabled     = var.loki_enabled ? "true" : "false"
      loki_host        = var.loki_host
      loki_port        = var.loki_port
      loki_user        = var.loki_user
      loki_password    = var.loki_password
      loki_bearerToken = var.loki_bearer_token

      dynatrace_enabled       = var.dynatrace_enabled ? "true" : "false"
      dynatrace_apiKey        = var.dynatrace_api_key
      dynatrace_environmentid = var.dynatrace_environment_id

      datadog_enabled = var.datadog_enabled ? "true" : "false"
      datadog_apiKey  = var.datadog_api_key
      datadog_region  = var.datadog_region

      newrelic_enabled    = var.newrelic_enabled ? "true" : "false"
      newrelic_licenseKey = var.newrelic_license_key
      newrelic_region     = var.newrelic_region

      # ---- cloudwatch ----
      cloudwatch_enabled                    = var.cloudwatch_enabled ? "true" : "false"
      cloudwatch_logs_enabled               = var.cloudwatch_logs_enabled ? "true" : "false"
      cloudwatch_performancemetrics_enabled = var.cloudwatch_performance_metrics_enabled ? "true" : "false"
      cloudwatch_custommetrics_enabled      = var.cloudwatch_custom_metrics_enabled ? "true" : "false"
      cloudwatch_accesslogs_enabled         = var.cloudwatch_access_logs_enabled ? "true" : "false"

      # ---- metrics server ----
      metricsserver_enabled = var.metrics_server_enabled ? "true" : "false"

      # ---- gateways / gateway api ----
      gateways_enabled        = var.gateways_enabled ? "true" : "false"
      gatewayapi_enabled      = var.gateway_api_enabled ? "true" : "false"
      gatewayapi_crds_install = var.gateway_api_crds_install ? "true" : "false"

      # ---- image pull secrets ----
      imagePullSecrets_enabled  = var.image_pull_secrets_enabled ? "true" : "false"
      imagePullSecrets_registry = var.image_pull_secrets_registry
      imagePullSecrets_username = var.image_pull_secrets_username
      imagePullSecrets_password = var.image_pull_secrets_password
    }
  )
}
