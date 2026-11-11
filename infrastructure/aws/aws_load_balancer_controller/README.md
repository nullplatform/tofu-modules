# Module: aws_load_balancer_controller

## Description

Deploys the AWS Load Balancer Controller onto an EKS cluster via a Helm release with a pinned chart version

## Architecture

The module renders a Helm values file from a template using `templatefile()` with `cluster_name`, `service_account_name`, and `vpc_id` inputs stored in `locals`. A single `helm_release` resource targets the `aws-load-balancer-controller` chart from the official EKS Helm repository, installing into the `kube-system` namespace with atomic deployment, cleanup-on-fail, and a 600-second timeout. The chart version is enforced via a validation that rejects empty strings and floating references like `latest`, `main`, or `master`, ensuring every deployment pins an explicit chart version.

## Features

- Deploys AWS Load Balancer Controller into kube-system namespace using helm_release with atomic and cleanup-on-fail guarantees
- Renders cluster-specific Helm values via templatefile() injecting cluster_name, vpc_id, and service_account_name
- Enforces explicit chart version pinning by rejecting empty strings and moving references such as latest, main, or master
- Configures Helm release with force_update, recreate_pods, and reset_values for idempotent and predictable upgrades
- Limits Helm history to 10 releases to prevent unbounded revision accumulation in the cluster

## Basic Usage

```hcl
module "aws_load_balancer_controller" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/aws_load_balancer_controller?ref=v9.14.0"

  aws_load_balancer_controller_version = "your-aws-load-balancer-controller-version"
  cluster_name                         = "your-cluster-name"
  vpc_id                               = "your-vpc-id"
}
```

### Usage with Pinned Chart Version

```hcl
module "aws_load_balancer_controller" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/aws_load_balancer_controller?ref=v9.14.0"

  aws_load_balancer_controller_version = "latest"
  cluster_name                         = "your-cluster-name"
  vpc_id                               = "your-vpc-id"
}
```

### Usage with Pinned Chart Version

```hcl
module "aws_load_balancer_controller" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/aws_load_balancer_controller?ref=v9.14.0"

  aws_load_balancer_controller_version = "main"
  cluster_name                         = "your-cluster-name"
  vpc_id                               = "your-vpc-id"
}
```

### Usage with Pinned Chart Version

```hcl
module "aws_load_balancer_controller" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/aws_load_balancer_controller?ref=v9.14.0"

  aws_load_balancer_controller_version = "master"
  cluster_name                         = "your-cluster-name"
  vpc_id                               = "your-vpc-id"
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
| <a name="input_aws_load_balancer_controller_version"></a> [aws\_load\_balancer\_controller\_version](#input\_aws\_load\_balancer\_controller\_version) | No default: every install pins this deliberately — see VERSIONS.md. Version of the AWS Load Balancer Controller Helm chart. Chart 3.x ships app v3, which needs its CRDs applied by hand (Helm does not upgrade them): pin what the cluster already runs and upgrade deliberately | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Name of the Kubernetes service account for the AWS Load Balancer Controller | `string` | `"aws-load-balancer-controller"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where load balancers controller will be deployed | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "aws_load_balancer_controller",
  "description": "Deploys the AWS Load Balancer Controller onto an EKS cluster via a Helm release with a pinned chart version",
  "architecture": "The module renders a Helm values file from a template using `templatefile()` with `cluster_name`, `service_account_name`, and `vpc_id` inputs stored in `locals`. A single `helm_release` resource targets the `aws-load-balancer-controller` chart from the official EKS Helm repository, installing into the `kube-system` namespace with atomic deployment, cleanup-on-fail, and a 600-second timeout. The chart version is enforced via a validation that rejects empty strings and floating references like `latest`, `main`, or `master`, ensuring every deployment pins an explicit chart version.",
  "features": [
    "Deploys AWS Load Balancer Controller into kube-system namespace using helm_release with atomic and cleanup-on-fail guarantees",
    "Renders cluster-specific Helm values via templatefile() injecting cluster_name, vpc_id, and service_account_name",
    "Enforces explicit chart version pinning by rejecting empty strings and moving references such as latest, main, or master",
    "Configures Helm release with force_update, recreate_pods, and reset_values for idempotent and predictable upgrades",
    "Limits Helm history to 10 releases to prevent unbounded revision accumulation in the cluster"
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
      "description": "No default: every install pins this deliberately — see VERSIONS.md. Version of the AWS Load Balancer Controller Helm chart. Chart 3.x ships app v3, which needs its CRDs applied by hand (Helm does not upgrade them): pin what the cluster already runs and upgrade deliberately",
      "required": true
    },
    {
      "name": "service_account_name",
      "description": "Name of the Kubernetes service account for the AWS Load Balancer Controller",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "2da1f97cc5271e4588cd83e8c084d160"
}
END_AI_METADATA -->
