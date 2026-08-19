# Module: agent

## Description

Deploys the Nullplatform agent to a Kubernetes cluster via a Helm release with multi-cloud provider support

## Architecture

The module renders a Helm values file using a templatefile() call that merges default configuration, cloud-specific environment variables, and extra envs into a single locals map. A helm_release resource named 'agent' deploys the 'nullplatform-agent' chart from the official Nullplatform Helm repository into the specified Kubernetes namespace, consuming the rendered values. A terraform_data resource tracks the api_key as a replace trigger, forcing pod recreation when the API key changes. Cross-provider variable validation is enforced via terraform_data preconditions that gate cloud-specific required inputs like aws_iam_role_arn and azure_* credentials before the Helm release proceeds.

## Features

- Deploys nullplatform-agent Helm chart with atomic install and automatic cleanup on failure
- Configures multi-cloud provider support for AWS, GCP, Azure, and OCI with provider-specific environment variable injection
- Creates Kubernetes namespace automatically if it does not already exist
- Injects NRN-parsed organization, account, and namespace tags into the agent configuration
- Merges scope repository, extra Git repositories, and deduplicates the final agent repo list
- Forces pod recreation via terraform_data trigger when the API key is rotated
- Supports custom init scripts, image pull secrets, and additional environment variables for agent customization

## Basic Usage

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v7.1.0"

  api_key        = "your-api-key"
  cloud_provider = "your-cloud-provider"
  cluster_name   = "your-cluster-name"
  image_tag      = "your-image-tag"
  nrn            = "your-nrn"
  tags_selectors = "your-tags-selectors"
}
```

### Usage with AWS Cloud Provider

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v7.1.0"

  api_key          = "your-api-key"
  aws_iam_role_arn = "your-aws-iam-role-arn"  # Required when cloud_provider = "aws"
  cloud_provider   = "aws"
  cluster_name     = "your-cluster-name"
  image_tag        = "your-image-tag"
  nrn              = "your-nrn"
  tags_selectors   = "your-tags-selectors"
}
```

### Usage with GCP Cloud Provider

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v7.1.0"

  api_key        = "your-api-key"
  cloud_provider = "gcp"
  cluster_name   = "your-cluster-name"
  image_tag      = "your-image-tag"
  nrn            = "your-nrn"
  tags_selectors = "your-tags-selectors"
}
```

### Usage with Azure Cloud Provider

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v7.1.0"

  api_key                = "your-api-key"
  azure_client_id        = "your-azure-client-id"  # Required when cloud_provider = "azure"
  azure_client_secret    = "your-azure-client-secret"  # Required when cloud_provider = "azure"
  azure_resource_group   = "your-azure-resource-group"  # Required when cloud_provider = "azure"
  azure_subscription_id  = "your-azure-subscription-id"  # Required when cloud_provider = "azure"
  azure_tenant_id        = "your-azure-tenant-id"  # Required when cloud_provider = "azure"
  cloud_provider         = "azure"
  cluster_name           = "your-cluster-name"
  image_tag              = "your-image-tag"
  nrn                    = "your-nrn"
  private_gateway_name   = "your-private-gateway-name"  # Required when cloud_provider = "azure"
  private_hosted_zone_rg = "your-private-hosted-zone-rg"  # Required when cloud_provider = "azure"
  public_gateway_name    = "your-public-gateway-name"  # Required when cloud_provider = "azure"
  tags_selectors         = "your-tags-selectors"
}
```

