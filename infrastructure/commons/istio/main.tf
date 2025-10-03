
resource "helm_release" "istio_base" {
  name             = "istio-base"
  repository       = local.repository
  chart            = "base"
  namespace        = local.namespace
  create_namespace = true
  version          = var.istio_base_version
}

resource "helm_release" "istiod" {
  name       = "istiod"
  depends_on = [helm_release.istio_base]
  repository = local.repository
  chart      = "istiod"
  namespace  = local.namespace
  version    = var.istiod_version
}

# Setup Istio Gateway using Helm
resource "helm_release" "istio_ingressgateway" {
  name       = "istio-ingressgateway"
  depends_on = [helm_release.istiod]
  repository = local.repository
  chart      = "gateway"
  namespace  = local.namespace
  version    = var.istio_ingressgateway_version

}
