# TODO: Enable once mock_provider supports generating valid ARNs and JSON policies.
# The upstream terraform-aws-modules/eks/aws module has internal data sources
# (aws_iam_policy_document, aws_caller_identity, aws_iam_session_context)
# that mock_provider fills with random strings, failing ARN/JSON format validations.
# This requires either mock_provider improvements or integration tests with real credentials.
#
# mock_provider "aws" {}
# mock_provider "tls" {}
# mock_provider "time" {}
# mock_provider "null" {}
# mock_provider "cloudinit" {}
#
# variables {
#   name                    = "test-cluster"
#   aws_vpc_vpc_id          = "vpc-12345678"
#   aws_subnets_private_ids = ["subnet-aaa", "subnet-bbb"]
# }
#
# run "plans_with_managed_node_groups" {
#   command = plan
# }
#
# run "plans_with_auto_mode" {
#   command = plan
#
#   variables {
#     use_auto_mode = true
#   }
# }
#
# run "rejects_invalid_auto_mode_node_pools" {
#   command = plan
#
#   variables {
#     use_auto_mode        = true
#     auto_mode_node_pools = ["invalid-pool"]
#   }
#
#   expect_failures = [var.auto_mode_node_pools]
# }
#
# run "custom_node_group_sizing" {
#   command = plan
#
#   variables {
#     node_group_min_size     = 3
#     node_group_max_size     = 20
#     node_group_desired_size = 5
#   }
# }
#
# run "custom_kubernetes_version" {
#   command = plan
#
#   variables {
#     kubernetes_version = "1.31"
#   }
# }
