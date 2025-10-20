resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns/"
  chart            = "external-dns"
  namespace        = var.external_dns_namespace
  create_namespace = true
  version          = var.external_dns_version

  values = [local.external_dns_values]

}
