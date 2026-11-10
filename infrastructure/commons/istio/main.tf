locals {
  # Field names are the ones the logs-controller envoy parser reads; keep them in sync with
  # k8s-tools logs-controller/deploy/istio-mesh-config.yaml.
  gateway_access_log_provider = {
    name = "np-gateway-access-log"
    envoyFileAccessLog = {
      path = "/dev/stdout"
      logFormat = {
        labels = {
          start_time                        = "%START_TIME%"
          method                            = "%REQ(:METHOD)%"
          path                              = "%REQ(X-ENVOY-ORIGINAL-PATH?:PATH)%"
          protocol                          = "%PROTOCOL%"
          code                              = "%RESPONSE_CODE%"
          response_flags                    = "%RESPONSE_FLAGS%"
          response_code_details             = "%RESPONSE_CODE_DETAILS%"
          connection_termination_details    = "%CONNECTION_TERMINATION_DETAILS%"
          upstream_transport_failure_reason = "%UPSTREAM_TRANSPORT_FAILURE_REASON%"
          bytes_received                    = "%BYTES_RECEIVED%"
          size                              = "%BYTES_SENT%"
          response_time                     = "%DURATION%"
          upstream_service_time             = "%RESP(X-ENVOY-UPSTREAM-SERVICE-TIME)%"
          x_forwarded_for                   = "%REQ(X-FORWARDED-FOR)%"
          agent                             = "%REQ(USER-AGENT)%"
          request_id                        = "%REQ(X-REQUEST-ID)%"
          authority                         = "%REQ(:AUTHORITY)%"
          upstream_host                     = "%UPSTREAM_HOST%"
          upstream_cluster                  = "%UPSTREAM_CLUSTER_RAW%"
          upstream_local_address            = "%UPSTREAM_LOCAL_ADDRESS%"
          downstream_local_address          = "%DOWNSTREAM_LOCAL_ADDRESS%"
          remote                            = "%DOWNSTREAM_REMOTE_ADDRESS%"
          requested_server_name             = "%REQUESTED_SERVER_NAME%"
          route_name                        = "%ROUTE_NAME%"
        }
      }
    }
  }
}


resource "helm_release" "istio_base" {
  name       = "istio-base"
  repository = var.repository
  chart      = "base"
  namespace  = var.namespace
  version    = var.istio_base_version

  create_namespace  = true
  disable_webhooks  = false
  force_update      = true
  wait              = true
  wait_for_jobs     = true
  timeout           = 600
  atomic            = true
  cleanup_on_fail   = true
  replace           = true
  recreate_pods     = true
  reset_values      = true
  reuse_values      = false
  dependency_update = true
  max_history       = 10

}

resource "helm_release" "istiod" {
  name       = "istiod"
  depends_on = [helm_release.istio_base]
  repository = var.repository
  chart      = "istiod"
  namespace  = var.namespace
  version    = var.istiod_version

  create_namespace  = true
  disable_webhooks  = false
  force_update      = true
  wait              = true
  wait_for_jobs     = true
  timeout           = 600
  atomic            = true
  cleanup_on_fail   = true
  replace           = true
  recreate_pods     = true
  reset_values      = true
  reuse_values      = false
  dependency_update = true
  max_history       = 10

  values = var.gateway_access_log_enabled ? [yamlencode({
    meshConfig = { extensionProviders = [local.gateway_access_log_provider] }
  })] : []

  # Enforce HA on istiod. The chart's HPA is enabled by default with
  # autoscaleMin=1, so setting only replicaCount is not enough — the HPA
  # would scale it back to 1 and re-block any node drain (istiod PDB has
  # minAvailable=1). Setting autoscaleMin locks in the floor.
  set = [
    {
      name  = "pilot.replicaCount"
      value = var.istiod_replicas
    },
    {
      name  = "pilot.autoscaleMin"
      value = var.istiod_replicas
    },
  ]
}
