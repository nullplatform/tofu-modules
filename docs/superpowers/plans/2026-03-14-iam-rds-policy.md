# IAM RDS Policy Module Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create `infrastructure/aws/iam/rds/` — an OpenTofu module that provisions three IAM policies (RDS, EC2 security groups, Secrets Manager) needed to deploy an RDS PostgreSQL instance, and outputs their ARNs.

**Architecture:** Three `aws_iam_policy` resources with wildcard resource ARNs, no IAM role creation. Follows the exact same file layout and naming convention as `infrastructure/aws/iam/agent/` and `infrastructure/aws/iam/aws_load_balancer_controller_iam/`. Consumers attach the output ARNs to any role via `additional_policies`.

**Tech Stack:** OpenTofu, AWS provider `~> 6.0` (no explicit version constraint file — follows existing IAM module convention), OpenTofu native test framework (`.tftest.hcl` with `mock_provider`)

**Spec:** `docs/superpowers/specs/2026-03-14-iam-rds-policy-design.md`

---

## Chunk 1: Module Scaffold + Tests + Implementation

### Task 1: Create module skeleton

**Files:**
- Create: `infrastructure/aws/iam/rds/variables.tf`

Note: No `providers.tf` or `versions.tf` — all existing IAM modules (`agent`, `aws_load_balancer_controller_iam`, `cert_manager`, `external_dns`) omit this file and rely on the root module's provider configuration.

- [ ] **Step 1: Create `variables.tf`**

```hcl
variable "name" {
  description = "Unique identifier for policy naming. Must be unique per AWS account (IAM policy names are account-global). Example: \"prod-us-east-1\"."
  type        = string
}
```

- [ ] **Step 2: Format**

```bash
cd infrastructure/aws/iam/rds && tofu fmt
```

- [ ] **Step 3: Commit**

```bash
git add infrastructure/aws/iam/rds/variables.tf
git commit -m "feat(iam/rds): scaffold module with name variable"
```

---

### Task 2: Write failing tests

**Files:**
- Create: `infrastructure/aws/iam/rds/tests/rds.tftest.hcl`

- [ ] **Step 1: Create `tests/rds.tftest.hcl`**

```hcl
mock_provider "aws" {
  override_resource {
    target = aws_iam_policy.rds_policy
    values = {
      arn = "arn:aws:iam::123456789012:policy/nullplatform_test_rds_policy"
    }
  }
  override_resource {
    target = aws_iam_policy.rds_sg_policy
    values = {
      arn = "arn:aws:iam::123456789012:policy/nullplatform_test_rds_sg_policy"
    }
  }
  override_resource {
    target = aws_iam_policy.rds_secretsmanager_policy
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
    condition     = aws_iam_policy.rds_policy.name == "nullplatform_test_rds_policy"
    error_message = "RDS policy name should follow naming convention"
  }
}

run "rds_sg_policy_naming" {
  command = plan

  assert {
    condition     = aws_iam_policy.rds_sg_policy.name == "nullplatform_test_rds_sg_policy"
    error_message = "RDS security group policy name should follow naming convention"
  }
}

run "rds_secretsmanager_policy_naming" {
  command = plan

  assert {
    condition     = aws_iam_policy.rds_secretsmanager_policy.name == "nullplatform_test_rds_secretsmanager_policy"
    error_message = "RDS Secrets Manager policy name should follow naming convention"
  }
}

run "all_policies_valid_json" {
  command = plan

  assert {
    condition     = can(jsondecode(aws_iam_policy.rds_policy.policy))
    error_message = "RDS policy should be valid JSON"
  }

  assert {
    condition     = can(jsondecode(aws_iam_policy.rds_sg_policy.policy))
    error_message = "RDS security group policy should be valid JSON"
  }

  assert {
    condition     = can(jsondecode(aws_iam_policy.rds_secretsmanager_policy.policy))
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
```

- [ ] **Step 2: Init and validate**

```bash
cd infrastructure/aws/iam/rds && tofu init -backend=false -lockfile=readonly && tofu validate
```

- [ ] **Step 3: Run tests — verify they fail**

```bash
tofu test
```

Expected: FAIL — reference resolution error ("Reference to undeclared resource `aws_iam_policy.rds_policy`"). This is the expected red state — the resources do not exist yet. This is not an assertion failure; it is a config-parse error caused by missing resource definitions. That is correct TDD form here.

