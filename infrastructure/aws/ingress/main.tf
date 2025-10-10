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

resource "null_resource" "destroy_wait_internal" {
  triggers = {
    ingress_uid       = kubernetes_ingress_v1.internal.id
    ingress_name      = kubernetes_ingress_v1.internal.metadata[0].name
    namespace         = kubernetes_ingress_v1.internal.metadata[0].namespace
    lb_name           = "k8s-nullplatform-internal"
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      set -e

      # Remover finalizers
      kubectl patch ingress ${self.triggers.ingress_name} \
        -n ${self.triggers.namespace} \
        -p '{"metadata":{"finalizers":[]}}' \
        --type=merge 2>/dev/null || true

      echo "Waiting for ALB ${self.triggers.lb_name} to be deleted by controller..."

      # Esperar hasta 5 minutos a que el ALB se elimine
      for i in {1..60}; do
        if ! aws elbv2 describe-load-balancers \
          --names ${self.triggers.lb_name} 2>/dev/null | grep -q LoadBalancerArn; then
          echo "✓ ALB ${self.triggers.lb_name} deleted successfully"
          break
        fi

        if [ $i -eq 60 ]; then
          echo "⚠ Warning: ALB still exists after 5 minutes"
          break
        fi

        if [ $((i % 10)) -eq 0 ]; then
          echo "Still waiting for ALB deletion... ($i/60)"
        fi
        sleep 5
      done

      # Sleep adicional para asegurar que los SGs también se limpien
      echo "Waiting additional time for security groups cleanup..."
      sleep 20
    EOT
  }
  depends_on = [kubernetes_ingress_v1.internal]
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

resource "null_resource" "destroy_wait_public" {
  triggers = {
    ingress_uid       = kubernetes_ingress_v1.public.id
    ingress_name      = kubernetes_ingress_v1.public.metadata[0].name
    namespace         = kubernetes_ingress_v1.public.metadata[0].namespace
    lb_name           = "k8s-nullplatform-internet-facing"
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      set -e

      # Remover finalizers
      kubectl patch ingress ${self.triggers.ingress_name} \
        -n ${self.triggers.namespace} \
        -p '{"metadata":{"finalizers":[]}}' \
        --type=merge 2>/dev/null || true

      echo "Waiting for ALB ${self.triggers.lb_name} to be deleted by controller..."

      # Esperar hasta 5 minutos a que el ALB se elimine
      for i in {1..60}; do
        if ! aws elbv2 describe-load-balancers \
          --names ${self.triggers.lb_name} 2>/dev/null | grep -q LoadBalancerArn; then
          echo "✓ ALB ${self.triggers.lb_name} deleted successfully"
          break
        fi

        if [ $i -eq 60 ]; then
          echo "⚠ Warning: ALB still exists after 5 minutes"
          break
        fi

        if [ $((i % 10)) -eq 0 ]; then
          echo "Still waiting for ALB deletion... ($i/60)"
        fi
        sleep 5
      done

      # Sleep adicional para asegurar que los SGs también se limpien
      echo "Waiting additional time for security groups cleanup..."
      sleep 20
    EOT
  }

  depends_on = [kubernetes_ingress_v1.public]
}