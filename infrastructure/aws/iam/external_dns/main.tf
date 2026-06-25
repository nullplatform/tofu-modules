locals {
  hosted_zone_arns = [
    for id in [var.hosted_zone_public_id, var.hosted_zone_private_id] :
    "arn:aws:route53:::hostedzone/${id}"
    if id != null && id != ""
  ]

  external_dns_service_accounts = [
    { namespace = "external-dns", service_account = "external-dns-private" },
    { namespace = "external-dns", service_account = "external-dns-public" },
  ]
}

# IRSA: OIDC federation via community module
module "nullplatform_external_dns_role" {
  count           = var.identity_mode == "irsa" ? 1 : 0
  source          = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  name            = "nullplatform-${var.cluster_name}-external-dns-role"
  use_name_prefix = false

  oidc_providers = {
    main = {
      provider_arn = var.aws_iam_openid_connect_provider_arn
      namespace_service_accounts = [
        "external-dns:external-dns-private",
        "external-dns:external-dns-public",
      ]
    }
  }

  policies = {
    "nullplatform_external_dns_policy" = aws_iam_policy.nullplatform_external_dns_policy.arn,
  }
}

# Pod Identity: native IAM role trusted by the EKS Pod Identity agent
resource "aws_iam_role" "pod_identity" {
  count = var.identity_mode == "pod_identity" ? 1 : 0
  name  = "nullplatform-${var.cluster_name}-external-dns-role"

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
  role       = one(aws_iam_role.pod_identity[*].name)
  policy_arn = aws_iam_policy.nullplatform_external_dns_policy.arn
}

resource "aws_eks_pod_identity_association" "this" {
  for_each = var.identity_mode == "pod_identity" ? {
    for sa in local.external_dns_service_accounts :
    "${sa.namespace}:${sa.service_account}" => sa
  } : {}

  cluster_name    = var.cluster_name
  namespace       = each.value.namespace
  service_account = each.value.service_account
  role_arn        = one(aws_iam_role.pod_identity[*].arn)
}

# Grant permissions to manage Route 53 DNS records for service discovery
resource "aws_iam_policy" "nullplatform_external_dns_policy" {
  name        = "nullplatform-${var.cluster_name}-external-dns-policy"
  description = "Policy for managing Route 53 DNS records"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "route53:ChangeResourceRecordSets",
            "route53:ListResourceRecordSets",
            "route53:ListTagsForResources",
            "route53:ListHostedZones"
          ],
          "Resource" : local.hosted_zone_arns
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "route53:ListHostedZones"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]
    }
  )
}
