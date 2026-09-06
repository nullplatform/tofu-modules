# Gateway Security Submodules

These submodules create cloud-specific security resources (Security Groups, NSGs, Firewall Rules) for Istio gateway health check port restriction.

They were extracted from `nullplatform/base` so that the base module no longer requires `aws`, `azurerm`, or `google` providers. Each submodule only requires its own cloud provider.

## Available Submodules

| Submodule | Provider | Resources |
|-----------|----------|-----------|
| `infrastructure/aws/security` | `aws >= 5.0` | `aws_security_group`, `aws_vpc_security_group_ingress_rule`, `aws_vpc_security_group_egress_rule` |
| `infrastructure/azure/security` | `azurerm >= 3.0` | `azurerm_network_security_group`, `azurerm_network_security_rule` |
| `infrastructure/gcp/security` | `google >= 5.0` | `google_compute_firewall` |

## Usage

Call the security submodule for your cloud, then pass the outputs to `nullplatform/base`.

### AWS Example

```hcl
module "base_security" {
  source       = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/security?ref=<version>"
  cluster_name = "my-eks-cluster"
}

module "base" {
  source       = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/base?ref=<version>"
  nrn          = var.nrn
  k8s_provider = "eks"

  gateway_public_aws_security_group_id  = module.base_security.public_gateway_security_group_id
  gateway_private_aws_security_group_id = module.base_security.private_gateway_security_group_id
}
```

### Azure Example

```hcl
module "base_security" {
  source                   = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/security?ref=<version>"
  cluster_name             = "my-aks-cluster"
  resource_group_name      = "my-rg"
  azure_location           = "eastus"
  gateways_enabled         = true
  gateway_internal_enabled = true
}

module "base" {
  source                       = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/base?ref=<version>"
  nrn                          = var.nrn
  k8s_provider                 = "aks"
  gateway_internal_enabled     = true

  gateway_public_azure_nsg_id  = module.base_security.public_gateway_nsg_id
  gateway_private_azure_nsg_id = module.base_security.private_gateway_nsg_id
}
```

### GCP Example

```hcl
module "base_security" {
  source         = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/gcp/security?ref=<version>"
  cluster_name   = "my-gke-cluster"
  gcp_project_id = "my-project"
  gcp_region     = "us-central1"
}

module "base" {
  source       = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/base?ref=<version>"
  nrn          = var.nrn
  k8s_provider = "gke"

  gateway_public_gcp_firewall_name  = module.base_security.public_gateway_firewall_name
  gateway_private_gcp_firewall_name = module.base_security.private_gateway_firewall_name
}
```

## Migration from Previous Version

If you previously used `gateway_security_enabled = true` in the base module, you need to:

1. Add the `module "base_security"` call for your cloud provider (see examples above).
2. Remove `gateway_security_enabled`, `cluster_name`, `resource_group_name`, `azure_location`, `vpc_id`, `network_cidr`, `gcp_project_id`, `gcp_network_name`, `gcp_region` from the base module call.
3. Pass the security outputs to the base module.
4. **Add `moved` blocks** to avoid destroy/recreate of existing security resources.

### Moved Blocks

Add these to your root module to migrate state automatically (no destroy/recreate):

#### AWS

```hcl
moved {
  from = module.base.aws_security_group.public_gateway
  to   = module.base_security.aws_security_group.public_gateway
}
moved {
  from = module.base.aws_security_group.private_gateway
  to   = module.base_security.aws_security_group.private_gateway
}
moved {
  from = module.base.aws_vpc_security_group_ingress_rule.public_gateway_https
  to   = module.base_security.aws_vpc_security_group_ingress_rule.public_gateway_https
}
moved {
  from = module.base.aws_vpc_security_group_ingress_rule.public_gateway_health_check
  to   = module.base_security.aws_vpc_security_group_ingress_rule.public_gateway_health_check
}
moved {
  from = module.base.aws_vpc_security_group_egress_rule.public_gateway_all
  to   = module.base_security.aws_vpc_security_group_egress_rule.public_gateway_all
}
moved {
  from = module.base.aws_vpc_security_group_ingress_rule.private_gateway_https
  to   = module.base_security.aws_vpc_security_group_ingress_rule.private_gateway_https
}
moved {
  from = module.base.aws_vpc_security_group_ingress_rule.private_gateway_health_check
  to   = module.base_security.aws_vpc_security_group_ingress_rule.private_gateway_health_check
}
moved {
  from = module.base.aws_vpc_security_group_egress_rule.private_gateway_all
  to   = module.base_security.aws_vpc_security_group_egress_rule.private_gateway_all
}
moved {
  from = module.base.data.aws_eks_cluster.this
  to   = module.base_security.data.aws_eks_cluster.this
}
moved {
  from = module.base.data.aws_vpc.this
  to   = module.base_security.data.aws_vpc.this
}
```

#### Azure

```hcl
moved {
  from = module.base.azurerm_network_security_group.public_gateway
  to   = module.base_security.azurerm_network_security_group.public_gateway
}
moved {
  from = module.base.azurerm_network_security_group.private_gateway
  to   = module.base_security.azurerm_network_security_group.private_gateway
}
moved {
  from = module.base.azurerm_network_security_rule.public_gateway_https
  to   = module.base_security.azurerm_network_security_rule.public_gateway_https
}
moved {
  from = module.base.azurerm_network_security_rule.public_gateway_health_check
  to   = module.base_security.azurerm_network_security_rule.public_gateway_health_check
}
moved {
  from = module.base.azurerm_network_security_rule.public_gateway_deny_health_check_internet
  to   = module.base_security.azurerm_network_security_rule.public_gateway_deny_health_check_internet
}
moved {
  from = module.base.azurerm_network_security_rule.private_gateway_https
  to   = module.base_security.azurerm_network_security_rule.private_gateway_https
}
moved {
  from = module.base.azurerm_network_security_rule.private_gateway_health_check
  to   = module.base_security.azurerm_network_security_rule.private_gateway_health_check
}
moved {
  from = module.base.azurerm_network_security_rule.private_gateway_deny_all
  to   = module.base_security.azurerm_network_security_rule.private_gateway_deny_all
}
moved {
  from = module.base.data.azurerm_kubernetes_cluster.this
  to   = module.base_security.data.azurerm_kubernetes_cluster.this
}
moved {
  from = module.base.data.azurerm_virtual_network.this
  to   = module.base_security.data.azurerm_virtual_network.this
}
```

#### GCP

```hcl
moved {
  from = module.base.google_compute_firewall.public_gateway_https
  to   = module.base_security.google_compute_firewall.public_gateway_https
}
moved {
  from = module.base.google_compute_firewall.public_gateway_health_check
  to   = module.base_security.google_compute_firewall.public_gateway_health_check
}
moved {
  from = module.base.google_compute_firewall.public_gateway_deny_health_check
  to   = module.base_security.google_compute_firewall.public_gateway_deny_health_check
}
moved {
  from = module.base.google_compute_firewall.private_gateway_https
  to   = module.base_security.google_compute_firewall.private_gateway_https
}
moved {
  from = module.base.google_compute_firewall.private_gateway_health_check
  to   = module.base_security.google_compute_firewall.private_gateway_health_check
}
moved {
  from = module.base.data.google_container_cluster.this
  to   = module.base_security.data.google_container_cluster.this
}
moved {
  from = module.base.data.google_compute_subnetwork.this
  to   = module.base_security.data.google_compute_subnetwork.this
}
```

> **Note:** The `moved` blocks can be removed after the first successful `terraform apply` post-migration.
