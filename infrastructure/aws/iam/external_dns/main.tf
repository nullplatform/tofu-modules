# Create IAM role with OIDC provider trust for Kubernetes service account
module "nullplatform_external_dns_role" {
  source          = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  name            = "nullplatform-${var.cluster_name}-external-dns-role"
  use_name_prefix = false

  oidc_providers = {
    main = {
      provider_arn               = var.aws_iam_openid_connect_provider_arn
      namespace_service_accounts = ["external_dns:external-dns-sa"]
    }
  }

  policies = {
    "nullplatform_external_dns_policy" = aws_iam_policy.nullplatform_external_dns_policy.arn,
  }
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
            "route53:ListTagsForResources"
          ],
          "Resource" : [
            "arn:aws:route53:::hostedzone/${var.hosted_zone_public_id}",
            "arn:aws:route53:::hostedzone/${var.hosted_zone_private_id}"
          ]
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