- [ ] **Step 4: Commit**

```bash
git add infrastructure/aws/iam/rds/tests/rds.tftest.hcl
git commit -m "test(iam/rds): add failing tests for policy naming, JSON validity, and outputs"
```

---

### Task 3: Implement `main.tf`

**Files:**
- Create: `infrastructure/aws/iam/rds/main.tf`

- [ ] **Step 1: Create `main.tf`**

```hcl
################################################################################
# RDS IAM policy
################################################################################

resource "aws_iam_policy" "rds_policy" {
  name        = "nullplatform_${var.name}_rds_policy"
  description = "Policy for managing RDS instances and subnet groups"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "rds:CreateDBInstance",
          "rds:DeleteDBInstance",
          "rds:ModifyDBInstance",
          "rds:DescribeDBInstances",
          "rds:CreateDBSubnetGroup",
          "rds:DeleteDBSubnetGroup",
          "rds:DescribeDBSubnetGroups",
          "rds:ModifyDBSubnetGroup",
          "rds:AddTagsToResource",
          "rds:ListTagsForResource",
          "rds:RemoveTagsFromResource",
          "rds:DescribeDBParameterGroups",
          "rds:DescribeDBParameters",
          "rds:DescribeDBEngineVersions",
          "rds:DescribeOrderableDBInstanceOptions",
          "rds:DescribeOptionGroups"
        ]
        Resource = "*"
      }
    ]
  })
}

################################################################################
# EC2 Security Group IAM policy
################################################################################

resource "aws_iam_policy" "rds_sg_policy" {
  name        = "nullplatform_${var.name}_rds_sg_policy"
  description = "Policy for managing EC2 security groups for RDS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:DescribeSecurityGroups",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:CreateTags",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeSecurityGroupRules"
        ]
        Resource = "*"
      }
    ]
  })
}

################################################################################
# Secrets Manager IAM policy
################################################################################

resource "aws_iam_policy" "rds_secretsmanager_policy" {
  name        = "nullplatform_${var.name}_rds_secretsmanager_policy"
  description = "Policy for managing Secrets Manager secrets for RDS master password"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:CreateSecret",
          "secretsmanager:DeleteSecret",
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecret",
          "secretsmanager:TagResource",
          "secretsmanager:UntagResource",
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:ListSecretVersionIds"
        ]
        Resource = "*"
      }
    ]
  })
}
```

- [ ] **Step 2: Format**

```bash
cd infrastructure/aws/iam/rds && tofu fmt
```

- [ ] **Step 3: Commit**

```bash
git add infrastructure/aws/iam/rds/main.tf
git commit -m "feat(iam/rds): implement three IAM policy resources"
```

---

### Task 4: Implement `output.tf`, run tests green, final commit

**Files:**
- Create: `infrastructure/aws/iam/rds/output.tf`

Note: Filename is `output.tf` (singular) — matching the convention used by all other IAM modules in this repo (`iam/agent/output.tf`, `iam/aws_load_balancer_controller_iam/output.tf`).

- [ ] **Step 1: Create `output.tf`**

```hcl
output "rds_policy_arn" {
  description = "ARN of the RDS management policy"
  value       = aws_iam_policy.rds_policy.arn
}

output "rds_sg_policy_arn" {
  description = "ARN of the EC2 security group policy"
  value       = aws_iam_policy.rds_sg_policy.arn
}

output "rds_secretsmanager_policy_arn" {
  description = "ARN of the Secrets Manager policy"
  value       = aws_iam_policy.rds_secretsmanager_policy.arn
}
```

- [ ] **Step 2: Format**

```bash
cd infrastructure/aws/iam/rds && tofu fmt
```

- [ ] **Step 3: Validate**

```bash
tofu validate
```

Expected: `Success! The configuration is valid.`

- [ ] **Step 4: Run tests — verify all pass**

```bash
tofu test
```

Expected: All 5 test runs PASS (`rds_policy_naming`, `rds_sg_policy_naming`, `rds_secretsmanager_policy_naming`, `all_policies_valid_json`, `outputs_return_correct_arns`).

- [ ] **Step 5: Commit**

```bash
git add infrastructure/aws/iam/rds/output.tf
git commit -m "feat(iam/rds): add outputs for all three policy ARNs"
```
