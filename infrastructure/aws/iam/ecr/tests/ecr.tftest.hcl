mock_provider "aws" {
  override_resource {
    target = aws_iam_policy.nullplatform_ecr_manager_policy
    values = {
      arn = "arn:aws:iam::123456789012:policy/nullplatform-test-cluster-ecr-manager-policy"
    }
  }
}

variables {
  cluster_name = "test-cluster"
}

run "group_only" {
  command = plan

  variables {
    build_workflow_group_name = "nullplatform-test-cluster-asset-publishers"
  }

  assert {
    condition     = aws_iam_group_policy_attachment.ecr_manager_policy_group[0].group == "nullplatform-test-cluster-asset-publishers"
    error_message = "policy should be attached to the build workflow group"
  }

  assert {
    condition     = length(aws_iam_role_policy_attachment.ecr_manager_policy_build_workflow_role) == 0
    error_message = "no role attachment should exist without build_workflow_role_name"
  }
}

run "role_only" {
  command = plan

  variables {
    build_workflow_role_name = "nullplatform-test-cluster-build-workflow-role"
  }

  assert {
    condition     = aws_iam_role_policy_attachment.ecr_manager_policy_build_workflow_role[0].role == "nullplatform-test-cluster-build-workflow-role"
    error_message = "policy should be attached to the build workflow role"
  }

  assert {
    condition     = length(aws_iam_group_policy_attachment.ecr_manager_policy_group) == 0
    error_message = "no group attachment should exist without build_workflow_group_name"
  }
}

# Migration window: the same policy is granted to the user (via the group) and
# to the role, so pushes keep working whichever credential the platform uses.
run "group_and_role" {
  command = plan

  variables {
    build_workflow_group_name = "nullplatform-test-cluster-asset-publishers"
    build_workflow_role_name  = "nullplatform-test-cluster-build-workflow-role"
  }

  assert {
    condition     = length(aws_iam_group_policy_attachment.ecr_manager_policy_group) == 1 && length(aws_iam_role_policy_attachment.ecr_manager_policy_build_workflow_role) == 1
    error_message = "policy should be attached to both the group and the role"
  }
}

run "fails_without_identity" {
  command = plan

  expect_failures = [terraform_data.validations]
}
