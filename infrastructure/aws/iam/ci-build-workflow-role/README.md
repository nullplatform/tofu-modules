# Module: ci-build-workflow-role

## Description

Creates an AWS IAM role for CI/CD build workflows that trusts both an application manager role and multiple OIDC identity providers (GitHub Actions, GitLab CI, Bitbucket Pipelines, etc.) to enable keyless authentication

## Architecture

The module creates or looks up `aws_iam_openid_connect_provider` resources for each entry in `oidc_providers` based on the `create` flag, then builds an `aws_iam_role` named `nullplatform-{cluster_name}-build-workflow-role` whose assume-role policy concatenates a direct `sts:AssumeRole` statement for the application manager ARN with `sts:AssumeRoleWithWebIdentity` statements for each OIDC provider. Each OIDC trust statement uses the provider ARN from either the created or looked-up provider and enforces `StringEquals` on audience claims and `StringLike` on subject claims. The role ARN and name are exposed as outputs so downstream asset-repository permission modules (ECR, S3) can attach their policies to it.

## Features

- Creates or looks up aws_iam_openid_connect_provider resources per CI issuer based on the create flag
- Creates an aws_iam_role with a compound assume-role policy supporting both direct role assumption and OIDC web identity federation
- Enforces audience and subject claim conditions on each OIDC trust statement to scope access to specific organizations, groups, or repositories
- Validates all OIDC provider URLs use HTTPS and that subject patterns do not start with wildcards or expose entire issuers
- Supports multiple simultaneous OIDC providers (GitHub Actions, GitLab CI, Bitbucket Pipelines) keyed by free-form name
- Outputs role ARN and name for consumption by asset-repository permission modules such as ECR and S3

## Basic Usage

```hcl
module "ci-build-workflow-role" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/ci-build-workflow-role?ref=v9.16.0"

  cluster_name = "your-cluster-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.ci-build-workflow-role.role_arn
}
```

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.70.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.nullplatform_build_workflow_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_manager_assume_role"></a> [application\_manager\_assume\_role](#input\_application\_manager\_assume\_role) | ARN of the IAM role assumed by the application manager | `string` | `"arn:aws:iam::283477532906:role/application_manager"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster, used to namespace IAM resource names | `string` | n/a | yes |
| <a name="input_oidc_providers"></a> [oidc\_providers](#input\_oidc\_providers) | CI OIDC issuers whose jobs can assume the role, keyed by a free-form name (e.g. github, gitlab, bitbucket).<br/>- url: issuer URL, e.g. https://token.actions.githubusercontent.com, https://gitlab.com or https://api.bitbucket.org/2.0/workspaces/<workspace>/pipelines-config/identity/oidc<br/>- subjects: StringLike patterns on the sub claim, scoped to your organization, group or repositories (e.g. ["repo:<org>/*", "repo:<org>@<org\_id>/*"] for GitHub, project\_path:<group>/* for GitLab).<br/>  GitHub picks the sub format per repository, so one organization can mix both: older repositories send repo:<org>/<repo>:...,<br/>  and repositories created, renamed or transferred more recently send the immutable repo:<org>@<org\_id>/<repo>@<repo\_id>:...<br/>  List both patterns to cover the whole organization. Check a repository with gh api repos/<org>/<repo>/actions/oidc/customization/sub<br/>  (use\_immutable\_subject, sub\_claim\_prefix) and the org id with gh api orgs/<org> --jq .id.<br/>- audiences: accepted aud claims; sts.amazonaws.com unless the CI tool fixes its own (Bitbucket uses ari:cloud:bitbucket::workspace/<uuid>)<br/>- create: create the IAM OIDC provider instead of looking up the existing one (an account holds one per issuer URL)<br/>- thumbprints: only for self-managed issuers whose certificate is not publicly trusted | <pre>map(object({<br/>    url         = string<br/>    subjects    = list(string)<br/>    audiences   = optional(list(string), ["sts.amazonaws.com"])<br/>    create      = optional(bool, false)<br/>    thumbprints = optional(list(string), [])<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_oidc_provider_arns"></a> [oidc\_provider\_arns](#output\_oidc\_provider\_arns) | ARNs of the OIDC providers the role trusts (created or looked up), keyed like oidc\_providers |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of the CI/CD build workflow IAM role. Pass it to nullplatform/asset/ecr as build\_workflow\_role\_arn. |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | Name of the CI/CD build workflow IAM role that asset-repository permission modules (ecr, s3-assets) attach their policies to |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "ci-build-workflow-role",
  "description": "Creates an AWS IAM role for CI/CD build workflows that trusts both an application manager role and multiple OIDC identity providers (GitHub Actions, GitLab CI, Bitbucket Pipelines, etc.) to enable keyless authentication",
  "architecture": "The module creates or looks up `aws_iam_openid_connect_provider` resources for each entry in `oidc_providers` based on the `create` flag, then builds an `aws_iam_role` named `nullplatform-{cluster_name}-build-workflow-role` whose assume-role policy concatenates a direct `sts:AssumeRole` statement for the application manager ARN with `sts:AssumeRoleWithWebIdentity` statements for each OIDC provider. Each OIDC trust statement uses the provider ARN from either the created or looked-up provider and enforces `StringEquals` on audience claims and `StringLike` on subject claims. The role ARN and name are exposed as outputs so downstream asset-repository permission modules (ECR, S3) can attach their policies to it.",
  "features": [
    "Creates or looks up aws_iam_openid_connect_provider resources per CI issuer based on the create flag",
    "Creates an aws_iam_role with a compound assume-role policy supporting both direct role assumption and OIDC web identity federation",
    "Enforces audience and subject claim conditions on each OIDC trust statement to scope access to specific organizations, groups, or repositories",
    "Validates all OIDC provider URLs use HTTPS and that subject patterns do not start with wildcards or expose entire issuers",
    "Supports multiple simultaneous OIDC providers (GitHub Actions, GitLab CI, Bitbucket Pipelines) keyed by free-form name",
    "Outputs role ARN and name for consumption by asset-repository permission modules such as ECR and S3"
  ],
  "inputs": [
    {
      "name": "cluster_name",
      "description": "Name of the cluster, used to namespace IAM resource names",
      "required": true
    },
    {
      "name": "oidc_providers",
      "description": "",
      "required": false
    },
    {
      "name": "application_manager_assume_role",
      "description": "ARN of the IAM role assumed by the application manager",
      "required": false
    }
  ],
  "outputs": [
    "role_arn",
    "role_name",
    "oidc_provider_arns"
  ],
  "hash": "92923254acfa6b1a15c73f792e179fe8"
}
END_AI_METADATA -->