### Usage with OCI Cloud Provider

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v7.1.0"

  api_key        = "your-api-key"
  cloud_provider = "oci"
  cluster_name   = "your-cluster-name"
  image_tag      = "your-image-tag"
  nrn            = "your-nrn"
  tags_selectors = "your-tags-selectors"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.agent.id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.1.1 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.agent](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [terraform_data.api_key_trigger](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.cross_variable_validation](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_repos_extra"></a> [agent\_repos\_extra](#input\_agent\_repos\_extra) | List of additional Git repositories used for extended agent configuration | `list(string)` | `[]` | no |
| <a name="input_agent_repos_scope"></a> [agent\_repos\_scope](#input\_agent\_repos\_scope) | Git repository URL containing agent scope configurations (format: repo#branch) | `string` | `"https://github.com/nullplatform/scopes.git#main"` | no |
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | API key for authenticating with the nullplatform API | `string` | n/a | yes |
| <a name="input_aws_iam_role_arn"></a> [aws\_iam\_role\_arn](#input\_aws\_iam\_role\_arn) | ARN of the AWS IAM role assigned to the agent | `string` | `""` | no |
| <a name="input_azure_client_id"></a> [azure\_client\_id](#input\_azure\_client\_id) | Azure client ID for authentication | `string` | `null` | no |
| <a name="input_azure_client_secret"></a> [azure\_client\_secret](#input\_azure\_client\_secret) | Azure client secret for authentication | `string` | `null` | no |
| <a name="input_azure_resource_group"></a> [azure\_resource\_group](#input\_azure\_resource\_group) | Azure resource group name | `string` | `null` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | Azure subscription ID | `string` | `null` | no |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | Azure tenant ID | `string` | `null` | no |
| <a name="input_blue_green_ingress_path"></a> [blue\_green\_ingress\_path](#input\_blue\_green\_ingress\_path) | Specifies the ingress path used for blue-green deployments to route traffic to the new version. | `string` | `""` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Cloud provider to use (aws, gcp, or azure) | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster where the nullplatform agent will be deployed | `string` | n/a | yes |
| <a name="input_dns_type"></a> [dns\_type](#input\_dns\_type) | Type of DNS Provider, ej: azure, route53, or external\_dns | `string` | `""` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Base domain name used across resources | `string` | `""` | no |
| <a name="input_extra_envs"></a> [extra\_envs](#input\_extra\_envs) | Additional environment variables to pass to the agent | `map(string)` | `{}` | no |
| <a name="input_image_pull_secrets"></a> [image\_pull\_secrets](#input\_image\_pull\_secrets) | Image pull secrets configuration | `string` | `""` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Container image repository for the agent. Defaults to the official nullplatform image. | `string` | `""` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Image tag for the agent container image | `string` | n/a | yes |
| <a name="input_init_scripts"></a> [init\_scripts](#input\_init\_scripts) | List of initialization scripts to execute during agent startup | `list(string)` | `[]` | no |
| <a name="input_initial_ingress_path"></a> [initial\_ingress\_path](#input\_initial\_ingress\_path) | Defines the initial ingress path used when deploying the application for the first time. | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace where the nullplatform agent will run | `string` | `"nullplatform-tools"` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name - unique identifier for nullplatform resources | `string` | n/a | yes |
| <a name="input_nullplatform_agent_helm_version"></a> [nullplatform\_agent\_helm\_version](#input\_nullplatform\_agent\_helm\_version) | Version of the nullplatform agent Helm chart to deploy | `string` | `"2.37.0"` | no |
| <a name="input_private_domain"></a> [private\_domain](#input\_private\_domain) | Private domain name used for internal agent routing | `string` | `""` | no |
| <a name="input_private_gateway_name"></a> [private\_gateway\_name](#input\_private\_gateway\_name) | Private gateway name for Azure networking | `string` | `null` | no |
| <a name="input_private_hosted_zone_rg"></a> [private\_hosted\_zone\_rg](#input\_private\_hosted\_zone\_rg) | Resource group for private hosted zone | `string` | `null` | no |
| <a name="input_public_gateway_name"></a> [public\_gateway\_name](#input\_public\_gateway\_name) | Public gateway name for Azure networking | `string` | `null` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Override for the Helm release name. Defaults to nullplatform-agent | `string` | `"nullplatform-agent"` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Override for the Kubernetes ServiceAccount name created by the Helm chart | `string` | `""` | no |
| <a name="input_service_template"></a> [service\_template](#input\_service\_template) | Specifies the name or reference of the scope service template to be used for deployment. | `string` | `""` | no |
| <a name="input_tags_selectors"></a> [tags\_selectors](#input\_tags\_selectors) | Map of tags used to select and filter channels and agents | `map(string)` | n/a | yes |
| <a name="input_use_account_slug"></a> [use\_account\_slug](#input\_use\_account\_slug) | Flag to determine whether to use account slug in resource naming | `string` | `""` | no |
| <a name="input_worker"></a> [worker](#input\_worker) | Worker-orchestration config, merged into the agent chart's `worker` block:<br/>backend, security, allowedRegistries (deny-by-default registry guardrail),<br/>patches (standard k8s patching of workers — the preferred way to shape them),<br/>idleTTL (reap idle workers), and the legacy defaults/rules/pins. See the<br/>nullplatform-agent chart values (>= 2.37.0) for the full shape. null = chart<br/>defaults.<br/><br/>Example:<br/>  worker = {<br/>    allowedRegistries = ["public.ecr.aws/your-org/*"]<br/>    patches           = [{ target = { package = "my-pkg" }, merge = { spec = { serviceAccountName = "np-agent-sa" } } }]<br/>    idleTTL           = "30m"<br/>  } | `any` | `null` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "agent",
  "description": "Deploys the Nullplatform agent to a Kubernetes cluster via a Helm release with multi-cloud provider support",
  "architecture": "The module renders a Helm values file using a templatefile() call that merges default configuration, cloud-specific environment variables, and extra envs into a single locals map. A helm_release resource named 'agent' deploys the 'nullplatform-agent' chart from the official Nullplatform Helm repository into the specified Kubernetes namespace, consuming the rendered values. A terraform_data resource tracks the api_key as a replace trigger, forcing pod recreation when the API key changes. Cross-provider variable validation is enforced via terraform_data preconditions that gate cloud-specific required inputs like aws_iam_role_arn and azure_* credentials before the Helm release proceeds.",
  "features": [
    "Deploys nullplatform-agent Helm chart with atomic install and automatic cleanup on failure",
    "Configures multi-cloud provider support for AWS, GCP, Azure, and OCI with provider-specific environment variable injection",
    "Creates Kubernetes namespace automatically if it does not already exist",
    "Injects NRN-parsed organization, account, and namespace tags into the agent configuration",
    "Merges scope repository, extra Git repositories, and deduplicates the final agent repo list",
    "Forces pod recreation via terraform_data trigger when the API key is rotated",
    "Supports custom init scripts, image pull secrets, and additional environment variables for agent customization"
  ],
  "inputs": [
    {
      "name": "api_key",
      "description": "API key for authenticating with the nullplatform API",
      "required": true
    },
    {
      "name": "cluster_name",
      "description": "Name of the EKS cluster where the nullplatform agent will be deployed",
      "required": true
    },
    {
      "name": "nrn",
      "description": "Nullplatform Resource Name - unique identifier for nullplatform resources",
      "required": true
    },
    {
      "name": "tags_selectors",
      "description": "Map of tags used to select and filter channels and agents",
      "required": true
    },
    {
      "name": "image_tag",
      "description": "Image tag for the agent container image",
      "required": true
    },
    {
      "name": "cloud_provider",
      "description": "Cloud provider to use (aws, gcp, or azure)",
      "required": true
    },
    {
      "name": "release_name",
      "description": "Override for the Helm release name. Defaults to nullplatform-agent",
      "required": false
    },
    {
      "name": "service_account_name",
      "description": "Override for the Kubernetes ServiceAccount name created by the Helm chart",
      "required": false
    },
    {
      "name": "nullplatform_agent_helm_version",
      "description": "Version of the nullplatform agent Helm chart to deploy",
      "required": false
    },
    {
      "name": "namespace",
      "description": "Kubernetes namespace where the nullplatform agent will run",
      "required": false
    },
    {
      "name": "agent_repos_scope",
      "description": "Git repository URL containing agent scope configurations (format: repo#branch)",
      "required": false
    },
    {
      "name": "agent_repos_extra",
      "description": "List of additional Git repositories used for extended agent configuration",
      "required": false
    },
    {
      "name": "init_scripts",
      "description": "List of initialization scripts to execute during agent startup",
      "required": false
    },
    {
      "name": "image_repository",
      "description": "Container image repository for the agent. Defaults to the official nullplatform image.",
      "required": false
    },
    {
      "name": "aws_iam_role_arn",
      "description": "ARN of the AWS IAM role assigned to the agent",
      "required": false
    },
    {
      "name": "azure_client_id",
      "description": "Azure client ID for authentication",
      "required": false
    },
    {
      "name": "azure_client_secret",
      "description": "Azure client secret for authentication",
      "required": false
    },
    {
      "name": "azure_subscription_id",
      "description": "Azure subscription ID",
      "required": false
    },
    {
      "name": "azure_resource_group",
      "description": "Azure resource group name",
      "required": false
    },
    {
      "name": "private_gateway_name",
      "description": "Private gateway name for Azure networking",
      "required": false
    },
    {
      "name": "private_hosted_zone_rg",
      "description": "Resource group for private hosted zone",
      "required": false
    },
    {
      "name": "public_gateway_name",
      "description": "Public gateway name for Azure networking",
      "required": false
    },
    {
      "name": "azure_tenant_id",
      "description": "Azure tenant ID",
      "required": false
    },
    {
      "name": "dns_type",
      "description": "Type of DNS Provider, ej: azure, route53, or external_dns",
      "required": false
    },
    {
      "name": "domain",
      "description": "Base domain name used across resources",
      "required": false
    },
    {
      "name": "private_domain",
      "description": "Private domain name used for internal agent routing",
      "required": false
    },
    {
      "name": "use_account_slug",
      "description": "Flag to determine whether to use account slug in resource naming",
      "required": false
    },
    {
      "name": "image_pull_secrets",
      "description": "Image pull secrets configuration",
      "required": false
    },
    {
      "name": "service_template",
      "description": "Specifies the name or reference of the scope service template to be used for deployment.",
      "required": false
    },
    {
      "name": "initial_ingress_path",
      "description": "Defines the initial ingress path used when deploying the application for the first time.",
      "required": false
    },
    {
      "name": "blue_green_ingress_path",
      "description": "Specifies the ingress path used for blue-green deployments to route traffic to the new version.",
      "required": false
    },
    {
      "name": "extra_envs",
      "description": "Additional environment variables to pass to the agent",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "e0d42905b16b6cea2f88a15d3dda544a"
}
END_AI_METADATA -->
