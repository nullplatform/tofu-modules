# Module: ci-build-workflow-role

## Description

Creates an AWS IAM role the CI/CD build workflow assumes to publish build assets, replacing the long-lived access keys of the ci-build-workflow-user module

## Architecture

The module creates an aws_iam_role named with the cluster_name prefix. Its trust policy always allows sts:AssumeRole from nullplatform's application manager role, plus one sts:AssumeRoleWithWebIdentity statement per entry of oidc_providers: the CI tool's OIDC provider as principal, its audiences on `<issuer>:aud` and its subject patterns on `<issuer>:sub`. `np asset push` runs on the CI runner, which has no AWS identity of its own, so it exchanges the job's OIDC token for temporary credentials of this role (see the nullplatform docs, "Asset push authentication"). OIDC providers are looked up by default, since an account holds one per issuer URL, and created only for entries with create = true. The role carries no permissions of its own: asset-repository permission modules (ecr, s3-assets) attach their policies to it through build_workflow_role_name. Its ARN is passed to nullplatform/asset/ecr as build_workflow_role_arn.

## Basic Usage

```hcl
module "ci_build_workflow_role" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/ci-build-workflow-role?ref=vX.Y.Z"

  cluster_name = "your-cluster-name"

  oidc_providers = {
    github = {
      url = "https://token.actions.githubusercontent.com"
      # Both sub formats: classic, and immutable subjects (repo:<org>@<org_id>/<repo>@<repo_id>:...)
      subjects = ["repo:your-org/*", "repo:your-org@123456789/*"]
    }
  }
}

module "ecr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/ecr?ref=vX.Y.Z"

  cluster_name             = "your-cluster-name"
  build_workflow_role_name = module.ci_build_workflow_role.role_name
}
```

### Other CI tools

```hcl
oidc_providers = {
  gitlab = {
    url      = "https://gitlab.com" # or your self-managed instance
    subjects = ["project_path:your-group/*"]
  }
  bitbucket = {
    url       = "https://api.bitbucket.org/2.0/workspaces/your-workspace/pipelines-config/identity/oidc"
    subjects  = ["{your-repository-uuid}:*"]
    audiences = ["ari:cloud:bitbucket::workspace/your-workspace-uuid"]
  }
}
```

What each pipeline needs so `np asset push` can present its token:

| CI | Pipeline change |
|----|-----------------|
| GitHub Actions | `permissions: id-token: write` on the job. The CLI requests the token itself. |
| GitLab CI | `id_tokens: { AWS_ID_TOKEN: { aud: sts.amazonaws.com } }`, then write `$AWS_ID_TOKEN` to a file and export `AWS_WEB_IDENTITY_TOKEN_FILE` |
| Bitbucket Pipelines | `oidc: true` on the step, then write `$BITBUCKET_STEP_OIDC_TOKEN` to a file and export `AWS_WEB_IDENTITY_TOKEN_FILE` |

Do not set `AWS_ROLE_ARN`: the CLI takes the role from the provider.

> **Warning:** the role is configured per asset repository provider, and once it is set the provider's access keys are ignored. Every pipeline under that provider must present an identity the role trusts, or its pushes fail.

## Migrating from ci-build-workflow-user

1. Add this module and pass `build_workflow_role_name` to `ecr` / `s3-assets` **next to** the existing `build_workflow_group_name`, and `build_workflow_role_arn` to `nullplatform/asset/ecr` next to the access keys. Apply.
2. Validate an asset push from a pipeline: once a role is configured the platform ignores the keys. To roll back, remove `build_workflow_role_arn` and the pipelines fall back to the keys.
3. Remove `build_workflow_group_name`, the access keys and the `ci-build-workflow-user` module. Apply (this deletes the IAM user and its access key).

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
