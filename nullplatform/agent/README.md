# Module: agent

## Description

Deploys the nullplatform agent to a Kubernetes cluster via a Helm release, configured for AWS, GCP, Azure, or OCI cloud providers with pinned versions and cloud-specific credentials

## Architecture

The module renders a Helm values YAML using templatefile() from locals.tf, merging cloud-provider-specific config maps, ingress templates, and extra environment variables into a single all_config map. A helm_release resource deploys the nullplatform-agent chart to the target Kubernetes cluster using the rendered values, with an optional second values layer for worker configuration via yamlencode(). A terraform_data resource enforces cross-variable preconditions (cloud-provider-specific required vars, ingress template consistency) and a second terraform_data resource triggers helm_release replacement when the API key changes. Agent repository URLs are assembled in locals by concatenating the scope repo with its pinned tag and any extra repos, then joined into a comma-separated AGENT_REPOS string passed as a chart config value.

## Features

- Deploys nullplatform-agent Helm chart with atomic install, cleanup-on-fail, and rollback guarantees
- Configures cloud-provider-specific environment variables for AWS (IAM role ARN), Azure (client ID, secret, tenant, subscription, resource group), GCP, and OCI
- Assembles pinned agent repository list from a primary scopes repo plus additional repos, rejecting moving refs like main/master/latest at plan time
- Configures Istio HTTPRoute ingress templates (service, initial, blue-green) or defers to ALB scope-type defaults based on ingress_type
- Enforces version pinning for Helm chart version, agent image tag, traffic manager tag, and scopes repository tag via validation rules
- Supports worker orchestration configuration block passed verbatim as a second Helm values layer
- Injects traffic manager container image reference as TRAFFIC_CONTAINER_IMAGE, with extra_envs override support for digest or mirrored paths

## Basic Usage

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v6.23.1"

  agent_repos_scope_tag           = "your-agent-repos-scope-tag"
  agent_traffic_manager_tag       = "your-agent-traffic-manager-tag"
  api_key                         = "your-api-key"
  cloud_provider                  = "your-cloud-provider"
  cluster_name                    = "your-cluster-name"
  image_tag                       = "your-image-tag"
  nullplatform_agent_helm_version = "your-nullplatform-agent-helm-version"
  tags_selectors                  = "your-tags-selectors"
}
```

### Usage with AWS Cloud Provider

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v6.23.1"

  agent_repos_scope_tag           = "your-agent-repos-scope-tag"
  agent_traffic_manager_tag       = "your-agent-traffic-manager-tag"
  api_key                         = "your-api-key"
  aws_iam_role_arn                = "your-aws-iam-role-arn"  # Required when cloud_provider = "aws"
  cloud_provider                  = "aws"
  cluster_name                    = "your-cluster-name"
  image_tag                       = "your-image-tag"
  nullplatform_agent_helm_version = "your-nullplatform-agent-helm-version"
  tags_selectors                  = "your-tags-selectors"
}
```

### Usage with GCP Cloud Provider

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v6.23.1"

  agent_repos_scope_tag           = "your-agent-repos-scope-tag"
  agent_traffic_manager_tag       = "your-agent-traffic-manager-tag"
  api_key                         = "your-api-key"
  cloud_provider                  = "gcp"
  cluster_name                    = "your-cluster-name"
  image_tag                       = "your-image-tag"
  nullplatform_agent_helm_version = "your-nullplatform-agent-helm-version"
  tags_selectors                  = "your-tags-selectors"
}
```

### Usage with Azure Cloud Provider

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v6.23.1"

  agent_repos_scope_tag           = "your-agent-repos-scope-tag"
  agent_traffic_manager_tag       = "your-agent-traffic-manager-tag"
  api_key                         = "your-api-key"
  azure_client_id                 = "your-azure-client-id"  # Required when cloud_provider = "azure"
  azure_client_secret             = "your-azure-client-secret"  # Required when cloud_provider = "azure"
  azure_resource_group            = "your-azure-resource-group"  # Required when cloud_provider = "azure"
  azure_subscription_id           = "your-azure-subscription-id"  # Required when cloud_provider = "azure"
  azure_tenant_id                 = "your-azure-tenant-id"  # Required when cloud_provider = "azure"
  cloud_provider                  = "azure"
  cluster_name                    = "your-cluster-name"
  image_tag                       = "your-image-tag"
  nullplatform_agent_helm_version = "your-nullplatform-agent-helm-version"
  private_hosted_zone_rg          = "your-private-hosted-zone-rg"  # Required when cloud_provider = "azure"
  tags_selectors                  = "your-tags-selectors"
}
```

