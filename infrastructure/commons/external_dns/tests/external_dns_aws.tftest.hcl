# TODO: Enable once the OCI eager evaluation bug in locals.tf is fixed.
# locals.tf evaluates all provider configs (including OCI string interpolation)
# regardless of which provider is selected, causing null interpolation errors.
#
# mock_provider "helm" {}
# mock_provider "kubernetes" {}
#
# variables {
#   dns_provider_name      = "aws"
#   domain_filters         = "myorg.example.com"
#   external_dns_namespace = "external-dns"
#   aws_region             = "us-east-1"
#   aws_iam_role_arn       = "arn:aws:iam::123456789012:role/external-dns"
#   zone_id_filter         = "Z1234567890ABC"
#   zone_type              = "public"
# }
#
# run "aws_full_config" {
#   command = plan
#
#   assert {
#     condition     = helm_release.external_dns.name == "external-dns-public"
#     error_message = "Helm release name should include type suffix"
#   }
# }
#
# run "aws_irsa_annotation" {
#   command = plan
#
#   assert {
#     condition     = local.route53_config.serviceAccount.annotations["eks.amazonaws.com/role-arn"] == "arn:aws:iam::123456789012:role/external-dns"
#     error_message = "AWS IRSA annotation should match aws_iam_role_arn"
#   }
# }
#
# run "aws_zone_filtering_args" {
#   command = plan
#
#   assert {
#     condition     = contains(local.route53_config.extraArgs, "--aws-zone-type=public")
#     error_message = "Extra args should include --aws-zone-type"
#   }
#
#   assert {
#     condition     = contains(local.route53_config.extraArgs, "--zone-id-filter=Z1234567890ABC")
#     error_message = "Extra args should include --zone-id-filter"
#   }
# }
#
# run "no_cloudflare_secret_for_aws" {
#   command = plan
#
#   assert {
#     condition     = length(kubernetes_secret_v1.external_dns_cloudflare) == 0
#     error_message = "Cloudflare secret should not be created for AWS provider"
#   }
# }
#
# run "aws_requires_region" {
#   command = plan
#
#   variables {
#     aws_region = null
#   }
#
#   expect_failures = [var.aws_region]
# }
#
# run "aws_requires_iam_role" {
#   command = plan
#
#   variables {
#     aws_iam_role_arn = null
#   }
#
#   expect_failures = [var.aws_iam_role_arn]
# }
#
# run "aws_requires_zone_id_filter" {
#   command = plan
#
#   variables {
#     zone_id_filter = ""
#   }
#
#   expect_failures = [var.zone_id_filter]
# }
#
# run "aws_rejects_invalid_zone_type" {
#   command = plan
#
#   variables {
#     zone_type = "internal"
#   }
#
#   expect_failures = [var.zone_type]
# }
#
# run "aws_pod_identity_omits_role_annotation" {
#   command = plan
#
#   variables {
#     aws_identity_mode = "pod_identity"
#   }
#
#   assert {
#     condition     = !contains(keys(local.route53_config.serviceAccount.annotations), "eks.amazonaws.com/role-arn")
#     error_message = "Pod Identity mode must omit the IRSA role-arn annotation"
#   }
# }
