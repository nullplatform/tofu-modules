mock_provider "kubernetes" {}

variables {
  certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/abcd-1234"
}

run "internal_alb_scheme" {
  command = plan

  assert {
    condition     = kubernetes_ingress_v1.internal.metadata[0].annotations["alb.ingress.kubernetes.io/scheme"] == "internal"
    error_message = "Internal ingress should use 'internal' scheme"
  }
}

run "public_alb_scheme" {
  command = plan

  assert {
    condition     = kubernetes_ingress_v1.public.metadata[0].annotations["alb.ingress.kubernetes.io/scheme"] == "internet-facing"
    error_message = "Public ingress should use 'internet-facing' scheme"
  }
}

run "certificate_arn_propagated" {
  command = plan

  assert {
    condition     = kubernetes_ingress_v1.internal.metadata[0].annotations["alb.ingress.kubernetes.io/certificate-arn"] == "arn:aws:acm:us-east-1:123456789012:certificate/abcd-1234"
    error_message = "Internal ingress should have the certificate ARN"
  }

  assert {
    condition     = kubernetes_ingress_v1.public.metadata[0].annotations["alb.ingress.kubernetes.io/certificate-arn"] == "arn:aws:acm:us-east-1:123456789012:certificate/abcd-1234"
    error_message = "Public ingress should have the certificate ARN"
  }
}

run "nullplatform_namespace" {
  command = plan

  assert {
    condition     = kubernetes_ingress_v1.internal.metadata[0].namespace == "nullplatform"
    error_message = "Internal ingress should be in nullplatform namespace"
  }

  assert {
    condition     = kubernetes_ingress_v1.public.metadata[0].namespace == "nullplatform"
    error_message = "Public ingress should be in nullplatform namespace"
  }
}

run "alb_ingress_class" {
  command = plan

  assert {
    condition     = kubernetes_ingress_v1.internal.spec[0].ingress_class_name == "alb"
    error_message = "Internal ingress should use ALB ingress class"
  }

  assert {
    condition     = kubernetes_ingress_v1.public.spec[0].ingress_class_name == "alb"
    error_message = "Public ingress should use ALB ingress class"
  }
}

run "ssl_redirect_enabled" {
  command = plan

  assert {
    condition     = kubernetes_ingress_v1.internal.metadata[0].annotations["alb.ingress.kubernetes.io/ssl-redirect"] == "443"
    error_message = "Internal ingress should redirect to HTTPS"
  }

  assert {
    condition     = kubernetes_ingress_v1.public.metadata[0].annotations["alb.ingress.kubernetes.io/ssl-redirect"] == "443"
    error_message = "Public ingress should redirect to HTTPS"
  }
}

run "load_balancer_naming" {
  command = plan

  assert {
    condition     = kubernetes_ingress_v1.internal.metadata[0].annotations["alb.ingress.kubernetes.io/load-balancer-name"] == "k8s-nullplatform-internal"
    error_message = "Internal ALB should be named k8s-nullplatform-internal"
  }

  assert {
    condition     = kubernetes_ingress_v1.public.metadata[0].annotations["alb.ingress.kubernetes.io/load-balancer-name"] == "k8s-nullplatform-internet-facing"
    error_message = "Public ALB should be named k8s-nullplatform-internet-facing"
  }
}
