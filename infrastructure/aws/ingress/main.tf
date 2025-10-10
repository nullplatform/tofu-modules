resource "kubernetes_ingress_v1" "internal" {
  metadata {
    name      = "initial-ingress-setup-internal"
    namespace = "nullplatform"

    annotations = merge({
      "alb.ingress.kubernetes.io/actions.response-404" = jsonencode({
        type = "fixed-response"
        fixedResponseConfig = {
          contentType = "text/plain"
          statusCode  = "404"
          messageBody = "404 scope not found or has not been deployed yet"
        }
      })
      "alb.ingress.kubernetes.io/group.name"         = "k8s-nullplatform-internal"
      "alb.ingress.kubernetes.io/listen-ports"       = "[{\"HTTP\":80},{\"HTTPS\":443}]"
      "alb.ingress.kubernetes.io/load-balancer-name" = "k8s-nullplatform-internal"
      "alb.ingress.kubernetes.io/scheme"             = "internal"
      "alb.ingress.kubernetes.io/ssl-redirect"       = "443"
      "alb.ingress.kubernetes.io/target-type"        = "ip"
      "alb.ingress.kubernetes.io/certificate-arn"    = var.certificate_arn
    })
  }

  spec {
    ingress_class_name = "alb"

    rule {
      host = "setup.nullapps.io"
      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "response-404"
              port {
                name = "use-annotation"
              }
            }
          }
        }
      }
    }
  }
}

resource "null_resource" "remove_finalizer_internal" {
  triggers = {
    ingress_name = kubernetes_ingress_v1.internal.metadata[0].name
    namespace    = kubernetes_ingress_v1.internal.metadata[0].namespace
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kubectl patch ingress ${self.triggers.ingress_name} -n ${self.triggers.namespace} -p '{\"metadata\":{\"finalizers\":[]}}' --type=merge || true"
  }
}

resource "kubernetes_ingress_v1" "public" {
  metadata {
    name      = "initial-ingress-setup-public"
    namespace = "nullplatform"

    annotations = merge({
      "alb.ingress.kubernetes.io/actions.response-404" = jsonencode({
        type = "fixed-response"
        fixedResponseConfig = {
          contentType = "text/plain"
          statusCode  = "404"
          messageBody = "404 scope not found or has not been deployed yet"
        }
      })
      "alb.ingress.kubernetes.io/group.name"         = "k8s-nullplatform-internet-facing"
      "alb.ingress.kubernetes.io/listen-ports"       = "[{\"HTTP\":80},{\"HTTPS\":443}]"
      "alb.ingress.kubernetes.io/load-balancer-name" = "k8s-nullplatform-internet-facing"
      "alb.ingress.kubernetes.io/scheme"             = "internet-facing"
      "alb.ingress.kubernetes.io/ssl-redirect"       = "443"
      "alb.ingress.kubernetes.io/target-type"        = "ip"
      "alb.ingress.kubernetes.io/certificate-arn"    = var.certificate_arn
    })
  }

  spec {
    ingress_class_name = "alb"

    rule {
      host = "setup.nullapps.io"
      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "response-404"
              port {
                name = "use-annotation"
              }
            }
          }
        }
      }
    }
  }
}

resource "null_resource" "remove_finalizer_public" {
  triggers = {
    ingress_name = kubernetes_ingress_v1.public.metadata[0].name
    namespace    = kubernetes_ingress_v1.public.metadata[0].namespace
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kubectl patch ingress ${self.triggers.ingress_name} -n ${self.triggers.namespace} -p '{\"metadata\":{\"finalizers\":[]}}' --type=merge || true"
  }
}