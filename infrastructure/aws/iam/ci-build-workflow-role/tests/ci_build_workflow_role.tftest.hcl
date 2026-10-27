mock_provider "aws" {}

variables {
  cluster_name = "test-cluster"
}

run "role_trusts_application_manager" {
  command = plan

  assert {
    condition     = aws_iam_role.nullplatform_build_workflow_role.name == "nullplatform-test-cluster-build-workflow-role"
    error_message = "role name should follow naming convention"
  }

  assert {
    condition     = jsondecode(aws_iam_role.nullplatform_build_workflow_role.assume_role_policy).Statement[0].Principal.AWS == "arn:aws:iam::283477532906:role/application_manager"
    error_message = "role should trust nullplatform's application manager by default"
  }

  assert {
    condition     = jsondecode(aws_iam_role.nullplatform_build_workflow_role.assume_role_policy).Statement[0].Action == "sts:AssumeRole"
    error_message = "role should be assumed with sts:AssumeRole"
  }
}

run "custom_application_manager" {
  command = plan

  variables {
    application_manager_assume_role = "arn:aws:iam::111111111111:role/custom_application_manager"
  }

  assert {
    condition     = jsondecode(aws_iam_role.nullplatform_build_workflow_role.assume_role_policy).Statement[0].Principal.AWS == "arn:aws:iam::111111111111:role/custom_application_manager"
    error_message = "role should trust the provided application manager role"
  }
}
