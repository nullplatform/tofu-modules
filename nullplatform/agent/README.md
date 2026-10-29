# Module: agent

## Description

Deploys the nullplatform agent as a Helm release on a Kubernetes cluster with cloud-provider-specific configuration, worker orchestration, and ingress stack selection

## Architecture

The module creates a `helm_release` resource pointing at the nullplatform-agent chart, with values rendered from a `templatefile` call that merges environment variables, worker patches, and ingress paths into a single YAML values document. A `terraform_data.api_key_trigger` resource forces a Helm release replacement whenever the API key changes, and a `terraform_data.cross_variable_validation` resource enforces cross-variable preconditions (e.g. AWS requires `aws_iam_role_arn`, Azure requires subscription/resource group/tenant). Cloud-provider-specific env vars (AWS IAM role ARN, Azure client credentials, etc.) flow through `locals.all_config` into the agent container's environment, while worker orchestration patches are built from `locals.worker_common_patches`, `locals.worker_k8s_env_patches`, and `locals.worker_resources_patches` and merged into the chart's worker block.

## Features

- Deploys nullplatform-agent via helm_release with atomic upgrades, rollback on failure, and capped release history
- Configures cloud-provider-specific environment variables for AWS (IAM role ARN), Azure (client credentials, workload identity, subscription/resource group/tenant), GCP, OCI, and on-premise clusters
- Builds per-package worker orchestration patches for serviceAccountName, Azure workload identity labels, resource limits, and k8s-scope environment variables
- Selects ingress stack templates (ALB or Istio Gateway API HTTPRoutes) and resolves SERVICE_TEMPLATE, INITIAL_INGRESS_PATH, and BLUE_GREEN_INGRESS_PATH paths based on execution context
- Enforces pinned versions for the Helm chart and traffic manager image tag, rejecting empty or moving references like 'latest'
- Supports graceful shutdown tuning via termination_grace_period_seconds and shutdown_drain_timeout_seconds with cross-variable validation
- Manages agent and worker pod disruption protection through PodDisruptionBudget, pod annotations, tolerations, node selectors, affinity, replica count, and probe overrides

## Basic Usage

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v9.7.0"

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
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v9.7.0"

  agent_traffic_manager_tag       = "your-agent-traffic-manager-tag"
  api_key                         = "your-api-key"
  aws_iam_role_arn                = "your-aws-iam-role-arn"  # Required when cloud_provider = "aws"
  cloud_provider                  = "aws"
  cluster_name                    = "your-cluster-name"  # Required when cloud_provider = "aws"
  image_tag                       = "your-image-tag"
  nullplatform_agent_helm_version = "your-nullplatform-agent-helm-version"
  tags_selectors                  = "your-tags-selectors"
}
```

### Usage with GCP Cloud Provider

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v9.7.0"

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
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v9.7.0"

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
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v9.7.0"

  agent_traffic_manager_tag       = "your-agent-traffic-manager-tag"
  api_key                         = "your-api-key"
  cloud_provider                  = "oci"
  image_tag                       = "your-image-tag"
  nullplatform_agent_helm_version = "your-nullplatform-agent-helm-version"
  tags_selectors                  = "your-tags-selectors"
}
```

### Usage with On-Premise Cloud Provider

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v9.7.0"

  agent_traffic_manager_tag       = "your-agent-traffic-manager-tag"
  api_key                         = "your-api-key"
  cloud_provider                  = "onprem"
  image_tag                       = "your-image-tag"
  nullplatform_agent_helm_version = "your-nullplatform-agent-helm-version"
  tags_selectors                  = "your-tags-selectors"
}
```

### Usage with Pinned Helm Chart Version

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v9.7.0"

  agent_traffic_manager_tag       = "your-agent-traffic-manager-tag"
  api_key                         = "your-api-key"
  cloud_provider                  = "your-cloud-provider"
  image_tag                       = "your-image-tag"
  nullplatform_agent_helm_version = "nullplatform_agent_helm_version"
  tags_selectors                  = "your-tags-selectors"
}
```

### Usage with Pinned Traffic Manager Tag

