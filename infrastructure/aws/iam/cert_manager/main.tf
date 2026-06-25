locals {
  hosted_zone_arns = [
    for id in [var.hosted_zone_public_id, var.hosted_zone_private_id] :
    "arn:aws:route53:::hostedzone/${id}"
    if id != null && id != ""
  ]

  cert_manager_service_accounts = [
    { namespace = "cert-manager", service_account = "cert-manager" }
  ]
}

# IRSA: OIDC federation via community module
module "nullplatform_cert_manager_role" {
  count           = var.identity_mode == "irsa" ? 1 : 0
  source          = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  name            = "nullplatform-${var.cluster_name}-cert-manager-role"
  use_name_prefix = false

  oidc_providers = {
    main = {
      provider_arn               = var.aws_iam_openid_connect_provider_arn
      namespace_service_accounts = ["cert-manager:cert-manager"]
    }
  }

  policies = {
    "nullplatform_cert_manager_policy" = aws_iam_policy.nullplatform_cert_manager_policy.arn
  }
}

# Pod Identity: native IAM role trusted by the EKS Pod Identity agent
resource "aws_iam_role" "pod_identity" {
  count = var.identity_mode == "pod_identity" ? 1 : 0
  name  = "nullplatform-${var.cluster_name}-cert-manager-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "pods.eks.amazonaws.com" }
      Action    = ["sts:AssumeRole", "sts:TagSession"]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "pod_identity" {
  count      = var.identity_mode == "pod_identity" ? 1 : 0
  role       = aws_iam_role.pod_identity[0].name
  policy_arn = aws_iam_policy.nullplatform_cert_manager_policy.arn
}

resource "aws_eks_pod_identity_association" "this" {
  for_each = var.identity_mode == "pod_identity" ? {
    for sa in local.cert_manager_service_accounts :
    "${sa.namespace}:${sa.service_account}" => sa
  } : {}

  cluster_name    = var.cluster_name
  namespace       = each.value.namespace
  service_account = each.value.service_account
  role_arn        = aws_iam_role.pod_identity[0].arn
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
        "Resource" : local.hosted_zone_arns
      },
      {
        "Effect" : "Allow",
        "Action" : "route53:ListHostedZonesByName",
        "Resource" : "*"
      }
    ]
  })
}