### Usage with OCI Cloud Provider

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v6.23.1"

  agent_repos_scope_tag           = "your-agent-repos-scope-tag"
  agent_traffic_manager_tag       = "your-agent-traffic-manager-tag"
  api_key                         = "your-api-key"
  cloud_provider                  = "oci"
  cluster_name                    = "your-cluster-name"
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
| <a name="input_agent_repos_extra"></a> [agent\_repos\_extra](#input\_agent\_repos\_extra) | List of additional Git repositories used for extended agent configuration. Each entry MUST carry a pinned ref fragment (repo.git#v1.2.3); moving refs are rejected. Covers scopes-* and services-* without enumerating them. | `list(string)` | `[]` | no |
| <a name="input_agent_repos_scope"></a> [agent\_repos\_scope](#input\_agent\_repos\_scope) | Git repository URL containing agent scope configurations, WITHOUT the ref fragment. The ref goes in agent\_repos\_scope\_tag. | `string` | `"https://github.com/nullplatform/scopes.git"` | no |
| <a name="input_agent_repos_scope_tag"></a> [agent\_repos\_scope\_tag](#input\_agent\_repos\_scope\_tag) | Git tag of the scopes repository to clone. No default: every install pins this deliberately so the agent cannot pick up scope changes it was never rolled out with — see VERSIONS.md. | `string` | n/a | yes |
| <a name="input_agent_traffic_manager_repository"></a> [agent\_traffic\_manager\_repository](#input\_agent\_traffic\_manager\_repository) | Container image repository for the traffic manager. Defaults to the official nullplatform image; override to pull from a mirror. Matches the pattern nullplatform/base uses for its own images. | `string` | `"public.ecr.aws/nullplatform/k8s-traffic-manager"` | no |
| <a name="input_agent_traffic_manager_tag"></a> [agent\_traffic\_manager\_tag](#input\_agent\_traffic\_manager\_tag) | No default: every install pins this deliberately — see VERSIONS.md. Image tag for the traffic manager, published to the agent as TRAFFIC\_CONTAINER\_IMAGE. Pinning this used to mean passing the whole image string through extra\_envs; the registry lives here so only the tag is exposed. extra\_envs still takes precedence for anyone who needs a digest or a mirrored path. | `string` | n/a | yes |
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | API key for authenticating with the nullplatform API | `string` | n/a | yes |
| <a name="input_aws_iam_role_arn"></a> [aws\_iam\_role\_arn](#input\_aws\_iam\_role\_arn) | ARN of the AWS IAM role assigned to the agent | `string` | `""` | no |
| <a name="input_azure_client_id"></a> [azure\_client\_id](#input\_azure\_client\_id) | Azure client ID for authentication | `string` | `null` | no |
| <a name="input_azure_client_secret"></a> [azure\_client\_secret](#input\_azure\_client\_secret) | Azure client secret for authentication | `string` | `null` | no |
| <a name="input_azure_resource_group"></a> [azure\_resource\_group](#input\_azure\_resource\_group) | Azure resource group name | `string` | `null` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | Azure subscription ID | `string` | `null` | no |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | Azure tenant ID | `string` | `null` | no |
| <a name="input_blue_green_ingress_path"></a> [blue\_green\_ingress\_path](#input\_blue\_green\_ingress\_path) | Ingress template path for the blue-green traffic switch. Empty (default) uses the scope type's own values.yaml. All three must be set together or all left empty, or the deploy changes template flavour mid-way; see ingress\_type for the Istio preset. | `string` | `""` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Cloud provider to use ('aws', 'gcp', 'azure', or 'oci') | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the Kubernetes cluster where the nullplatform agent will be deployed | `string` | n/a | yes |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create the namespace if it does not exist. Leave true unless another module already owns it: nullplatform/base declares the same namespace with Helm ownership metadata, so with no ordering edge between the two whichever applies second fails. | `bool` | `true` | no |
| <a name="input_dns_type"></a> [dns\_type](#input\_dns\_type) | Type of DNS Provider, ej: azure, route53, or external\_dns | `string` | `""` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Base domain name used across resources | `string` | `""` | no |
| <a name="input_extra_envs"></a> [extra\_envs](#input\_extra\_envs) | Additional environment variables to pass to the agent | `map(string)` | `{}` | no |
| <a name="input_image_pull_secrets"></a> [image\_pull\_secrets](#input\_image\_pull\_secrets) | Image pull secrets configuration | `string` | `""` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Container image repository for the agent. Defaults to the official nullplatform image. | `string` | `""` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Image tag for the agent container image | `string` | n/a | yes |
| <a name="input_ingress_type"></a> [ingress\_type](#input\_ingress\_type) | Ingress flavour of the cluster, for the `k8s` scope type only: 'alb' (default) or 'istio'. 'istio' fills service\_template, initial\_ingress\_path and blue\_green\_ingress\_path with the Istio HTTPRoute templates and renders INGRESS\_TYPE=istio; set it when running the `k8s` scope type without an AWS ALB controller (GKE, or AKS not on the dedicated `azure` scope type), whose ALB Ingress default yields a deploy with no working route and no error. 'alb' keeps today's behaviour: the three paths stay empty so the scope type's own values.yaml decides, and INGRESS\_TYPE is not rendered — services-endpoint-exposer ships only workflows/istio and would break on 'alb'. Explicit template paths always win over this variable. | `string` | `"alb"` | no |
| <a name="input_init_scripts"></a> [init\_scripts](#input\_init\_scripts) | List of initialization scripts to execute during agent startup | `list(string)` | `[]` | no |
| <a name="input_initial_ingress_path"></a> [initial\_ingress\_path](#input\_initial\_ingress\_path) | Ingress template path for the initial deploy. Empty (default) uses the scope type's own values.yaml. All three must be set together or all left empty, or the deploy changes template flavour mid-way; see ingress\_type for the Istio preset. | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace where the nullplatform agent will run | `string` | `"nullplatform-tools"` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | DEPRECATED, accepted for compatibility and ignored. Nullplatform Resource Name; the agent resolves its own scope from the API key, so this module never consumed the value | `string` | `""` | no |
| <a name="input_nullplatform_agent_helm_version"></a> [nullplatform\_agent\_helm\_version](#input\_nullplatform\_agent\_helm\_version) | No default: every install pins this deliberately — see VERSIONS.md. Version of the nullplatform agent Helm chart to deploy | `string` | n/a | yes |
| <a name="input_private_domain"></a> [private\_domain](#input\_private\_domain) | DEPRECATED, accepted for compatibility and ignored. Previously rendered as the PRIVATE\_DOMAIN env var for gcp and oci, which nothing in nullplatform/scopes reads | `string` | `""` | no |
| <a name="input_private_gateway_name"></a> [private\_gateway\_name](#input\_private\_gateway\_name) | Name of the private/internal gateway used for routing. Must match the Gateway the cluster actually has: nullplatform/base hardcodes 'gateway-private', and a mismatch produces HTTPRoutes with an unresolvable parentRef that die in verify\_networking\_reconciliation. | `string` | `"gateway-private"` | no |
| <a name="input_private_hosted_zone_rg"></a> [private\_hosted\_zone\_rg](#input\_private\_hosted\_zone\_rg) | Resource group for private hosted zone | `string` | `null` | no |
| <a name="input_public_gateway_name"></a> [public\_gateway\_name](#input\_public\_gateway\_name) | Name of the public gateway used for routing. Must match nullplatform/base's gateway\_public\_name, which is commonly overridden (e.g. 'internet-facing' on AKS); leaving this at the default when base was overridden breaks HTTPRoute routing and Azure DNS records. | `string` | `"gateway-public"` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Override for the Helm release name. Defaults to nullplatform-agent | `string` | `"nullplatform-agent"` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Override for the Kubernetes ServiceAccount name created by the Helm chart | `string` | `""` | no |
| <a name="input_service_template"></a> [service\_template](#input\_service\_template) | Scope service template path. Empty (default) uses the scope type's own values.yaml. All three must be set together or all left empty, or the deploy changes template flavour mid-way; see ingress\_type for the Istio preset. | `string` | `""` | no |
| <a name="input_tags_selectors"></a> [tags\_selectors](#input\_tags\_selectors) | Map of tags used to select and filter channels and agents | `map(string)` | n/a | yes |
| <a name="input_use_account_slug"></a> [use\_account\_slug](#input\_use\_account\_slug) | Flag to determine whether to use the account slug in resource naming | `string` | `""` | no |
| <a name="input_worker"></a> [worker](#input\_worker) | Worker-orchestration config, merged into the agent chart's `worker` block:<br/>backend, security, allowedRegistries (deny-by-default registry guardrail),<br/>patches (standard k8s patching of workers — the preferred way to shape them),<br/>idleTTL (reap idle workers), and the legacy defaults/rules/pins. See the<br/>nullplatform-agent chart values (>= 2.37.0) for the full shape. null = chart<br/>defaults.<br/><br/>Example:<br/>  worker = {<br/>    allowedRegistries = ["public.ecr.aws/your-org/*"]<br/>    patches           = [{ target = { package = "my-pkg" }, merge = { spec = { serviceAccountName = "np-agent-sa" } } }]<br/>    idleTTL           = "30m"<br/>  } | `any` | `null` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "agent",
  "description": "Deploys the nullplatform agent to a Kubernetes cluster via a Helm release, configured for AWS, GCP, Azure, or OCI cloud providers with pinned versions and cloud-specific credentials",
  "architecture": "The module renders a Helm values YAML using templatefile() from locals.tf, merging cloud-provider-specific config maps, ingress templates, and extra environment variables into a single all_config map. A helm_release resource deploys the nullplatform-agent chart to the target Kubernetes cluster using the rendered values, with an optional second values layer for worker configuration via yamlencode(). A terraform_data resource enforces cross-variable preconditions (cloud-provider-specific required vars, ingress template consistency) and a second terraform_data resource triggers helm_release replacement when the API key changes. Agent repository URLs are assembled in locals by concatenating the scope repo with its pinned tag and any extra repos, then joined into a comma-separated AGENT_REPOS string passed as a chart config value.",
  "features": [
    "Deploys nullplatform-agent Helm chart with atomic install, cleanup-on-fail, and rollback guarantees",
    "Configures cloud-provider-specific environment variables for AWS (IAM role ARN), Azure (client ID, secret, tenant, subscription, resource group), GCP, and OCI",
    "Assembles pinned agent repository list from a primary scopes repo plus additional repos, rejecting moving refs like main/master/latest at plan time",
    "Configures Istio HTTPRoute ingress templates (service, initial, blue-green) or defers to ALB scope-type defaults based on ingress_type",
    "Enforces version pinning for Helm chart version, agent image tag, traffic manager tag, and scopes repository tag via validation rules",
    "Supports worker orchestration configuration block passed verbatim as a second Helm values layer",
    "Injects traffic manager container image reference as TRAFFIC_CONTAINER_IMAGE, with extra_envs override support for digest or mirrored paths"
  ],
  "inputs": [
    {
      "name": "api_key",
      "description": "API key for authenticating with the nullplatform API",
      "required": true
    },
    {
      "name": "cluster_name",
      "description": "Name of the Kubernetes cluster where the nullplatform agent will be deployed",
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
      "name": "agent_repos_scope_tag",
      "description": "Git tag of the scopes repository to clone. No default: every install pins this deliberately so the agent cannot pick up scope changes it was never rolled out with — see VERSIONS.md.",
      "required": true
    },
    {
      "name": "agent_traffic_manager_tag",
      "description": "No default: every install pins this deliberately — see VERSIONS.md. Image tag for the traffic manager, published to the agent as TRAFFIC_CONTAINER_IMAGE. Pinning this used to mean passing the whole image string through extra_envs; the registry lives here so only the tag is exposed. extra_envs still takes precedence for anyone who needs a digest or a mirrored path.",
      "required": true
    },
    {
      "name": "agent_repos_scope",
      "description": "Git repository URL containing agent scope configurations, WITHOUT the ref fragment. The ref goes in agent_repos_scope_tag.",
      "required": false
    },
    {
      "name": "agent_repos_extra",
      "description": "List of additional Git repositories used for extended agent configuration. Each entry MUST carry a pinned ref fragment (repo.git#v1.2.3); moving refs are rejected. Covers scopes-* and services-* without enumerating them.",
      "required": false
    },
    {
      "name": "ingress_type",
      "description": "Ingress flavour of the cluster, for the `k8s` scope type only: 'alb' (default) or 'istio'. 'istio' fills service_template, initial_ingress_path and blue_green_ingress_path with the Istio HTTPRoute templates and renders INGRESS_TYPE=istio; set it when running the `k8s` scope type without an AWS ALB controller (GKE, or AKS not on the dedicated `azure` scope type), whose ALB Ingress default yields a deploy with no working route and no error. 'alb' keeps today's behaviour: the three paths stay empty so the scope type's own values.yaml decides, and INGRESS_TYPE is not rendered — services-endpoint-exposer ships only workflows/istio and would break on 'alb'. Explicit template paths always win over this variable.",
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
      "description": "Name of the private/internal gateway used for routing. Must match the Gateway the cluster actually has: nullplatform/base hardcodes 'gateway-private', and a mismatch produces HTTPRoutes with an unresolvable parentRef that die in verify_networking_reconciliation.",
      "required": false
    },
    {
      "name": "public_gateway_name",
      "description": "Name of the public gateway used for routing. Must match nullplatform/base's gateway_public_name, which is commonly overridden (e.g. 'internet-facing' on AKS); leaving this at the default when base was overridden breaks HTTPRoute routing and Azure DNS records.",
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
      "description": "Scope service template path. Empty (default) uses the scope type's own values.yaml. All three must be set together or all left empty, or the deploy changes template flavour mid-way; see ingress_type for the Istio preset.",
      "required": false
    },
    {
      "name": "initial_ingress_path",
      "description": "Ingress template path for the initial deploy. Empty (default) uses the scope type's own values.yaml. All three must be set together or all left empty, or the deploy changes template flavour mid-way; see ingress_type for the Istio preset.",
      "required": false
    },
    {
      "name": "blue_green_ingress_path",
      "description": "Ingress template path for the blue-green traffic switch. Empty (default) uses the scope type's own values.yaml. All three must be set together or all left empty, or the deploy changes template flavour mid-way; see ingress_type for the Istio preset.",
      "required": false
    },
    {
      "name": "extra_envs",
      "description": "Additional environment variables to pass to the agent",
      "required": false
    },
    {
      "name": "nrn",
      "description": "DEPRECATED, accepted for compatibility and ignored. Nullplatform Resource Name; the agent resolves its own scope from the API key, so this module never consumed the value",
      "required": false
    },
    {
      "name": "private_domain",
      "description": "DEPRECATED, accepted for compatibility and ignored. Previously rendered as the PRIVATE_DOMAIN env var for gcp and oci, which nothing in nullplatform/scopes reads",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "f0a903b72d1f9e20c6fa429fe34bd9b4"
}
END_AI_METADATA -->
