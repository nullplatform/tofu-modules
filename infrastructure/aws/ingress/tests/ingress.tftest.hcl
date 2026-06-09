mock_provider "kubernetes" {}

variables {
  certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/abcd-1234"
}

run "internal_alb_scheme" {
  command = plan

  assert {
    condition     = kubernetes_ingress_v1.internal[0].metadata[0].annotations["alb.ingress.kubernetes.io/scheme"] == "internal"
    error_message = "Internal ingress should use 'internal' scheme"
  }
}

run "public_alb_scheme" {
  command = plan

  assert {
    condition     = kubernetes_ingress_v1.public[0].metadata[0].annotations["alb.ingress.kubernetes.io/scheme"] == "internet-facing"
    error_message = "Public ingress should use 'internet-facing' scheme"
  }
}

run "certificate_arn_propagated" {
  command = plan

  assert {
    condition     = kubernetes_ingress_v1.internal[0].metadata[0].annotations["alb.ingress.kubernetes.io/certificate-arn"] == "arn:aws:acm:us-east-1:123456789012:certificate/abcd-1234"
    error_message = "Internal ingress should have the certificate ARN"
  }

  assert {
    condition     = kubernetes_ingress_v1.public[0].metadata[0].annotations["alb.ingress.kubernetes.io/certificate-arn"] == "arn:aws:acm:us-east-1:123456789012:certificate/abcd-1234"
    error_message = "Public ingress should have the certificate ARN"
  }
}

run "nullplatform_namespace" {
  command = plan

  assert {
    condition     = kubernetes_ingress_v1.internal[0].metadata[0].namespace == "nullplatform"
    error_message = "Internal ingress should be in nullplatform namespace"
  }

  assert {
    condition     = kubernetes_ingress_v1.public[0].metadata[0].namespace == "nullplatform"
    error_message = "Public ingress should be in nullplatform namespace"
  }
}

run "alb_ingress_class" {
  command = plan

  assert {
    condition     = kubernetes_ingress_v1.internal[0].spec[0].ingress_class_name == "alb"
    error_message = "Internal ingress should use ALB ingress class"
  }

  assert {
    condition     = kubernetes_ingress_v1.public[0].spec[0].ingress_class_name == "alb"
    error_message = "Public ingress should use ALB ingress class"
  }
}

run "ssl_redirect_enabled" {
  command = plan

  assert {
    condition     = kubernetes_ingress_v1.internal[0].metadata[0].annotations["alb.ingress.kubernetes.io/ssl-redirect"] == "443"
    error_message = "Internal ingress should redirect to HTTPS"
  }

  assert {
    condition     = kubernetes_ingress_v1.public[0].metadata[0].annotations["alb.ingress.kubernetes.io/ssl-redirect"] == "443"
    error_message = "Public ingress should redirect to HTTPS"
  }
}

run "load_balancer_naming" {
  command = plan

  assert {
    condition     = kubernetes_ingress_v1.internal[0].metadata[0].annotations["alb.ingress.kubernetes.io/load-balancer-name"] == "k8s-nullplatform-internal"
    error_message = "Internal ALB should be named k8s-nullplatform-internal"
  }

  assert {
    condition     = kubernetes_ingress_v1.public[0].metadata[0].annotations["alb.ingress.kubernetes.io/load-balancer-name"] == "k8s-nullplatform-internet-facing"
    error_message = "Public ALB should be named k8s-nullplatform-internet-facing"
  }
}

run "internal_alb_disabled_skips_creation" {
  command = plan

  variables {
    internal_alb = {
      enabled = false
    }
  }

  assert {
    condition     = length(kubernetes_ingress_v1.internal) == 0
    error_message = "Internal ingress must not be created when internal_alb.enabled is false"
  }

  assert {
    condition     = length(kubernetes_ingress_v1.public) == 1
    error_message = "Public ingress should still be created when only the internal ALB is disabled"
  }
}

run "public_alb_disabled_skips_creation" {
  command = plan

  variables {
    internet_facing_alb = {
      enabled = false
    }
  }

  assert {
    condition     = length(kubernetes_ingress_v1.public) == 0
    error_message = "Public ingress must not be created when internet_facing_alb.enabled is false"
  }

  assert {
    condition     = length(kubernetes_ingress_v1.internal) == 1
    error_message = "Internal ingress should still be created when only the public ALB is disabled"
  }
}

run "rejects_when_both_albs_disabled" {
  command = plan

  variables {
    internal_alb = {
      enabled = false
    }
    internet_facing_alb = {
      enabled = false
    }
  }

  expect_failures = [var.internal_alb]
}

run "custom_alb_overrides_propagate" {
  command = plan

  variables {
    internal_alb = {
      ingress_name = "my-internal-ingress"
      namespace    = "custom-ns"
      alb_name     = "my-internal-alb"
    }
    internet_facing_alb = {
      ingress_name = "my-public-ingress"
      namespace    = "custom-ns"
      alb_name     = "my-public-alb"
    }
  }

  assert {
    condition     = kubernetes_ingress_v1.internal[0].metadata[0].name == "my-internal-ingress"
    error_message = "Internal ingress name override should propagate"
  }

  assert {
    condition     = kubernetes_ingress_v1.public[0].metadata[0].name == "my-public-ingress"
    error_message = "Public ingress name override should propagate"
  }

  assert {
    condition     = kubernetes_ingress_v1.internal[0].metadata[0].namespace == "custom-ns"
    error_message = "Internal ingress namespace override should propagate"
  }

  assert {
    condition     = kubernetes_ingress_v1.public[0].metadata[0].namespace == "custom-ns"
    error_message = "Public ingress namespace override should propagate"
  }

  assert {
    condition     = kubernetes_ingress_v1.internal[0].metadata[0].annotations["alb.ingress.kubernetes.io/load-balancer-name"] == "my-internal-alb"
    error_message = "Internal alb_name override should propagate to the load-balancer-name annotation"
  }

  assert {
    condition     = kubernetes_ingress_v1.internal[0].metadata[0].annotations["alb.ingress.kubernetes.io/group.name"] == "my-internal-alb"
    error_message = "Internal alb_name override should propagate to the group.name annotation"
  }

  assert {
    condition     = kubernetes_ingress_v1.public[0].metadata[0].annotations["alb.ingress.kubernetes.io/load-balancer-name"] == "my-public-alb"
    error_message = "Public alb_name override should propagate to the load-balancer-name annotation"
  }

  assert {
    condition     = kubernetes_ingress_v1.public[0].metadata[0].annotations["alb.ingress.kubernetes.io/group.name"] == "my-public-alb"
    error_message = "Public alb_name override should propagate to the group.name annotation"
  }
}
