# Module: agent

## Description

Deploys the nullplatform agent to a Kubernetes cluster via a Helm chart, configuring cloud-provider-specific identity, worker orchestration, and traffic manager settings

## Architecture

The module renders a YAML values file via templatefile() from locally computed locals, then provisions a single helm_release resource named 'agent' targeting the nullplatform-agent chart from the official Helm repository. A terraform_data resource tracks the api_key to force helm_release replacement when credentials rotate, while a second terraform_data resource enforces cross-variable preconditions (e.g. aws_iam_role_arn for AWS, azure_* vars for Azure) before the release is applied. Cloud-provider-specific environment variables, worker patches, and ServiceAccount bindings are merged into the chart values, with extra_envs taking final precedence over all computed defaults.

## Features

- Deploys nullplatform-agent helm_release with atomic rollback, cleanup-on-fail, and 10-release history cap
- Renders cloud-provider-specific Helm values for AWS (IAM role ARN injection), Azure (client credentials and resource group), GCP, and OCI
- Configures worker orchestrator patches to set ServiceAccount, memory limits, and environment variables per worker-orchestrated package
- Enforces pinned versioning for both the Helm chart and traffic manager image tag, rejecting empty or moving references like 'latest'
- Injects TRAFFIC_CONTAINER_IMAGE into worker env by combining agent_traffic_manager_repository and agent_traffic_manager_tag locals
- Supports namespace auto-creation via create_namespace and merges user-supplied extra_envs over all computed defaults
- Triggers full helm_release replacement via terraform_data when the api_key value changes

## Basic Usage

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v8.0.0"

  agent_traffic_manager_tag       = "your-agent-traffic-manager-tag"
  api_key                         = "your-api-key"
  cloud_provider                  = "your-cloud-provider"
  image_tag                       = "your-image-tag"
  nullplatform_agent_helm_version = "your-nullplatform-agent-helm-version"
  tags_selectors                  = "your-tags-selectors"
}
```

### Usage with AWS Cloud Provider

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v8.0.0"

  agent_traffic_manager_tag       = "your-agent-traffic-manager-tag"
  api_key                         = "your-api-key"
  aws_iam_role_arn                = "your-aws-iam-role-arn"  # Required when cloud_provider = "aws"
  cloud_provider                  = "aws"
  image_tag                       = "your-image-tag"
  nullplatform_agent_helm_version = "your-nullplatform-agent-helm-version"
  tags_selectors                  = "your-tags-selectors"
}
```

### Usage with GCP Cloud Provider

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v8.0.0"

  agent_traffic_manager_tag       = "your-agent-traffic-manager-tag"
  api_key                         = "your-api-key"
  cloud_provider                  = "gcp"
  image_tag                       = "your-image-tag"
  nullplatform_agent_helm_version = "your-nullplatform-agent-helm-version"
  tags_selectors                  = "your-tags-selectors"
}
```

### Usage with Azure Cloud Provider

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v8.0.0"

  agent_traffic_manager_tag       = "your-agent-traffic-manager-tag"
  api_key                         = "your-api-key"
  azure_client_id                 = "your-azure-client-id"  # Required when cloud_provider = "azure"
  azure_client_secret             = "your-azure-client-secret"  # Required when cloud_provider = "azure"
  azure_resource_group            = "your-azure-resource-group"  # Required when cloud_provider = "azure"
  azure_subscription_id           = "your-azure-subscription-id"  # Required when cloud_provider = "azure"
  azure_tenant_id                 = "your-azure-tenant-id"  # Required when cloud_provider = "azure"
  cloud_provider                  = "azure"
  image_tag                       = "your-image-tag"
  nullplatform_agent_helm_version = "your-nullplatform-agent-helm-version"
  private_hosted_zone_rg          = "your-private-hosted-zone-rg"  # Required when cloud_provider = "azure"
  tags_selectors                  = "your-tags-selectors"
}
```

