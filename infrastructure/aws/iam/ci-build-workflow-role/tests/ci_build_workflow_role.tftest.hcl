mock_provider "aws" {
  # Overrides apply to every instance of the resource, so looked-up and created
  # providers each get a single placeholder ARN.
  override_data {
    target = data.aws_iam_openid_connect_provider.this
    values = {
      arn = "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
    }
  }
  override_resource {
    target = aws_iam_openid_connect_provider.this
    values = {
      arn = "arn:aws:iam::123456789012:oidc-provider/created"
    }
  }
}

variables {
  cluster_name = "test-cluster"
}

run "application_manager_only_without_oidc_providers" {
  command = plan

  assert {
    condition     = aws_iam_role.nullplatform_build_workflow_role.name == "nullplatform-test-cluster-build-workflow-role"
    error_message = "role name should follow naming convention"
  }

  assert {
    condition     = length(jsondecode(aws_iam_role.nullplatform_build_workflow_role.assume_role_policy).Statement) == 1
    error_message = "only the application manager should be trusted without oidc_providers"
  }

  assert {
    condition     = jsondecode(aws_iam_role.nullplatform_build_workflow_role.assume_role_policy).Statement[0].Principal.AWS == "arn:aws:iam::283477532906:role/application_manager"
    error_message = "role should trust nullplatform's application manager by default"
  }
}

run "github_looks_up_existing_provider" {
  command = apply

  variables {
    oidc_providers = {
      github = {
        url      = "https://token.actions.githubusercontent.com"
        subjects = ["repo:my-org/*", "repo:my-org@239821853/*"]
      }
    }
  }

  assert {
    condition     = length(data.aws_iam_openid_connect_provider.this) == 1 && length(aws_iam_openid_connect_provider.this) == 0
    error_message = "the existing OIDC provider should be looked up, not created, by default"
  }

  assert {
    condition     = jsondecode(aws_iam_role.nullplatform_build_workflow_role.assume_role_policy).Statement[1].Principal.Federated == "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
    error_message = "role should trust the GitHub OIDC provider"
  }

  assert {
    condition     = jsondecode(aws_iam_role.nullplatform_build_workflow_role.assume_role_policy).Statement[1].Action == "sts:AssumeRoleWithWebIdentity"
    error_message = "CI jobs should assume the role through web identity"
  }

  assert {
    condition     = jsondecode(aws_iam_role.nullplatform_build_workflow_role.assume_role_policy).Statement[1].Condition.StringEquals["token.actions.githubusercontent.com:aud"] == ["sts.amazonaws.com"]
    error_message = "audience should default to sts.amazonaws.com"
  }

  assert {
    condition     = jsondecode(aws_iam_role.nullplatform_build_workflow_role.assume_role_policy).Statement[1].Condition.StringLike["token.actions.githubusercontent.com:sub"] == ["repo:my-org/*", "repo:my-org@239821853/*"]
    error_message = "sub should be restricted to the given patterns"
  }
}

run "several_providers_with_own_audience_and_creation" {
  command = apply

  variables {
    oidc_providers = {
      gitlab = {
        url      = "https://gitlab.com"
        subjects = ["project_path:my-group/*"]
        create   = true
      }
      bitbucket = {
        url       = "https://api.bitbucket.org/2.0/workspaces/my-ws/pipelines-config/identity/oidc"
        subjects  = ["{11111111-2222-3333-4444-555555555555}:*"]
        audiences = ["ari:cloud:bitbucket::workspace/11111111-2222-3333-4444-555555555555"]
        create    = true
      }
    }
  }

  assert {
    condition     = length(aws_iam_openid_connect_provider.this) == 2 && length(data.aws_iam_openid_connect_provider.this) == 0
    error_message = "both OIDC providers should be created"
  }

  assert {
    condition     = aws_iam_openid_connect_provider.this["bitbucket"].client_id_list == toset(["ari:cloud:bitbucket::workspace/11111111-2222-3333-4444-555555555555"])
    error_message = "a created provider should register the entry's audiences as client IDs"
  }

  assert {
    condition     = length(jsondecode(aws_iam_role.nullplatform_build_workflow_role.assume_role_policy).Statement) == 3
    error_message = "the application manager plus one statement per OIDC provider should be trusted"
  }

  assert {
    condition = anytrue([
      for s in jsondecode(aws_iam_role.nullplatform_build_workflow_role.assume_role_policy).Statement :
      try(s.Condition.StringEquals["api.bitbucket.org/2.0/workspaces/my-ws/pipelines-config/identity/oidc:aud"] == ["ari:cloud:bitbucket::workspace/11111111-2222-3333-4444-555555555555"], false)
    ])
    error_message = "condition keys should use the issuer host and path, with the entry's own audience"
  }

  assert {
    condition = anytrue([
      for s in jsondecode(aws_iam_role.nullplatform_build_workflow_role.assume_role_policy).Statement :
      try(s.Condition.StringLike["gitlab.com:sub"] == ["project_path:my-group/*"], false)
    ])
    error_message = "GitLab sub patterns should be keyed by its issuer host"
  }
}

run "rejects_leading_wildcard_subject" {
  command = plan

  variables {
    oidc_providers = {
      github = {
        url      = "https://token.actions.githubusercontent.com"
        subjects = ["*"]
      }
    }
  }

  expect_failures = [var.oidc_providers]
}

run "rejects_non_https_url" {
  command = plan

  variables {
    oidc_providers = {
      github = {
        url      = "token.actions.githubusercontent.com"
        subjects = ["repo:my-org/*"]
      }
    }
  }

  expect_failures = [var.oidc_providers]
}
