locals {
  hosted_zone_arns = [
    for id in [var.hosted_zone_public_id, var.hosted_zone_private_id] :
    "arn:aws:route53:::hostedzone/${id}"
    if id != null && id != ""
  ]
}

# Create IAM role with OIDC provider trust for Kubernetes service account
module "nullplatform_external_dns_role" {
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