### Usage with OCI Cloud Provider

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v8.0.0"

  agent_traffic_manager_tag       = "your-agent-traffic-manager-tag"
  api_key                         = "your-api-key"
  cloud_provider                  = "oci"
  image_tag                       = "your-image-tag"
  nullplatform_agent_helm_version = "your-nullplatform-agent-helm-version"
  tags_selectors                  = "your-tags-selectors"
}
```

### Usage with Pinned Helm Chart Version

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v8.0.0"

  agent_traffic_manager_tag       = "your-agent-traffic-manager-tag"
  api_key                         = "your-api-key"
  cloud_provider                  = "your-cloud-provider"
  image_tag                       = "your-image-tag"
  nullplatform_agent_helm_version = "fixed semver (e.g. 2.37.0)"
  tags_selectors                  = "your-tags-selectors"
}
```

### Usage with Pinned Traffic Manager Tag

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v8.0.0"

  agent_traffic_manager_tag       = "fixed semver (e.g. 1.8.0)"
  api_key                         = "your-api-key"
  cloud_provider                  = "your-cloud-provider"
  image_tag                       = "your-image-tag"
  nullplatform_agent_helm_version = "your-nullplatform-agent-helm-version"
  tags_selectors                  = "your-tags-selectors"
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
| <a name="input_agent_repo"></a> [agent\_repo](#input\_agent\_repo) | Git repositories (each with a ref) the agent clones for its legacy<br/>command-executor exec flow. Joined into a comma-separated AGENT\_REPO<br/>value, no spaces. Empty when every scope uses worker\_orchestrator instead.<br/><br/>Example:<br/>  agent\_repo = [<br/>    "https://github.com/nullplatform/scopes.git#v1.15.1",<br/>    "https://github.com/nullplatform/services-s-3.git#v0.3.0",<br/>  ] | `list(string)` | `[]` | no |
| <a name="input_agent_traffic_manager_repository"></a> [agent\_traffic\_manager\_repository](#input\_agent\_traffic\_manager\_repository) | Container image repository for the traffic manager. Defaults to the official nullplatform image; override to pull from a mirror. Matches the pattern nullplatform/base uses for its own images. | `string` | `"public.ecr.aws/nullplatform/k8s-traffic-manager"` | no |
| <a name="input_agent_traffic_manager_tag"></a> [agent\_traffic\_manager\_tag](#input\_agent\_traffic\_manager\_tag) | No default: every install pins this deliberately — see VERSIONS.md. Image tag for the traffic manager, published to the agent as TRAFFIC\_CONTAINER\_IMAGE. Pinning this used to mean passing the whole image string through extra\_envs; the registry lives here so only the tag is exposed. extra\_envs still takes precedence for anyone who needs a digest or a mirrored path. | `string` | n/a | yes |
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | API key for authenticating with the nullplatform API | `string` | n/a | yes |
| <a name="input_aws_iam_role_arn"></a> [aws\_iam\_role\_arn](#input\_aws\_iam\_role\_arn) | ARN of the AWS IAM role assigned to the agent | `string` | `""` | no |
| <a name="input_azure_client_id"></a> [azure\_client\_id](#input\_azure\_client\_id) | Azure client ID for authentication | `string` | `null` | no |
| <a name="input_azure_client_secret"></a> [azure\_client\_secret](#input\_azure\_client\_secret) | Azure client secret for authentication | `string` | `null` | no |
| <a name="input_azure_resource_group"></a> [azure\_resource\_group](#input\_azure\_resource\_group) | Azure resource group name | `string` | `null` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | Azure subscription ID | `string` | `null` | no |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | Azure tenant ID | `string` | `null` | no |
| <a name="input_blue_green_ingress_path"></a> [blue\_green\_ingress\_path](#input\_blue\_green\_ingress\_path) | Specifies the ingress path used for blue-green deployments to route traffic to the new version. Required when extra\_envs.INGRESS\_TYPE is 'istio' — the k8s scope's default template is AWS ALB Ingress and won't route traffic correctly through Istio, so it must be pointed at an Istio HTTPRoute template instead. | `string` | `""` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Cloud provider to use ('aws', 'gcp', 'azure', or 'oci') | `string` | n/a | yes |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create the namespace if it does not exist. Leave true unless another module already owns it: nullplatform/base declares the same namespace with Helm ownership metadata, so with no ordering edge between the two whichever applies second fails. | `bool` | `true` | no |
| <a name="input_dns_type"></a> [dns\_type](#input\_dns\_type) | Type of DNS Provider, ej: azure, route53, or external\_dns | `string` | `""` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Base domain name used across resources | `string` | `""` | no |
| <a name="input_extra_envs"></a> [extra\_envs](#input\_extra\_envs) | Additional environment variables to pass to the agent | `map(string)` | `{}` | no |
| <a name="input_image_pull_secrets"></a> [image\_pull\_secrets](#input\_image\_pull\_secrets) | Image pull secrets configuration | `string` | `""` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Container image repository for the agent. Defaults to the official nullplatform image. | `string` | `""` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Image tag for the agent container image | `string` | n/a | yes |
| <a name="input_init_scripts"></a> [init\_scripts](#input\_init\_scripts) | List of initialization scripts to execute during agent startup | `list(string)` | `[]` | no |
| <a name="input_initial_ingress_path"></a> [initial\_ingress\_path](#input\_initial\_ingress\_path) | Defines the initial ingress path used when deploying the application for the first time. Required when extra\_envs.INGRESS\_TYPE is 'istio' — the k8s scope's default template is AWS ALB Ingress and won't route traffic correctly through Istio, so it must be pointed at an Istio HTTPRoute template instead. | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace where the nullplatform agent will run | `string` | `"nullplatform-tools"` | no |
| <a name="input_nullplatform_agent_helm_version"></a> [nullplatform\_agent\_helm\_version](#input\_nullplatform\_agent\_helm\_version) | No default: every install pins this deliberately — see VERSIONS.md. Version of the nullplatform agent Helm chart to deploy | `string` | n/a | yes |
| <a name="input_private_gateway_name"></a> [private\_gateway\_name](#input\_private\_gateway\_name) | Name of the private/internal gateway used for routing | `string` | `"gateway-private"` | no |
| <a name="input_private_hosted_zone_rg"></a> [private\_hosted\_zone\_rg](#input\_private\_hosted\_zone\_rg) | Resource group for private hosted zone | `string` | `null` | no |
| <a name="input_public_gateway_name"></a> [public\_gateway\_name](#input\_public\_gateway\_name) | Name of the public gateway used for routing | `string` | `"gateway-public"` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Override for the Helm release name. Defaults to nullplatform-agent | `string` | `"nullplatform-agent"` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Override for the Kubernetes ServiceAccount name created by the Helm chart | `string` | `"nullplatform-agent"` | no |
| <a name="input_service_template"></a> [service\_template](#input\_service\_template) | Specifies the name or reference of the scope service template to be used for deployment. Required when extra\_envs.INGRESS\_TYPE is 'istio' — the k8s scope's default template is AWS ALB Ingress and won't route traffic correctly through Istio, so it must be pointed at an Istio-compatible template instead. | `string` | `""` | no |
| <a name="input_tags_selectors"></a> [tags\_selectors](#input\_tags\_selectors) | Map of tags used to select and filter channels and agents | `map(string)` | n/a | yes |
| <a name="input_use_account_slug"></a> [use\_account\_slug](#input\_use\_account\_slug) | Flag to determine whether to use the account slug in resource naming | `string` | `""` | no |
| <a name="input_worker"></a> [worker](#input\_worker) | Extra worker-orchestration config, merged on top of the module's own computed<br/>worker block: backend ("kubernetes" by default), allowedRegistries<br/>(["public.ecr.aws/nullplatform/*"] by default, so the platform's own scope<br/>images keep working), and a patch for the worker container (2Gi memory<br/>limit, the deploy/DNS env vars below, and a serviceAccountName that always<br/>mirrors service\_account\_name). allowedRegistries and patches set here are<br/>concatenated with (not replacing) the module defaults — add your own<br/>registries or an extra patch rather than having to repeat the defaults;<br/>set backend here to override it outright. Anything else — security, idleTTL<br/>(reap idle workers), the legacy defaults/rules/pins — passes through as-is.<br/>See the nullplatform-agent chart values (>= 2.37.0) for the full shape.<br/>null = nothing extra.<br/><br/>Example:<br/>  worker = {<br/>    allowedRegistries = ["123456789012.dkr.ecr.us-east-1.amazonaws.com/your-org/*"]<br/>    patches           = [{ target = { package = "my-pkg" }, merge = { spec = { serviceAccountName = "np-agent-sa" } } }]<br/>    idleTTL           = "30m"<br/>  } | `any` | `null` | no |
| <a name="input_worker_memory_limit"></a> [worker\_memory\_limit](#input\_worker\_memory\_limit) | Memory limit for a worker-orchestrated package's pod (packages in var.worker\_orchestrated\_packages). The chart's own default is small enough to OOM mid-tofu-apply for packages that run real IaC tooling. | `string` | `"2Gi"` | no |
| <a name="input_worker_orchestrated_packages"></a> [worker\_orchestrated\_packages](#input\_worker\_orchestrated\_packages) | Package slugs whose worker-orchestrator (package-exec) pods should run<br/>under var.service\_account\_name (the same IRSA identity as the agent<br/>itself) and var.worker\_memory\_limit, via a per-package worker-container<br/>patch. Add a package's slug here whenever its worker needs to assume an<br/>AWS role, or needs more memory than the chart's own default (e.g. to run<br/>tofu/terraform); a worker for a package not listed here falls back to the<br/>namespace's default ServiceAccount and the chart's own memory default.<br/><br/>This is separate from the "containers" scope's own k8s-deployment env<br/>vars (DNS\_TYPE, DOMAIN, etc.), which remain specific to that package<br/>regardless of what's listed here. | `list(string)` | <pre>[<br/>  "containers"<br/>]</pre> | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "agent",
  "description": "Deploys the nullplatform agent to a Kubernetes cluster via a Helm chart, configuring cloud-provider-specific identity, worker orchestration, and traffic manager settings",
  "architecture": "The module renders a YAML values file via templatefile() from locally computed locals, then provisions a single helm_release resource named 'agent' targeting the nullplatform-agent chart from the official Helm repository. A terraform_data resource tracks the api_key to force helm_release replacement when credentials rotate, while a second terraform_data resource enforces cross-variable preconditions (e.g. aws_iam_role_arn for AWS, azure_* vars for Azure) before the release is applied. Cloud-provider-specific environment variables, worker patches, and ServiceAccount bindings are merged into the chart values, with extra_envs taking final precedence over all computed defaults.",
  "features": [
    "Deploys nullplatform-agent helm_release with atomic rollback, cleanup-on-fail, and 10-release history cap",
    "Renders cloud-provider-specific Helm values for AWS (IAM role ARN injection), Azure (client credentials and resource group), GCP, and OCI",
    "Configures worker orchestrator patches to set ServiceAccount, memory limits, and environment variables per worker-orchestrated package",
    "Enforces pinned versioning for both the Helm chart and traffic manager image tag, rejecting empty or moving references like 'latest'",
    "Injects TRAFFIC_CONTAINER_IMAGE into worker env by combining agent_traffic_manager_repository and agent_traffic_manager_tag locals",
    "Supports namespace auto-creation via create_namespace and merges user-supplied extra_envs over all computed defaults",
    "Triggers full helm_release replacement via terraform_data when the api_key value changes"
  ],
  "inputs": [
    {
      "name": "api_key",
      "description": "API key for authenticating with the nullplatform API",
      "required": true
    },
    {
      "name": "image_tag",
      "description": "Image tag for the agent container image",
      "required": true
    },
    {
      "name": "tags_selectors",
      "description": "Map of tags used to select and filter channels and agents",
      "required": true
    },
    {
      "name": "cloud_provider",
      "description": "Cloud provider to use ('aws', 'gcp', 'azure', or 'oci')",
      "required": true
    },
    {
      "name": "nullplatform_agent_helm_version",
      "description": "No default: every install pins this deliberately — see VERSIONS.md. Version of the nullplatform agent Helm chart to deploy",
      "required": true
    },
    {
      "name": "agent_traffic_manager_tag",
      "description": "No default: every install pins this deliberately — see VERSIONS.md. Image tag for the traffic manager, published to the agent as TRAFFIC_CONTAINER_IMAGE. Pinning this used to mean passing the whole image string through extra_envs; the registry lives here so only the tag is exposed. extra_envs still takes precedence for anyone who needs a digest or a mirrored path.",
      "required": true
    },
    {
      "name": "agent_repo",
      "description": "",
      "required": false
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
      "name": "worker_orchestrated_packages",
      "description": "",
      "required": false
    },
    {
      "name": "worker_memory_limit",
      "description": "Memory limit for a worker-orchestrated package's pod (packages in var.worker_orchestrated_packages). The chart's own default is small enough to OOM mid-tofu-apply for packages that run real IaC tooling.",
      "required": false
    },
    {
      "name": "worker",
      "description": "",
      "required": false
    },
    {
      "name": "namespace",
      "description": "Kubernetes namespace where the nullplatform agent will run",
      "required": false
    },
    {
      "name": "create_namespace",
      "description": "Create the namespace if it does not exist. Leave true unless another module already owns it: nullplatform/base declares the same namespace with Helm ownership metadata, so with no ordering edge between the two whichever applies second fails.",
      "required": false
    },
    {
      "name": "agent_traffic_manager_repository",
      "description": "Container image repository for the traffic manager. Defaults to the official nullplatform image; override to pull from a mirror. Matches the pattern nullplatform/base uses for its own images.",
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
      "name": "use_account_slug",
      "description": "Flag to determine whether to use the account slug in resource naming",
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
      "name": "private_hosted_zone_rg",
      "description": "Resource group for private hosted zone",
      "required": false
    },
    {
      "name": "azure_tenant_id",
      "description": "Azure tenant ID",
      "required": false
    },
    {
      "name": "private_gateway_name",
      "description": "Name of the private/internal gateway used for routing",
      "required": false
    },
    {
      "name": "public_gateway_name",
      "description": "Name of the public gateway used for routing",
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
      "name": "image_pull_secrets",
      "description": "Image pull secrets configuration",
      "required": false
    },
    {
      "name": "service_template",
      "description": "Specifies the name or reference of the scope service template to be used for deployment. Required when extra_envs.INGRESS_TYPE is 'istio' — the k8s scope's default template is AWS ALB Ingress and won't route traffic correctly through Istio, so it must be pointed at an Istio-compatible template instead.",
      "required": false
    },
    {
      "name": "initial_ingress_path",
      "description": "Defines the initial ingress path used when deploying the application for the first time. Required when extra_envs.INGRESS_TYPE is 'istio' — the k8s scope's default template is AWS ALB Ingress and won't route traffic correctly through Istio, so it must be pointed at an Istio HTTPRoute template instead.",
      "required": false
    },
    {
      "name": "blue_green_ingress_path",
      "description": "Specifies the ingress path used for blue-green deployments to route traffic to the new version. Required when extra_envs.INGRESS_TYPE is 'istio' — the k8s scope's default template is AWS ALB Ingress and won't route traffic correctly through Istio, so it must be pointed at an Istio HTTPRoute template instead.",
      "required": false
    },
    {
      "name": "extra_envs",
      "description": "Additional environment variables to pass to the agent",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "e7aec7808bbc28e1deda09317c16cf52"
}
END_AI_METADATA -->
