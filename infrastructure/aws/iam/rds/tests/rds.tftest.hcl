mock_provider "aws" {
  override_resource {
    target = aws_iam_policy.nullplatform_rds_policy
    values = {
      arn = "arn:aws:iam::123456789012:policy/nullplatform_test_rds_policy"
    }
  }
  override_resource {
    target = aws_iam_policy.nullplatform_rds_sg_policy
    values = {
      arn = "arn:aws:iam::123456789012:policy/nullplatform_test_rds_sg_policy"
    }
  }
  override_resource {
    target = aws_iam_policy.nullplatform_rds_secretsmanager_policy
    values = {
      arn = "arn:aws:iam::123456789012:policy/nullplatform_test_rds_secretsmanager_policy"
    }
  }
}

variables {
  name = "test"
}

run "rds_policy_naming" {
  command = plan

  assert {
    condition     = aws_iam_policy.nullplatform_rds_policy.name == "nullplatform_test_rds_policy"
    error_message = "RDS policy name should follow naming convention"
  }
}

run "rds_sg_policy_naming" {
  command = plan

  assert {
    condition     = aws_iam_policy.nullplatform_rds_sg_policy.name == "nullplatform_test_rds_sg_policy"
    error_message = "RDS security group policy name should follow naming convention"
  }
}

run "rds_secretsmanager_policy_naming" {
  command = plan

  assert {
    condition     = aws_iam_policy.nullplatform_rds_secretsmanager_policy.name == "nullplatform_test_rds_secretsmanager_policy"
    error_message = "RDS Secrets Manager policy name should follow naming convention"
  }
}

run "all_policies_valid_json" {
  command = plan

  assert {
    condition     = can(jsondecode(aws_iam_policy.nullplatform_rds_policy.policy))
    error_message = "RDS policy should be valid JSON"
  }

  assert {
    condition     = can(jsondecode(aws_iam_policy.nullplatform_rds_sg_policy.policy))
    error_message = "RDS security group policy should be valid JSON"
  }

  assert {
    condition     = can(jsondecode(aws_iam_policy.nullplatform_rds_secretsmanager_policy.policy))
    error_message = "RDS Secrets Manager policy should be valid JSON"
  }
}

run "outputs_return_correct_arns" {
  command = plan

  assert {
    condition     = output.rds_policy_arn == "arn:aws:iam::123456789012:policy/nullplatform_test_rds_policy"
    error_message = "rds_policy_arn output should return the RDS policy ARN"
  }

  assert {
    condition     = output.rds_sg_policy_arn == "arn:aws:iam::123456789012:policy/nullplatform_test_rds_sg_policy"
    error_message = "rds_sg_policy_arn output should return the SG policy ARN"
  }

  assert {
    condition     = output.rds_secretsmanager_policy_arn == "arn:aws:iam::123456789012:policy/nullplatform_test_rds_secretsmanager_policy"
    error_message = "rds_secretsmanager_policy_arn output should return the Secrets Manager policy ARN"
  }
}
