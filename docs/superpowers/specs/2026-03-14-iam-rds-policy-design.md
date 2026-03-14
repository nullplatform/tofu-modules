# IAM RDS Policy Module Design

**Date:** 2026-03-14
**Status:** Approved
**Module path:** `infrastructure/aws/iam/rds/`

## Overview

A new OpenTofu module that creates three separate IAM policies granting the permissions required to deploy an AWS RDS PostgreSQL instance as defined in the `rds-postgres` service. The module outputs each policy ARN individually so consumers can attach them to any IAM role (e.g., via the `additional_policies` variable on the `iam/agent` module).

## Context

The `rds-postgres` service (`pae-nullplatform/service`) creates the following AWS resources during deployment:
- `aws_security_group` — network isolation for the RDS instance
- `aws_db_instance` — the PostgreSQL database (storage encrypted via AWS-managed key)
- `aws_secretsmanager_secret` + `aws_secretsmanager_secret_version` — master password storage

The IAM principal deploying this service needs permissions across three AWS service domains: RDS, EC2 (security groups), and Secrets Manager.

## Architecture

Follows the same file layout as `infrastructure/aws/iam/agent/`:

```
infrastructure/aws/iam/rds/
├── main.tf        # Three aws_iam_policy resources
├── variables.tf   # Input variables
├── outputs.tf     # Three policy ARN outputs
└── providers.tf   # terraform { required_providers { aws = { source = "hashicorp/aws", version = "~> 6.0" } } }
```

No upstream module dependency. No IAM role is created — only policies. Role attachment is the caller's responsibility.

## Variables

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `name` | `string` | yes | Unique identifier used as part of policy names (e.g., `prod-us-east-1`). **Must be unique per AWS account** — IAM policy names are account-global, so passing the same `name` in two deployments in the same account will cause a name collision. |

Policy names follow the convention `nullplatform_<name>_<suffix>_policy`, matching the existing `iam/agent` naming pattern.

## Resources

### `aws_iam_policy.rds_policy`

Name: `nullplatform_<name>_rds_policy`
Grants permissions to manage RDS instances and subnet groups. Includes describe actions required by the AWS provider during plan/refresh.

Actions:
- `rds:CreateDBInstance`, `rds:DeleteDBInstance`, `rds:ModifyDBInstance`, `rds:DescribeDBInstances`
- `rds:CreateDBSubnetGroup`, `rds:DeleteDBSubnetGroup`, `rds:DescribeDBSubnetGroups`, `rds:ModifyDBSubnetGroup`
- `rds:AddTagsToResource`, `rds:ListTagsForResource`, `rds:RemoveTagsFromResource`
- `rds:DescribeDBParameterGroups`, `rds:DescribeDBParameters` — required by provider on plan/refresh
- `rds:DescribeDBEngineVersions` — required by provider to validate engine/version during plan
- `rds:DescribeOrderableDBInstanceOptions` — required by provider to validate instance class during plan
- `rds:DescribeOptionGroups` — required by provider during refresh

Resource: `*`

Out of scope (not supported by the `rds-postgres` service): `rds:CreateDBInstanceReadReplica`, `rds:RestoreDBInstanceFromDBSnapshot`, `rds:RestoreDBInstanceToPointInTime`.

---

### `aws_iam_policy.rds_sg_policy`

Name: `nullplatform_<name>_rds_sg_policy`
Grants permissions to manage EC2 security groups required by the RDS instance.

Actions:
- `ec2:CreateSecurityGroup`, `ec2:DeleteSecurityGroup`, `ec2:DescribeSecurityGroups`
- `ec2:AuthorizeSecurityGroupIngress`, `ec2:RevokeSecurityGroupIngress`
- `ec2:AuthorizeSecurityGroupEgress`, `ec2:RevokeSecurityGroupEgress`
- `ec2:DescribeVpcs`, `ec2:DescribeSubnets`, `ec2:CreateTags`, `ec2:DescribeNetworkInterfaces`
- `ec2:DescribeSecurityGroupRules` — required by AWS provider v6 during state refresh

Resource: `*`

---

### `aws_iam_policy.rds_secretsmanager_policy`

Name: `nullplatform_<name>_rds_secretsmanager_policy`
Grants permissions to create and manage the master password secret in Secrets Manager.

Actions:
- `secretsmanager:CreateSecret`, `secretsmanager:DeleteSecret`, `secretsmanager:DescribeSecret`
- `secretsmanager:GetSecretValue`, `secretsmanager:PutSecretValue`, `secretsmanager:UpdateSecret`
- `secretsmanager:TagResource`, `secretsmanager:UntagResource`
- `secretsmanager:GetResourcePolicy` — required by provider during state refresh
- `secretsmanager:ListSecretVersionIds` — required by provider to enumerate secret versions on refresh

Resource: `*`

## Outputs

| Name | Description |
|------|-------------|
| `rds_policy_arn` | ARN of the RDS management policy |
| `rds_sg_policy_arn` | ARN of the EC2 security group policy |
| `rds_secretsmanager_policy_arn` | ARN of the Secrets Manager policy |

## Usage Example

```hcl
module "iam_rds" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/rds?ref=vX.Y.Z"
  name   = var.cluster_name
}

module "iam_agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/agent?ref=vX.Y.Z"
  # ...
  additional_policies = {
    rds_policy               = module.iam_rds.rds_policy_arn
    rds_sg_policy            = module.iam_rds.rds_sg_policy_arn
    rds_secretsmanager_policy = module.iam_rds.rds_secretsmanager_policy_arn
  }
}
```

## Design Decisions

- **Wildcard resource ARNs** — no resource-level scoping. Keeps the module generic and avoids requiring instance identifiers at policy creation time (which may not be known yet).
- **No KMS policy** — the `rds-postgres` service uses the AWS-managed RDS encryption key, which does not require explicit IAM permissions.
- **No role creation** — the module is policy-only. This mirrors the intended composability: policies are attached via `additional_policies` on the `iam/agent` module or any other role module.
- **Separate policies per concern** — matches the existing `iam/agent` pattern and allows callers to attach only the policies they need.
