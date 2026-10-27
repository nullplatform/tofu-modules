mock_provider "aws" {
  override_data {
    target = data.aws_iam_openid_connect_provider.github
    values = {
      arn = "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
    }
  }
  override_resource {
    target = aws_iam_openid_connect_provider.github
    values = {
      arn = "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
    }
  }
}

variables {
  cluster_name = "test-cluster"
}

run "application_manager_only_without_github_organization" {
  command = plan

  assert {
    condition     = aws_iam_role.nullplatform_build_workflow_role.name == "nullplatform-test-cluster-build-workflow-role"
    error_message = "role name should follow naming convention"
  }

  assert {
    condition     = length(jsondecode(aws_iam_role.nullplatform_build_workflow_role.assume_role_policy).Statement) == 1
    error_message = "only the application manager should be trusted without github_organization"
  }

  assert {
    condition     = jsondecode(aws_iam_role.nullplatform_build_workflow_role.assume_role_policy).Statement[0].Principal.AWS == "arn:aws:iam::283477532906:role/application_manager"
    error_message = "role should trust nullplatform's application manager by default"
  }

  assert {
    condition     = length(data.aws_iam_openid_connect_provider.github) == 0 && length(aws_iam_openid_connect_provider.github) == 0
    error_message = "no OIDC provider should be looked up or created without github_organization"
  }
}

run "github_organization_trusts_existing_oidc_provider" {
  command = apply

  variables {
    github_organization = "my-org"
  }

  assert {
    condition     = length(data.aws_iam_openid_connect_provider.github) == 1 && length(aws_iam_openid_connect_provider.github) == 0
    error_message = "the existing GitHub OIDC provider should be looked up, not created, by default"
  }

  assert {
    condition     = jsondecode(aws_iam_role.nullplatform_build_workflow_role.assume_role_policy).Statement[0].Principal.AWS == "arn:aws:iam::283477532906:role/application_manager"
    error_message = "the application manager should stay trusted"
  }

  assert {
    condition     = jsondecode(aws_iam_role.nullplatform_build_workflow_role.assume_role_policy).Statement[1].Principal.Federated == "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
    error_message = "role should trust the GitHub OIDC provider"
  }

  assert {
    condition     = jsondecode(aws_iam_role.nullplatform_build_workflow_role.assume_role_policy).Statement[1].Action == "sts:AssumeRoleWithWebIdentity"
    error_message = "GitHub workflows should assume the role through web identity"
  }

  assert {
    condition     = jsondecode(aws_iam_role.nullplatform_build_workflow_role.assume_role_policy).Statement[1].Condition.StringEquals["token.actions.githubusercontent.com:aud"] == "sts.amazonaws.com"
    error_message = "trust policy should pin the audience to sts.amazonaws.com"
  }

  assert {
    condition     = jsondecode(aws_iam_role.nullplatform_build_workflow_role.assume_role_policy).Statement[1].Condition.StringLike["token.actions.githubusercontent.com:sub"] == ["repo:my-org/*", "repo:my-org@*/*"]
    error_message = "trust policy should accept both sub formats, restricted to the organization's repositories"
  }
}

run "github_organization_id_pins_immutable_subject" {
  command = plan

  variables {
    github_organization    = "my-org"
    github_organization_id = "239821853"
  }

  assert {
    condition     = contains(jsondecode(aws_iam_role.nullplatform_build_workflow_role.assume_role_policy).Statement[1].Condition.StringLike["token.actions.githubusercontent.com:sub"], "repo:my-org@239821853/*")
    error_message = "immutable sub pattern should pin the organization ID"
  }
}

run "creates_oidc_provider_when_asked" {
  command = plan

  variables {
    github_organization         = "my-org"
    create_github_oidc_provider = true
  }

  assert {
    condition     = length(aws_iam_openid_connect_provider.github) == 1 && length(data.aws_iam_openid_connect_provider.github) == 0
    error_message = "the GitHub OIDC provider should be created instead of looked up"
  }
}

run "rejects_wildcard_organization" {
  command = plan

  variables {
    github_organization = "*"
  }

  expect_failures = [var.github_organization]
}
