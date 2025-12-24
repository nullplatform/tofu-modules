# Create IAM role with OIDC provider trust for Kubernetes service account
module "nullplatform_cert_manager_role" {
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
        "Resource" : ["arn:aws:route53:::hostedzone/${var.hosted_zone_public_id}",
          "arn:aws:route53:::hostedzone/${var.hosted_zone_private_id}"]
      },
      {
        "Effect" : "Allow",
        "Action" : "route53:ListHostedZonesByName",
        "Resource" : "*"
      }
    ]
  })
}