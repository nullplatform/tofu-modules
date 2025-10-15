
resource "helm_release" "istio_base" {
  name             = "istio-base"
  repository       = var.repository
  chart            = "base"
  namespace        = var.namespace
  create_namespace = true
  version          = var.istio_base_version
}

resource "helm_release" "istiod" {
  name       = "istiod"
  depends_on = [helm_release.istio_base]
  repository = var.repository
  chart      = "istiod"
  namespace  = var.namespace
  version    = var.istiod_version
}

# Setup Istio Gateway using Helm
resource "helm_release" "istio_ingressgateway" {
  name       = "istio-ingressgateway"
  depends_on = [helm_release.istiod]
  repository = var.repository
  chart      = "gateway"
  namespace  = var.namespace
  version    = var.istio_ingressgateway_version
  values     = [local.helm_values]
}
