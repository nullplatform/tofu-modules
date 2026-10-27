# Module: ci-build-workflow-role

## Description

Creates an AWS IAM role for CI/CD build workflows that trusts an application manager role and one or more OIDC identity providers from CI platforms like GitHub Actions, GitLab CI, or Bitbucket Pipelines

## Architecture

The module creates an aws_iam_role named nullplatform-{cluster_name}-build-workflow-role with a composite assume-role policy built from a static application manager principal and dynamic OIDC federated principals. For each entry in oidc_providers, it either creates an aws_iam_openid_connect_provider resource (when create=true) or looks one up via a data source (when create=false), and the resulting ARNs are wired into the role's trust policy as StringEquals audience and StringLike subject conditions. The role ARN and name are exported so downstream asset-repository modules (ecr, s3-assets) can attach their own IAM policies to the same role.

## Features

- Creates an aws_iam_role with a trust policy that allows both an application manager IAM role and OIDC-federated CI identities to assume it
- Creates aws_iam_openid_connect_provider resources for new issuers or looks up existing ones via data source, controlled per-provider with the create flag
- Configures sts:AssumeRoleWithWebIdentity trust conditions scoped to specific OIDC audiences and subject patterns to prevent cross-organization token reuse
- Validates all OIDC provider URLs require HTTPS and subject patterns cannot start with wildcards or span entire issuers
- Supports multiple simultaneous CI OIDC providers keyed by free-form names (e.g. github, gitlab, bitbucket) in a single role trust policy
- Exports role ARN, role name, and OIDC provider ARNs for consumption by asset-repository permission modules

## Basic Usage

```hcl
module "ci-build-workflow-role" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/ci-build-workflow-role?ref=v9.5.0"

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
| <a name="input_oidc_providers"></a> [oidc\_providers](#input\_oidc\_providers) | CI OIDC issuers whose jobs can assume the role, keyed by a free-form name (e.g. github, gitlab, bitbucket).<br/>- url: issuer URL, e.g. https://token.actions.githubusercontent.com, https://gitlab.com or https://api.bitbucket.org/2.0/workspaces/<workspace>/pipelines-config/identity/oidc<br/>- subjects: StringLike patterns on the sub claim, scoped to your organization, group or repositories (e.g. repo:<org>/* for GitHub, project\_path:<group>/* for GitLab)<br/>- audiences: accepted aud claims; sts.amazonaws.com unless the CI tool fixes its own (Bitbucket uses ari:cloud:bitbucket::workspace/<uuid>)<br/>- create: create the IAM OIDC provider instead of looking up the existing one (an account holds one per issuer URL)<br/>- thumbprints: only for self-managed issuers whose certificate is not publicly trusted | <pre>map(object({<br/>    url         = string<br/>    subjects    = list(string)<br/>    audiences   = optional(list(string), ["sts.amazonaws.com"])<br/>    create      = optional(bool, false)<br/>    thumbprints = optional(list(string), [])<br/>  }))</pre> | `{}` | no |

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
  "description": "Creates an AWS IAM role for CI/CD build workflows that trusts an application manager role and one or more OIDC identity providers from CI platforms like GitHub Actions, GitLab CI, or Bitbucket Pipelines",
  "architecture": "The module creates an aws_iam_role named nullplatform-{cluster_name}-build-workflow-role with a composite assume-role policy built from a static application manager principal and dynamic OIDC federated principals. For each entry in oidc_providers, it either creates an aws_iam_openid_connect_provider resource (when create=true) or looks one up via a data source (when create=false), and the resulting ARNs are wired into the role's trust policy as StringEquals audience and StringLike subject conditions. The role ARN and name are exported so downstream asset-repository modules (ecr, s3-assets) can attach their own IAM policies to the same role.",
  "features": [
    "Creates an aws_iam_role with a trust policy that allows both an application manager IAM role and OIDC-federated CI identities to assume it",
    "Creates aws_iam_openid_connect_provider resources for new issuers or looks up existing ones via data source, controlled per-provider with the create flag",
    "Configures sts:AssumeRoleWithWebIdentity trust conditions scoped to specific OIDC audiences and subject patterns to prevent cross-organization token reuse",
    "Validates all OIDC provider URLs require HTTPS and subject patterns cannot start with wildcards or span entire issuers",
    "Supports multiple simultaneous CI OIDC providers keyed by free-form names (e.g. github, gitlab, bitbucket) in a single role trust policy",
    "Exports role ARN, role name, and OIDC provider ARNs for consumption by asset-repository permission modules"
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
  "hash": "bc8f999f284849edd922180088c1d740"
}
END_AI_METADATA -->
