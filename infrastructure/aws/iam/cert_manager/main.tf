# Create IAM role with OIDC provider trust for Kubernetes service account
module "nullplatform_cert_manager_role" {
  source          = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  name            = "nullplatform-${var.cluster_name}-cert-manager-role"
  use_name_prefix = false

  oidc_providers = {
    main = {
      provider_arn               = var.aws_iam_openid_connect_provider_arn
      namespace_service_accounts = ["cert-manager:cert-manager-acme-dns01-route53"]
    }
  }

  policies = {
    "nullplatform_cert_manager_policy" = aws_iam_policy.nullplatform_cert_manager_policy.arn
  }
}

# Grant permissions to manage Route 53 DNS records for DNS01 challenge
resource "aws_iam_policy" "nullplatform_cert_manager_policy" {
  name        = "nullplatform-${var.cluster_name}-cert-manager-policy"
  description = "Policy for managing Route 53 DNS records"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "route53:GetChange",
        "Resource" : "arn:aws:route53:::change/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ],
        "Resource" : "arn:aws:route53:::hostedzone/${var.hosted_zone_public_id}"
      },
      {
        "Effect" : "Allow",
        "Action" : "route53:ListHostedZonesByName",
        "Resource" : "*"
      }
    ]
  })
}

# ServiceAccount for IRSA with cert-manager DNS01 Route53 solver
resource "kubernetes_service_account_v1" "cert_manager_acme_dns01_route53" {
  metadata {
    name      = "cert-manager-acme-dns01-route53"
    namespace = "cert-manager"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.nullplatform_cert_manager_role.iam_role_arn
    }
  }
}

# Role to allow cert-manager to create tokens for the DNS01 solver ServiceAccount
resource "kubernetes_role_v1" "cert_manager_acme_dns01_route53_tokenrequest" {
  metadata {
    name      = "cert-manager-acme-dns01-route53-tokenrequest"
    namespace = "cert-manager"
  }

  rule {
    api_groups     = [""]
    resources      = ["serviceaccounts/token"]
    resource_names = [kubernetes_service_account_v1.cert_manager_acme_dns01_route53.metadata[0].name]
    verbs          = ["create"]
  }
}

# RoleBinding to grant cert-manager the tokenrequest permissions
resource "kubernetes_role_binding_v1" "cert_manager_acme_dns01_route53_tokenrequest" {
  metadata {
    name      = "cert-manager-acme-dns01-route53-tokenrequest"
    namespace = "cert-manager"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "cert-manager"
    namespace = "cert-manager"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.cert_manager_acme_dns01_route53_tokenrequest.metadata[0].name
  }
}