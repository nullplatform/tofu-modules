# Module: alb_controller

## Description

Provisions IAM roles, policies, and Kubernetes service accounts required for the AWS Load Balancer Controller in an EKS cluster

## Features

- Creates an IAM role for the AWS Load Balancer Controller with OIDC authentication
- Configures comprehensive IAM policies for managing Elastic Load Balancers, target groups, and security groups
- Provisions a Kubernetes service account in the kube-system namespace with appropriate annotations
- Enables management of Application and Network Load Balancers within the EKS cluster
- Supports WAF and Shield integration for load balancer protection
- Implements least-privilege access with conditional IAM policies based on resource tags

## Basic Usage

```hcl
module "alb_controller" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/alb_controller?ref=v1.40.0"

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
