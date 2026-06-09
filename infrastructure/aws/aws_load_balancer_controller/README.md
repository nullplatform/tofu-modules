# Module: aws_load_balancer_controller

## Description

Deploys the AWS Load Balancer Controller Helm chart to an EKS cluster

## Architecture

This module creates a helm_release resource to deploy the AWS Load Balancer Controller chart to a Kubernetes cluster, utilizing a locals template to populate the chart values with input variables such as cluster_name, service_account_name, and vpc_id, and then connects the chart to the cluster via the helm_release resource, the chart values are then used to configure the AWS Load Balancer Controller, the module also relies on the aws_load_balancer_controller_version variable to determine the version of the chart to deploy, the helm_release resource is configured to create the namespace if it does not exist, and to wait for the deployment to complete before considering the resource created

## Features

- Deploys AWS Load Balancer Controller Helm chart to EKS cluster
- Configures AWS Load Balancer Controller with input variables
- Creates Kubernetes namespace for AWS Load Balancer Controller

## Basic Usage

```hcl
module "aws_load_balancer_controller" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/aws_load_balancer_controller?ref=v4.0.1"

  cluster_name = "your-cluster-name"
  vpc_id       = "your-vpc-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.aws_load_balancer_controller.id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [helm_release.aws_load_balancer_controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_load_balancer_controller_version"></a> [aws\_load\_balancer\_controller\_version](#input\_aws\_load\_balancer\_controller\_version) | Version of the AWS Load Balancer Controller Helm chart | `string` | `"1.13.4"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Name of the Kubernetes service account for the AWS Load Balancer Controller | `string` | `"aws-load-balancer-controller"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where load balancers controller will be deployed | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "aws_load_balancer_controller",
  "description": "Deploys the AWS Load Balancer Controller Helm chart to an EKS cluster",
  "architecture": "This module creates a helm_release resource to deploy the AWS Load Balancer Controller chart to a Kubernetes cluster, utilizing a locals template to populate the chart values with input variables such as cluster_name, service_account_name, and vpc_id, and then connects the chart to the cluster via the helm_release resource, the chart values are then used to configure the AWS Load Balancer Controller, the module also relies on the aws_load_balancer_controller_version variable to determine the version of the chart to deploy, the helm_release resource is configured to create the namespace if it does not exist, and to wait for the deployment to complete before considering the resource created",
  "features": [
    "Deploys AWS Load Balancer Controller Helm chart to EKS cluster",
    "Configures AWS Load Balancer Controller with input variables",
    "Creates Kubernetes namespace for AWS Load Balancer Controller"
  ],
  "inputs": [
    {
      "name": "cluster_name",
      "description": "Name of the EKS cluster",
      "required": true
    },
    {
      "name": "vpc_id",
      "description": "VPC ID where load balancers controller will be deployed",
      "required": true
    },
    {
      "name": "aws_load_balancer_controller_version",
      "description": "Version of the AWS Load Balancer Controller Helm chart",
      "required": false
    },
    {
      "name": "service_account_name",
      "description": "Name of the Kubernetes service account for the AWS Load Balancer Controller",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "8f8818b74caceb9db90def379612e433"
}
END_AI_METADATA -->
