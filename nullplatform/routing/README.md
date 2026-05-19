# nullplatform/routing

Terraform module that installs the `nullplatform-routing` Helm chart, which manages all Kubernetes routing infrastructure for a nullplatform cluster: Gateway API resources, Ingress Controllers (ARO), and their associated autoscaling and disruption budget policies.

This module is the counterpart of `nullplatform/base`. Base handles logging, observability, and the nullplatform agent. Routing handles all traffic ingress.

---

## What it installs

### Namespaces

This module does NOT create namespaces directly. Instead:

| Namespace | Created by |
|-----------|------------|
| `nullplatform-tools` (release namespace) | `nullplatform/base` module (`kubernetes_namespace_v1`) — must exist before this module runs |
| `gateways` (gateway resources namespace) | The `nullplatform-routing` Helm chart itself — declared as a Namespace template with `helm.sh/resource-policy: keep` so it survives uninstalls and is adopted on re-installs |

If you use this module without `nullplatform/base`, you must pre-create the `nullplatform-tools` namespace yourself (or set `create_namespace = true` on a wrapping `helm_release`).

### Helm chart: `nullplatform-routing`

The chart templates vary by `k8s_provider`:

**Providers: `eks`, `aks`, `gke`, `oke`**

| Resource | Description |
|----------|-------------|
| `Gateway` (internal) | Istio Gateway with cloud-specific LB annotations. Tagged `helm.sh/resource-policy: keep` to preserve LoadBalancer IP on upgrades. |
| `Gateway` (public) | Same, internet-facing. |
| `HorizontalPodAutoscaler` | Scales `<name>-istio` deployment (created by Istio automatically). Min 2 / max 10 replicas. |
| `PodDisruptionBudget` | `maxUnavailable: 50%` per gateway. Tagged `keep` to survive helm uninstall. |

**Provider: `aro` (OpenShift)**

| Resource | Description |
|----------|-------------|
| `IngressController` (public) | OpenShift ingress with `LoadBalancerService`, external scope. |
| `IngressController` (private) | OpenShift ingress with `LoadBalancerService`, internal scope. |

**Pre-install hook (all providers)**

A `Job` runs before install/upgrade to apply Gateway API CRDs if they are not already present. Controlled by `install_gateway_v2_crd`.

---

## Usage

```hcl
module "base" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/base"

  k8s_provider = "eks"
  np_api_key   = var.np_api_key
}

module "routing" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/routing"

  k8s_provider = "eks"

  gateway_public_aws_name             = "k8s-nullplatform-internet-facing"
  gateway_internal_aws_name           = "k8s-nullplatform-internal"
  gateway_public_aws_security_group_id  = module.security.public_gateway_sg_id
  gateway_private_aws_security_group_id = module.security.private_gateway_sg_id
}
```

Both modules share the `nullplatform-tools` namespace. The base module owns its creation; the routing module just installs into it. Make sure `module.routing` runs after `module.base` (via implicit dependency on shared inputs or explicit `depends_on`).

---

## Cloud provider specifics

### EKS

Gateways use AWS NLB via the AWS Load Balancer Controller:

```hcl
module "routing" {
  source       = ".../nullplatform/routing"
  k8s_provider = "eks"

  gateway_public_aws_name              = "k8s-nullplatform-internet-facing"
  gateway_internal_aws_name            = "k8s-nullplatform-internal"
  gateway_public_aws_security_group_id  = "<sg-id>"
  gateway_private_aws_security_group_id = "<sg-id>"

  # Optional: set when using useClusterIP=true + external-dns
  # gateway_public_aws_dns_name  = "k8s-nullplatform-internet-facing-xxxx.elb.us-east-1.amazonaws.com"
  # gateway_private_aws_dns_name = "internal-k8s-nullplatform-internal-xxxx.elb.us-east-1.amazonaws.com"
}
```

### AKS

Gateways use Azure Load Balancer. The internal gateway always uses an internal LB subnet:

```hcl
module "routing" {
  source       = ".../nullplatform/routing"
  k8s_provider = "aks"

  internal_azure_load_balancer_subnet = "load_balancer"
  gateway_private_azure_nsg_id        = "<nsg-id>"
  gateway_public_azure_nsg_id         = "<nsg-id>"
}
```

### GKE

```hcl
module "routing" {
  source       = ".../nullplatform/routing"
  k8s_provider = "gke"

  gateway_private_gcp_firewall_name = "<firewall-rule-name>"
  gateway_public_gcp_firewall_name  = "<firewall-rule-name>"
}
```

### OKE (Oracle)

```hcl
module "routing" {
  source       = ".../nullplatform/routing"
  k8s_provider = "oke"

  gateway_public_oci_security_list_management_mode  = "All"
  gateway_private_oci_security_list_management_mode = "All"
}
```

### ARO (OpenShift)

ARO does not use Gateway API. Instead, the chart creates OpenShift `IngressController` resources:

```hcl
module "routing" {
  source       = ".../nullplatform/routing"
  k8s_provider = "aro"
  gateways_enabled = false

  ingressControllers = {
    public = {
      name    = "internet-facing"
      enabled = true
      scope   = "External"
      domain  = "apps.mycluster.example.com"
    }
    private = {
      name    = "internal"
      enabled = true
      scope   = "Internal"
      domain  = "apps-int.mycluster.example.com"
    }
  }
}
```

