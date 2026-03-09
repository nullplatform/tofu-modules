# Module: alb_controller

## Description

Creates IAM roles and Kubernetes service accounts for the AWS Load Balancer Controller on EKS clusters

## Features

- Creates IAM role for service accounts (IRSA) with AWS Load Balancer Controller permissions
- Configures Kubernetes service account with proper annotations for AWS IAM integration
- Deploys comprehensive IAM policy covering ELB, EC2, WAF, Shield, ACM, and Cognito operations
- Supports condition-based permissions for security group and load balancer management
- Enables automatic load balancer provisioning and management in EKS clusters
- Integrates with OIDC provider for secure AWS credential management

## Basic Usage

```hcl
module "alb_controller" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/alb_controller?ref=v1.43.0"

  aws_iam_openid_connect_provider_arn = "your-aws-iam-openid-connect-provider-arn"
  cluster_name                        = "your-cluster-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.alb_controller.role_arn
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