```hcl
module "agent" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v9.7.0"

  agent_traffic_manager_tag       = "agent_traffic_manager_tag"
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
| <a name="input_affinity"></a> [affinity](#input\_affinity) | Affinity for the agent pod, rendered as-is under the chart's affinity, e.g. a podAntiAffinity on kubernetes.io/hostname to run one agent per node. A required anti-affinity leaves a replica Pending when no node is free for it. Null (the default) renders nothing. | `any` | `null` | no |
| <a name="input_agent_repo"></a> [agent\_repo](#input\_agent\_repo) | Git repositories (each with a ref) the agent clones for its legacy<br/>command-executor exec flow. Joined into a comma-separated AGENT\_REPO<br/>value, no spaces. Empty when every scope uses worker\_orchestrator instead.<br/><br/>Example:<br/>  agent\_repo = [<br/>    "https://github.com/nullplatform/scopes.git#v1.15.1",<br/>    "https://github.com/nullplatform/services-s-3.git#v0.3.0",<br/>  ] | `list(string)` | `[]` | no |
| <a name="input_agent_traffic_manager_repository"></a> [agent\_traffic\_manager\_repository](#input\_agent\_traffic\_manager\_repository) | Container image repository for the traffic manager. Defaults to the official nullplatform image; override to pull from a mirror. Matches the pattern nullplatform/base uses for its own images. | `string` | `"public.ecr.aws/nullplatform/k8s-traffic-manager"` | no |
| <a name="input_agent_traffic_manager_tag"></a> [agent\_traffic\_manager\_tag](#input\_agent\_traffic\_manager\_tag) | No default: every install pins this deliberately — see VERSIONS.md. Image tag for the traffic manager, published to the agent as TRAFFIC\_CONTAINER\_IMAGE. Pinning this used to mean passing the whole image string through extra\_envs; the registry lives here so only the tag is exposed. extra\_envs still takes precedence for anyone who needs a digest or a mirrored path. | `string` | n/a | yes |
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | API key for authenticating with the nullplatform API | `string` | n/a | yes |
| <a name="input_aws_iam_role_arn"></a> [aws\_iam\_role\_arn](#input\_aws\_iam\_role\_arn) | ARN of the AWS IAM role assigned to the agent. Required when cloud\_provider is 'aws'. | `string` | `""` | no |
| <a name="input_azure_client_id"></a> [azure\_client\_id](#input\_azure\_client\_id) | Azure client ID of the Service Principal the agent authenticates with. Required when cloud\_provider is 'azure', unless azure\_workload\_identity is true. With azure\_workload\_identity it can be set without a secret: it then annotates the ServiceAccount (the agent-wide default identity for SDK tools). | `string` | `null` | no |
| <a name="input_azure_client_secret"></a> [azure\_client\_secret](#input\_azure\_client\_secret) | Azure client secret of the Service Principal the agent authenticates with. Required when cloud\_provider is 'azure', unless azure\_workload\_identity is true. | `string` | `null` | no |
| <a name="input_azure_resource_group"></a> [azure\_resource\_group](#input\_azure\_resource\_group) | Azure resource group name. Required when cloud\_provider is 'azure'. | `string` | `null` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | Azure subscription ID. Required when cloud\_provider is 'azure'. | `string` | `null` | no |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | Azure tenant ID. Required when cloud\_provider is 'azure'. | `string` | `null` | no |
| <a name="input_azure_workload_identity"></a> [azure\_workload\_identity](#input\_azure\_workload\_identity) | Run the agent and its worker-orchestrated pods with AKS Workload Identity:<br/>they get the label azure.workload.identity/use = "true", so the workload<br/>identity webhook projects the ServiceAccount token (AZURE\_FEDERATED\_TOKEN\_FILE).<br/>The k8s scope then authenticates to Azure as the managed identity it resolves<br/>per scope dimension from the Identity & Access provider, and<br/>azure\_client\_id / azure\_client\_secret become optional. Only applies when<br/>cloud\_provider is 'azure'.<br/><br/>The managed identities the scope uses need a federated credential for<br/>subject system:serviceaccount:<namespace>:<service\_account\_name> (defaults:<br/>nullplatform-tools:nullplatform-agent) against the cluster's OIDC issuer. | `bool` | `false` | no |
| <a name="input_blue_green_ingress_path"></a> [blue\_green\_ingress\_path](#input\_blue\_green\_ingress\_path) | Path, inside the worker image, of the ingress/route template used to shift traffic during a blue-green deployment. Empty (default) uses the template ingress\_stack selects; set it only to point at a custom template. | `string` | `""` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Cloud provider to use ('aws', 'gcp', 'azure', 'oci', or 'onprem' for self-managed/on-premise clusters) | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the Kubernetes cluster the scopes run in. Sent to the k8s workers as CLUSTER\_NAME; the k8s scope uses it to find the EKS OIDC provider when creating IAM roles. Required when cloud\_provider is 'aws'. | `string` | `""` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create the namespace if it does not exist. Leave true unless another module already owns it: nullplatform/base declares the same namespace with Helm ownership metadata, so with no ordering edge between the two whichever applies second fails. | `bool` | `true` | no |
| <a name="input_dns_type"></a> [dns\_type](#input\_dns\_type) | Type of DNS Provider, e.g. azure, route53, or external\_dns | `string` | `""` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Base domain name used across resources | `string` | `""` | no |
| <a name="input_extra_envs"></a> [extra\_envs](#input\_extra\_envs) | Additional environment variables to pass to the agent | `map(string)` | `{}` | no |
| <a name="input_image_pull_secret_name"></a> [image\_pull\_secret\_name](#input\_image\_pull\_secret\_name) | Name of an existing pull secret, in the agent's own namespace, for pulling<br/>the agent image itself.<br/><br/>Needed when that image comes from a private registry, which is the case for<br/>an install that mirrors it instead of pulling from the public repository.<br/>Empty leaves the chart's default and the pull stays anonymous, which is all<br/>a public image needs.<br/><br/>The secret is not created here: it belongs to whoever owns the registry<br/>credentials. Its name is what the agent's namespace must already hold.<br/><br/>Not the pull secrets the scopes attach to the application pods they deploy<br/>— those are image\_pull\_secrets, and they take a JSON document, not a name. | `string` | `""` | no |
| <a name="input_image_pull_secrets"></a> [image\_pull\_secrets](#input\_image\_pull\_secrets) | Pull secrets for the application pods the scopes deploy, published to the<br/>workers as IMAGE\_PULL\_SECRETS. Not the agent's own image — that one is<br/>image\_pull\_secret\_name.<br/><br/>A JSON document, not a secret name: {"ENABLED": bool, "SECRETS": [names]}.<br/>The workers hand the value straight to jq, and a bare name is not valid<br/>JSON, so it leaves them with no pull secrets at all instead of an error.<br/><br/>Left empty, the workers derive it from the scope-configurations provider<br/>rather than from here. | `string` | `""` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Container image repository for the agent. Defaults to the official nullplatform image. | `string` | `""` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Image tag for the agent container image | `string` | n/a | yes |
| <a name="input_ingress_stack"></a> [ingress\_stack](#input\_ingress\_stack) | Ingress stack scopes deploy with, in the worker pod or the agent container: "alb" keeps the k8s scope's own templates (AWS Load Balancer Controller Ingress), "istio" points it at the Gateway API templates baked in the scopes/containers image. service\_template, initial\_ingress\_path and blue\_green\_ingress\_path override the derived paths when set. | `string` | `"istio"` | no |
| <a name="input_init_scripts"></a> [init\_scripts](#input\_init\_scripts) | List of initialization scripts to execute during agent startup | `list(string)` | `[]` | no |
| <a name="input_initial_ingress_path"></a> [initial\_ingress\_path](#input\_initial\_ingress\_path) | Path, inside the worker image, of the ingress/route template used on a scope's first deployment. Empty (default) uses the template ingress\_stack selects; set it only to point at a custom template. | `string` | `""` | no |
| <a name="input_liveness_probe"></a> [liveness\_probe](#input\_liveness\_probe) | Fields merged over the chart's livenessProbe (httpGet /health on 8080), e.g. { initialDelaySeconds = 120 }. Null (the default) renders nothing and leaves the chart's probe untouched. | `any` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace where the nullplatform agent itself runs. This is NOT where scopes deploy their workloads — see var.workload\_namespace. | `string` | `"nullplatform-tools"` | no |
| <a name="input_node_selector"></a> [node\_selector](#input\_node\_selector) | nodeSelector for the agent pod, e.g. to pin it to a node pool that is not consolidated. Empty (the default) renders nothing. | `map(string)` | `{}` | no |
| <a name="input_nullplatform_agent_helm_version"></a> [nullplatform\_agent\_helm\_version](#input\_nullplatform\_agent\_helm\_version) | No default: every install pins this deliberately — see VERSIONS.md. Version of the nullplatform agent Helm chart to deploy | `string` | n/a | yes |
| <a name="input_pod_annotations"></a> [pod\_annotations](#input\_pod\_annotations) | Annotations merged over the chart's podAnnotations. From chart 3.2.0 the chart sets karpenter.sh/do-not-disrupt = "true" and cluster-autoscaler.kubernetes.io/safe-to-evict = "false" so node autoscalers don't evict the agent mid-action; set a key to null to drop one of them (e.g. an admission policy that rejects it). Empty (the default) renders nothing. | `map(string)` | `{}` | no |
| <a name="input_pod_disruption_budget"></a> [pod\_disruption\_budget](#input\_pod\_disruption\_budget) | PodDisruptionBudget for the agent (chart >= 3.2.0), rendered as the chart's<br/>podDisruptionBudget values. Null (the default) renders nothing and the chart<br/>keeps it disabled. With a single replica only a budget that still allows an<br/>eviction is accepted: the chart refuses maxUnavailable = 0 and a minAvailable<br/>that is not below the replica count, since they would hang node drains and<br/>cluster upgrades.<br/><br/>Example:<br/>  pod\_disruption\_budget = { enabled = true, maxUnavailable = 1 } | `any` | `null` | no |
| <a name="input_private_gateway_name"></a> [private\_gateway\_name](#input\_private\_gateway\_name) | Name of the private/internal gateway used for routing | `string` | `"gateway-private"` | no |
| <a name="input_private_hosted_zone_rg"></a> [private\_hosted\_zone\_rg](#input\_private\_hosted\_zone\_rg) | Resource group for private hosted zone. Required when cloud\_provider is 'azure'. | `string` | `null` | no |
| <a name="input_public_gateway_name"></a> [public\_gateway\_name](#input\_public\_gateway\_name) | Name of the public gateway used for routing | `string` | `"gateway-public"` | no |
| <a name="input_readiness_probe"></a> [readiness\_probe](#input\_readiness\_probe) | Fields merged over the chart's readinessProbe (httpGet /health on 8080), e.g. { initialDelaySeconds = 60 }. Null (the default) renders nothing and leaves the chart's probe untouched. | `any` | `null` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Number of agent replicas, rendered as the chart's replicaCount, which the chart ignores when its autoscaling is enabled. Null (the default) renders nothing and the chart keeps its own replica count. | `number` | `null` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Override for the Helm release name. Defaults to nullplatform-agent | `string` | `"nullplatform-agent"` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Fields merged over the chart's resources for the agent container, e.g. { requests = { cpu = "500m" } }; Helm merges them key by key, so unset fields keep the chart's values. Null (the default), or empty requests and limits, renders nothing and leaves the chart's resources untouched. | <pre>object({<br/>    requests = optional(map(string), {})<br/>    limits   = optional(map(string), {})<br/>  })</pre> | `null` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Override for the Kubernetes ServiceAccount name created by the Helm chart | `string` | `"nullplatform-agent"` | no |
| <a name="input_service_template"></a> [service\_template](#input\_service\_template) | Path, inside the worker image, of the Service template the k8s scope renders. Empty (default) uses the template ingress\_stack selects; set it only to point at a custom template. | `string` | `""` | no |
| <a name="input_shutdown_drain_timeout_seconds"></a> [shutdown\_drain\_timeout\_seconds](#input\_shutdown\_drain\_timeout\_seconds) | Seconds the agent waits on SIGTERM for running commands to finish before it disconnects (chart >= 3.3.0, which defaults to 90, rendered as NP\_SHUTDOWN\_DRAIN\_TIMEOUT). Commands still running after that are re-delivered to the next agent, so size it to the longest action (a start-blue-green takes ~70s). 0 disables the wait. Must stay at least 10s below termination\_grace\_period\_seconds. Null (the default) renders nothing; extra\_envs.NP\_SHUTDOWN\_DRAIN\_TIMEOUT still takes precedence. | `number` | `null` | no |
| <a name="input_startup_probe"></a> [startup\_probe](#input\_startup\_probe) | Fields merged over the chart's startupProbe (chart >= 3.2.0: httpGet /health on 8080, every 10s, up to 30 failures), e.g. { failureThreshold = 60 } for a slow repo clone. Null (the default) renders nothing and leaves the chart's probe untouched. | `any` | `null` | no |
| <a name="input_tags_selectors"></a> [tags\_selectors](#input\_tags\_selectors) | Map of tags used to select and filter channels and agents | `map(string)` | n/a | yes |
| <a name="input_termination_grace_period_seconds"></a> [termination\_grace\_period\_seconds](#input\_termination\_grace\_period\_seconds) | Seconds the agent gets to stop after SIGTERM (chart >= 3.2.0, which defaults to 60, and 120 from 3.3.0). It has to fit shutdown\_drain\_timeout\_seconds plus 10s for the disconnect. Null (the default) renders nothing. | `number` | `null` | no |
| <a name="input_tolerations"></a> [tolerations](#input\_tolerations) | Tolerations for the agent pod. Helm replaces lists instead of merging them, so this replaces the chart's defaults (node.kubernetes.io/not-ready and node.kubernetes.io/unreachable, NoExecute for 300s): include them if you still want them. Null (the default) renders nothing and keeps the chart's tolerations. | `any` | `null` | no |
| <a name="input_use_account_slug"></a> [use\_account\_slug](#input\_use\_account\_slug) | Flag to determine whether to use the account slug in resource naming | `string` | `""` | no |
| <a name="input_worker"></a> [worker](#input\_worker) | Extra worker-orchestration config, merged on top of the module's own computed<br/>worker block: backend ("kubernetes" by default), allowedRegistries<br/>(["public.ecr.aws/nullplatform/*"] by default, so the platform's own scope<br/>images keep working), idleTTL ("30m" by default, so worker Deployments<br/>left behind by an old/removed package revision get reaped instead of<br/>accumulating forever), and patches for the worker container<br/>(worker\_resources for every worker, the deploy/DNS env vars below, and a<br/>serviceAccountName that always mirrors service\_account\_name). allowedRegistries and patches set here are<br/>concatenated with (not replacing) the module defaults — add your own<br/>registries or an extra patch rather than having to repeat the defaults;<br/>set backend or idleTTL here to override them outright (e.g. idleTTL = ""<br/>to disable the reaper, matching this module's pre-idleTTL-default<br/>behavior). Anything else — security, the legacy defaults/rules/pins —<br/>passes through as-is. See the nullplatform-agent chart values (>= 2.37.0)<br/>for the full shape. null = nothing extra beyond the defaults above.<br/><br/>Example:<br/>  worker = {<br/>    allowedRegistries = ["123456789012.dkr.ecr.us-east-1.amazonaws.com/your-org/*"]<br/>    patches           = [{ target = { package = "my-pkg" }, merge = { spec = { serviceAccountName = "np-agent-sa" } } }]<br/>    idleTTL           = "1h"<br/>  } | `any` | `null` | no |
| <a name="input_worker_k8s_packages"></a> [worker\_k8s\_packages](#input\_worker\_k8s\_packages) | Package slugs whose worker runs the k8s scope and must receive its env vars (DNS\_TYPE, K8S\_NAMESPACE, template paths, CLUSTER\_NAME, extra\_envs). Add every package that runs the k8s scope code, e.g. ["containers", "scheduled-task"]. | `list(string)` | <pre>[<br/>  "containers"<br/>]</pre> | no |
| <a name="input_worker_memory_limit"></a> [worker\_memory\_limit](#input\_worker\_memory\_limit) | Deprecated: use worker\_resources.limits.memory; the chart now sets the workers' memory limit (2Gi from chart 3.4.0). When set, overrides the memory limit of every worker (it used to apply only to packages in worker\_orchestrated\_packages). Null (the default) renders nothing. | `string` | `null` | no |
| <a name="input_worker_orchestrated_packages"></a> [worker\_orchestrated\_packages](#input\_worker\_orchestrated\_packages) | Package slugs whose worker-orchestrator (package-exec) pods should run<br/>under var.service\_account\_name (the same IRSA identity as the agent<br/>itself), via a per-package worker patch. Add a package's slug here<br/>whenever its worker needs to assume an AWS role or needs Azure workload<br/>identity (the azure.workload.identity/use label is added through the same<br/>per-package patch); a worker for a package not listed here falls back to<br/>the namespace's default ServiceAccount. Resources are the same for every<br/>worker either way (var.worker\_resources).<br/><br/>This is separate from the "containers" scope's own k8s-deployment env<br/>vars (DNS\_TYPE, DOMAIN, etc.), which remain specific to that package<br/>regardless of what's listed here. | `list(string)` | <pre>[<br/>  "containers"<br/>]</pre> | no |
| <a name="input_worker_orchestrator"></a> [worker\_orchestrator](#input\_worker\_orchestrator) | Configure worker orchestration: emit the chart's top-level "worker" block<br/>(backend, allowedRegistries, idleTTL and the per-package patches built from<br/>worker\_orchestrated\_packages and worker\_k8s\_packages) plus anything set in<br/>var.worker.<br/><br/>Off by default: the module writes no "worker" key and builds no patches, so<br/>the chart's own defaults apply and scopes keep running inside the agent<br/>container (the legacy exec flow, see var.agent\_repo). Turn it on to run<br/>packages in their own worker pods; var.worker, the package lists and<br/>worker\_memory\_limit are ignored while it is off.<br/><br/>The agent's own env is the same either way: DOMAIN, DNS\_TYPE, K8S\_NAMESPACE<br/>and the rest are always published to the agent container. | `bool` | `false` | no |
| <a name="input_worker_pod_annotations"></a> [worker\_pod\_annotations](#input\_worker\_pod\_annotations) | Annotations added to every worker pod (worker\_orchestrator only) through a patch with an empty target. The defaults keep node autoscalers from evicting a worker mid-action: karpenter.sh/do-not-disrupt for Karpenter (EKS Auto Mode, AKS node auto-provisioning) and cluster-autoscaler.kubernetes.io/safe-to-evict for Cluster Autoscaler; a cluster without them ignores both. An idle worker then holds its node until the idle reaper (idleTTL, 30m by default) removes it. Empty renders no patch. | `map(string)` | <pre>{<br/>  "cluster-autoscaler.kubernetes.io/safe-to-evict": "false",<br/>  "karpenter.sh/do-not-disrupt": "true"<br/>}</pre> | no |
| <a name="input_worker_resources"></a> [worker\_resources](#input\_worker\_resources) | Fields merged over the chart's worker resources (worker.defaults.resources) for every worker pod, whatever its package (worker\_orchestrator only), rendered as a patch with an empty target, e.g. { limits = { memory = "4Gi" } }; unset fields keep the chart's values. To resize a single package, add a patch with target = { package = "<slug>" } in var.worker.patches instead. Null (the default), or empty requests and limits, renders no patch. | <pre>object({<br/>    requests = optional(map(string), {})<br/>    limits   = optional(map(string), {})<br/>  })</pre> | `null` | no |
| <a name="input_workload_namespace"></a> [workload\_namespace](#input\_workload\_namespace) | Kubernetes namespace scopes deploy their application pods into, handed to the k8s-scope workers as K8S\_NAMESPACE. Defaults to the k8s scope's own default, which is what every pre-worker agent used. | `string` | `"nullplatform"` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "agent",
  "description": "Deploys the nullplatform agent as a Helm release on a Kubernetes cluster with cloud-provider-specific configuration, worker orchestration, and ingress stack selection",
  "architecture": "The module creates a `helm_release` resource pointing at the nullplatform-agent chart, with values rendered from a `templatefile` call that merges environment variables, worker patches, and ingress paths into a single YAML values document. A `terraform_data.api_key_trigger` resource forces a Helm release replacement whenever the API key changes, and a `terraform_data.cross_variable_validation` resource enforces cross-variable preconditions (e.g. AWS requires `aws_iam_role_arn`, Azure requires subscription/resource group/tenant). Cloud-provider-specific env vars (AWS IAM role ARN, Azure client credentials, etc.) flow through `locals.all_config` into the agent container's environment, while worker orchestration patches are built from `locals.worker_common_patches`, `locals.worker_k8s_env_patches`, and `locals.worker_resources_patches` and merged into the chart's worker block.",
  "features": [
    "Deploys nullplatform-agent via helm_release with atomic upgrades, rollback on failure, and capped release history",
    "Configures cloud-provider-specific environment variables for AWS (IAM role ARN), Azure (client credentials, workload identity, subscription/resource group/tenant), GCP, OCI, and on-premise clusters",
    "Builds per-package worker orchestration patches for serviceAccountName, Azure workload identity labels, resource limits, and k8s-scope environment variables",
    "Selects ingress stack templates (ALB or Istio Gateway API HTTPRoutes) and resolves SERVICE_TEMPLATE, INITIAL_INGRESS_PATH, and BLUE_GREEN_INGRESS_PATH paths based on execution context",
    "Enforces pinned versions for the Helm chart and traffic manager image tag, rejecting empty or moving references like 'latest'",
    "Supports graceful shutdown tuning via termination_grace_period_seconds and shutdown_drain_timeout_seconds with cross-variable validation",
    "Manages agent and worker pod disruption protection through PodDisruptionBudget, pod annotations, tolerations, node selectors, affinity, replica count, and probe overrides"
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
      "description": "Cloud provider to use ('aws', 'gcp', 'azure', 'oci', or 'onprem' for self-managed/on-premise clusters)",
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
      "name": "termination_grace_period_seconds",
      "description": "Seconds the agent gets to stop after SIGTERM (chart >= 3.2.0, which defaults to 60, and 120 from 3.3.0). It has to fit shutdown_drain_timeout_seconds plus 10s for the disconnect. Null (the default) renders nothing.",
      "required": false
    },
    {
      "name": "shutdown_drain_timeout_seconds",
      "description": "Seconds the agent waits on SIGTERM for running commands to finish before it disconnects (chart >= 3.3.0, which defaults to 90, rendered as NP_SHUTDOWN_DRAIN_TIMEOUT). Commands still running after that are re-delivered to the next agent, so size it to the longest action (a start-blue-green takes ~70s). 0 disables the wait. Must stay at least 10s below termination_grace_period_seconds. Null (the default) renders nothing; extra_envs.NP_SHUTDOWN_DRAIN_TIMEOUT still takes precedence.",
      "required": false
    },
    {
      "name": "tolerations",
      "description": "Tolerations for the agent pod. Helm replaces lists instead of merging them, so this replaces the chart's defaults (node.kubernetes.io/not-ready and node.kubernetes.io/unreachable, NoExecute for 300s): include them if you still want them. Null (the default) renders nothing and keeps the chart's tolerations.",
      "required": false
    },
    {
      "name": "ingress_stack",
      "description": "Ingress stack scopes deploy with, in the worker pod or the agent container: \\",
      "required": false
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
      "name": "worker_orchestrator",
      "description": "",
      "required": false
    },
    {
      "name": "worker_orchestrated_packages",
      "description": "",
      "required": false
    },
    {
      "name": "worker_k8s_packages",
      "description": "Package slugs whose worker runs the k8s scope and must receive its env vars (DNS_TYPE, K8S_NAMESPACE, template paths, CLUSTER_NAME, extra_envs). Add every package that runs the k8s scope code, e.g. [\\",
      "required": false
    },
    {
      "name": "cluster_name",
      "description": "Name of the Kubernetes cluster the scopes run in. Sent to the k8s workers as CLUSTER_NAME; the k8s scope uses it to find the EKS OIDC provider when creating IAM roles. Required when cloud_provider is 'aws'.",
      "required": false
    },
    {
      "name": "worker_memory_limit",
      "description": "Deprecated: use worker_resources.limits.memory; the chart now sets the workers' memory limit (2Gi from chart 3.4.0). When set, overrides the memory limit of every worker (it used to apply only to packages in worker_orchestrated_packages). Null (the default) renders nothing.",
      "required": false
    },
    {
      "name": "worker",
      "description": "",
      "required": false
    },
    {
      "name": "namespace",
      "description": "Kubernetes namespace where the nullplatform agent itself runs. This is NOT where scopes deploy their workloads — see var.workload_namespace.",
      "required": false
    },
    {
      "name": "workload_namespace",
      "description": "Kubernetes namespace scopes deploy their application pods into, handed to the k8s-scope workers as K8S_NAMESPACE. Defaults to the k8s scope's own default, which is what every pre-worker agent used.",
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
      "name": "liveness_probe",
      "description": "Fields merged over the chart's livenessProbe (httpGet /health on 8080), e.g. { initialDelaySeconds = 120 }. Null (the default) renders nothing and leaves the chart's probe untouched.",
      "required": false
    },
    {
      "name": "readiness_probe",
      "description": "Fields merged over the chart's readinessProbe (httpGet /health on 8080), e.g. { initialDelaySeconds = 60 }. Null (the default) renders nothing and leaves the chart's probe untouched.",
      "required": false
    },
    {
      "name": "startup_probe",
      "description": "Fields merged over the chart's startupProbe (chart >= 3.2.0: httpGet /health on 8080, every 10s, up to 30 failures), e.g. { failureThreshold = 60 } for a slow repo clone. Null (the default) renders nothing and leaves the chart's probe untouched.",
      "required": false
    },
    {
      "name": "pod_annotations",
      "description": "Annotations merged over the chart's podAnnotations. From chart 3.2.0 the chart sets karpenter.sh/do-not-disrupt = \\",
      "required": false
    },
    {
      "name": "pod_disruption_budget",
      "description": "",
      "required": false
    },
    {
      "name": "worker_pod_annotations",
      "description": "Annotations added to every worker pod (worker_orchestrator only) through a patch with an empty target. The defaults keep node autoscalers from evicting a worker mid-action: karpenter.sh/do-not-disrupt for Karpenter (EKS Auto Mode, AKS node auto-provisioning) and cluster-autoscaler.kubernetes.io/safe-to-evict for Cluster Autoscaler; a cluster without them ignores both. An idle worker then holds its node until the idle reaper (idleTTL, 30m by default) removes it. Empty renders no patch.",
      "required": false
    },
    {
      "name": "resources",
      "description": "Fields merged over the chart's resources for the agent container, e.g. { requests = { cpu = \\",
      "required": false
    },
    {
      "name": "worker_resources",
      "description": "Fields merged over the chart's worker resources (worker.defaults.resources) for every worker pod, whatever its package (worker_orchestrator only), rendered as a patch with an empty target, e.g. { limits = { memory = \\",
      "required": false
    },
    {
      "name": "node_selector",
      "description": "nodeSelector for the agent pod, e.g. to pin it to a node pool that is not consolidated. Empty (the default) renders nothing.",
      "required": false
    },
    {
      "name": "replicas",
      "description": "Number of agent replicas, rendered as the chart's replicaCount, which the chart ignores when its autoscaling is enabled. Null (the default) renders nothing and the chart keeps its own replica count.",
      "required": false
    },
    {
      "name": "affinity",
      "description": "Affinity for the agent pod, rendered as-is under the chart's affinity, e.g. a podAntiAffinity on kubernetes.io/hostname to run one agent per node. A required anti-affinity leaves a replica Pending when no node is free for it. Null (the default) renders nothing.",
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
      "description": "ARN of the AWS IAM role assigned to the agent. Required when cloud_provider is 'aws'.",
      "required": false
    },
    {
      "name": "azure_client_id",
      "description": "Azure client ID of the Service Principal the agent authenticates with. Required when cloud_provider is 'azure', unless azure_workload_identity is true. With azure_workload_identity it can be set without a secret: it then annotates the ServiceAccount (the agent-wide default identity for SDK tools).",
      "required": false
    },
    {
      "name": "azure_client_secret",
      "description": "Azure client secret of the Service Principal the agent authenticates with. Required when cloud_provider is 'azure', unless azure_workload_identity is true.",
      "required": false
    },
    {
      "name": "azure_subscription_id",
      "description": "Azure subscription ID. Required when cloud_provider is 'azure'.",
      "required": false
    },
    {
      "name": "azure_resource_group",
      "description": "Azure resource group name. Required when cloud_provider is 'azure'.",
      "required": false
    },
    {
      "name": "private_hosted_zone_rg",
      "description": "Resource group for private hosted zone. Required when cloud_provider is 'azure'.",
      "required": false
    },
    {
      "name": "azure_workload_identity",
      "description": "",
      "required": false
    },
    {
      "name": "azure_tenant_id",
      "description": "Azure tenant ID. Required when cloud_provider is 'azure'.",
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
      "description": "Type of DNS Provider, e.g. azure, route53, or external_dns",
      "required": false
    },
    {
      "name": "domain",
      "description": "Base domain name used across resources",
      "required": false
    },
    {
      "name": "image_pull_secrets",
      "description": "",
      "required": false
    },
    {
      "name": "image_pull_secret_name",
      "description": "",
      "required": false
    },
    {
      "name": "service_template",
      "description": "Path, inside the worker image, of the Service template the k8s scope renders. Empty (default) uses the template ingress_stack selects; set it only to point at a custom template.",
      "required": false
    },
    {
      "name": "initial_ingress_path",
      "description": "Path, inside the worker image, of the ingress/route template used on a scope's first deployment. Empty (default) uses the template ingress_stack selects; set it only to point at a custom template.",
      "required": false
    },
    {
      "name": "blue_green_ingress_path",
      "description": "Path, inside the worker image, of the ingress/route template used to shift traffic during a blue-green deployment. Empty (default) uses the template ingress_stack selects; set it only to point at a custom template.",
      "required": false
    },
    {
      "name": "extra_envs",
      "description": "Additional environment variables to pass to the agent",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "b048bc68f771844871104f4220f1433b"
}
END_AI_METADATA -->