---

## external-dns and the `external-dns.alpha.kubernetes.io/target` annotation

This annotation is only added to a Gateway when **both** conditions are met:

1. `gateway_use_cluster_ip = true` — Istio creates a `ClusterIP` Service instead of a `LoadBalancer` Service. With ClusterIP there is no external IP for external-dns to auto-discover.
2. The provider-specific `dns_name` variable is non-empty (e.g., `gateway_public_aws_dns_name`).

When these conditions are met, the annotation tells external-dns the exact hostname or IP to use as the DNS target, bypassing Service IP discovery.

**When `gateway_use_cluster_ip = false` (default):** Istio creates a `LoadBalancer` Service. external-dns detects the LB IP automatically from the Service — no annotation needed on the Gateway.

> **Note:** `dns_name` support is currently only wired for EKS (`gateway_public_aws_dns_name`, `gateway_private_aws_dns_name`). AKS and GKE require passing the DNS name directly via `nullplatform_routing_chart_path` custom values or a chart override until those variables are added to this module.

---

## Gateway resource lifecycle

Gateway objects and their PodDisruptionBudgets carry `helm.sh/resource-policy: keep`. This means:

- **`helm uninstall`** does NOT delete them — LoadBalancer IPs are preserved.
- **`helm upgrade`** DOES update them — annotation and spec changes are applied normally.
- To fully remove a gateway, delete it manually after uninstalling the chart.

---

## Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `k8s_provider` | `string` | required | Cloud provider: `eks`, `gke`, `aks`, `oke`, `aro` |
| `namespace` | `string` | `nullplatform-tools` | Helm release namespace (shared with base module) |
| `gateway_namespace` | `string` | `gateways` | Namespace for Gateway/Service resources |
| `nullplatform_routing_helm_version` | `string` | `1.0.0` | Chart version to install |
| `nullplatform_routing_chart_path` | `string` | `""` | Local path or OCI URL override (dev/testing) |
| `install_gateway_v2_crd` | `bool` | `false` | Run pre-install job to apply Gateway API CRDs |
| `gateways_enabled` | `bool` | `true` | Enable Gateway resources in the chart |
| `gateway_enabled` | `bool` | `false` | Enable HTTP (port 80) listener on gateways |
| `gateway_internal_enabled` | `bool` | `true` | Create the internal (private) Gateway |
| `gateway_public_enabled` | `bool` | `true` | Create the public Gateway |
| `gateway_use_cluster_ip` | `bool` | `false` | Use ClusterIP instead of LoadBalancer Service |
| `gateway_public_aws_name` | `string` | `k8s-nullplatform-internet-facing` | AWS NLB name for public gateway |
| `gateway_internal_aws_name` | `string` | `k8s-nullplatform-internal` | AWS NLB name for internal gateway |
| `gateway_public_aws_dns_name` | `string` | `""` | EKS: external-dns target for public gateway (ClusterIP mode) |
| `gateway_private_aws_dns_name` | `string` | `""` | EKS: external-dns target for internal gateway (ClusterIP mode) |
| `gateway_public_aws_security_group_id` | `string` | `""` | AWS SG ID for public gateway NLB |
| `gateway_private_aws_security_group_id` | `string` | `""` | AWS SG ID for internal gateway NLB |
| `gateway_public_azure_nsg_id` | `string` | `""` | Azure NSG ID for public gateway LB |
| `gateway_private_azure_nsg_id` | `string` | `""` | Azure NSG ID for internal gateway LB |
| `internal_azure_load_balancer_subnet` | `string` | `load_balancer` | AKS: subnet name for internal LB |
| `gateway_public_gcp_firewall_name` | `string` | `""` | GKE: firewall rule name for public gateway |
| `gateway_private_gcp_firewall_name` | `string` | `""` | GKE: firewall rule name for internal gateway |
| `gateway_public_oci_security_list_management_mode` | `string` | `All` | OKE: security list management mode for public gateway |
| `gateway_private_oci_security_list_management_mode` | `string` | `All` | OKE: security list management mode for internal gateway |
| `gateway_api_enabled` | `bool` | `false` | Enable Gateway API in the chart |
| `gateway_api_crds_install` | `bool` | `false` | Install Gateway API CRDs via chart hook |
| `aws_region` | `string` | `us-east-1` | AWS region (EKS only) |
| `ingressControllers` | `object` | (see below) | ARO only: public and private IngressController config |

**`ingressControllers` default:**
```hcl
{
  public  = { name = "internet-facing", enabled = false, scope = "External", domain = "" }
  private = { name = "internal",        enabled = false, scope = "Internal", domain = "" }
}
```

---

## Migration from `nullplatform/base` with `install_routing = true`

Prior to this module, routing was installed by the base module via `install_routing = true`. To migrate:

1. Remove `install_routing` and all `gateway_*` / `ingressControllers` variables from your `nullplatform/base` call.
2. Add a `nullplatform/routing` module block with the same gateway variables.
3. Run `terraform apply` — the routing module takes over Helm ownership of the existing resources. Gateway objects carry `helm.sh/resource-policy: keep`, so LoadBalancer IPs are not recycled.
