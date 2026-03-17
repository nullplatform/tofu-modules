################################################################################
# Policy attachments (only when role_name is provided)
################################################################################

resource "aws_iam_role_policy_attachment" "rds" {
  count      = var.role_name != null ? 1 : 0
  role       = var.role_name
  policy_arn = aws_iam_policy.nullplatform_rds_policy.arn
}

resource "aws_iam_role_policy_attachment" "rds_sg" {
  count      = var.role_name != null ? 1 : 0
  role       = var.role_name
  policy_arn = aws_iam_policy.nullplatform_rds_sg_policy.arn
}

resource "aws_iam_role_policy_attachment" "rds_secretsmanager" {
  count      = var.role_name != null ? 1 : 0
  role       = var.role_name
  policy_arn = aws_iam_policy.nullplatform_rds_secretsmanager_policy.arn
}

resource "aws_iam_role_policy_attachment" "rds_s3" {
  count      = var.role_name != null ? 1 : 0
  role       = var.role_name
  policy_arn = aws_iam_policy.nullplatform_rds_s3_policy.arn
}

################################################################################
# RDS IAM policy
################################################################################

# Grant permissions to manage RDS instances and subnet groups
resource "aws_iam_policy" "nullplatform_rds_policy" {
  name        = "nullplatform_${var.name}_rds_policy"
  description = "Policy for managing RDS instances and subnet groups"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
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
          "rds:DescribeOptionGroups",
          "iam:CreateServiceLinkedRole"
        ],
        "Resource" : "*"
      }
    ]
  })
}

################################################################################
# EC2 Security Group IAM policy
################################################################################

# Grant permissions to manage EC2 security groups for RDS
resource "aws_iam_policy" "nullplatform_rds_sg_policy" {
  name        = "nullplatform_${var.name}_rds_sg_policy"
  description = "Policy for managing EC2 security groups for RDS"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:DescribeSecurityGroups",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:DescribeVpcs",
          "ec2:DescribeVpcAttribute",
          "ec2:DescribeSubnets",
          "ec2:CreateTags",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeSecurityGroupRules"
        ],
        "Resource" : "*"
      }
    ]
  })
}

################################################################################
# S3 IAM policy (per-service tfstate buckets: np-service-<id>)
################################################################################

# Grant permissions to manage the per-link S3 bucket used to store tofu state
resource "aws_iam_policy" "nullplatform_rds_s3_policy" {
  name        = "nullplatform_${var.name}_rds_s3_policy"
  description = "Policy for managing per-service S3 tfstate buckets (np-service-*)"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:CreateBucket",
          "s3:HeadBucket",
          "s3:PutBucketVersioning",
          "s3:ListBucket",
          "s3:ListBucketVersions",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
          "s3:DeleteBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::np-service-*",
          "arn:aws:s3:::np-service-*/*"
        ]
      }
    ]
  })
}

################################################################################
# Secrets Manager IAM policy
################################################################################

# Grant permissions to manage Secrets Manager secrets for RDS master password
resource "aws_iam_policy" "nullplatform_rds_secretsmanager_policy" {
  name        = "nullplatform_${var.name}_rds_secretsmanager_policy"
  description = "Policy for managing Secrets Manager secrets for RDS master password"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
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
        ],
        "Resource" : "*"
      }
    ]
  })
}
