
<h2 align="center">
  <a href="https://nullplatform.com" target="_blank">
    <img height="100" alt="nullplatform" src="https://nullplatform.com/favicon/android-chrome-192x192.png" />
  </a>
  <br><br>
  # Nullplatform Tofu modules
  <br>
</h2>

This repository contains **shared Tofu modules** used by nullplatform to standardize and reuse infrastructure across
all projects.

## 📦 Repository structure

```
.
├── infrastructure/                    # Cloud-specific infrastructure modules
│   ├── aws/
│   │   ├── acm/                       # AWS Certificate Manager
│   │   ├── alb_controller/            # ALB Ingress Controller
│   │   ├── backend/                   # S3/DynamoDB remote state backend
│   │   ├── eks/                       # Elastic Kubernetes Service
│   │   ├── iam/
│   │   │   ├── agent/                 # IAM role for nullplatform agent
│   │   │   ├── cert_manager/          # IAM role for cert-manager
│   │   │   └── external_dns/          # IAM role for external-dns
│   │   ├── ingress/                   # Ingress resources
│   │   ├── route53/                   # DNS zones
│   │   ├── security/                  # Security groups for gateways
│   │   └── vpc/                       # VPC, subnets, NAT
│   │
│   ├── azure/
│   │   ├── acr/                       # Azure Container Registry
│   │   ├── aks/                       # Azure Kubernetes Service
│   │   ├── dns/                       # Public DNS zones
│   │   ├── private_dns/               # Private DNS zones
│   │   ├── resource_group/            # Resource group
│   │   ├── security/                  # NSGs for gateways
│   │   └── vnet/                      # Virtual network, subnets
│   │
│   ├── gcp/
│   │   ├── artifact-registry/         # Artifact Registry
│   │   ├── cloud-dns/                 # Cloud DNS
│   │   ├── cloud-nat/                 # Cloud NAT
│   │   ├── gke/                       # Google Kubernetes Engine
│   │   ├── iam/                       # Service accounts & roles
│   │   ├── security/                  # Firewall rules for gateways
│   │   └── vpc/                       # VPC, subnets
│   │
│   ├── oci/
│   │   ├── backend/                   # OCI remote state backend
│   │   ├── dns/                       # OCI DNS zones
│   │   ├── dynamic_groups/            # Dynamic groups & policies
│   │   ├── oke/                       # Oracle Kubernetes Engine
│   │   └── vcn/                       # Virtual Cloud Network
│   │
│   └── commons/                       # Cloud-agnostic K8s modules
│       ├── cert_manager/              # TLS certificate management
│       ├── external_dns/              # DNS record automation
│       ├── istio/                     # Service mesh
│       └── prometheus/                # Monitoring stack
│
├── nullplatform/                      # Nullplatform-specific modules
│   ├── account/                       # Account configuration
│   ├── agent/                         # Nullplatform agent (Helm)
│   ├── api_key/                       # API key creation
│   ├── asset/
│   │   ├── docker_server/             # Docker server asset
│   │   └── ecr/                       # ECR asset
│   ├── base/                          # Base Helm chart (gateways, logging, etc.)
│   ├── code_repository/               # Code repository integration
│   ├── dimensions/                    # Metric dimensions
│   ├── metrics/                       # Prometheus provider configuration
│   ├── scope_definition/              # Scope type & action specs
│   ├── scope_definition_agent_association/   # Scope notification channel
│   ├── service_definition/            # Service specification
│   ├── service_definition_agent_association/ # Service notification channel
│   └── users/                         # User management
│
├── .github/
│   └── workflows/                     # CI/CD workflows
├── .pre-commit-config.yaml
├── commitlint.config.js
├── .gitignore
└── README.md
```


## 🧰 Prerequisites

These modules depend on the following tools:

- [**gomplate**](https://docs.gomplate.ca/installing/)
- [**np CLI (nullplatform CLI)**](https://docs.nullplatform.com/docs/cli/)

Install them with:

```bash
# Install gomplate (see link for package-specific instructions)
https://docs.gomplate.ca/installing/

# Install np CLI
curl -fsSL https://cli.nullplatform.com/install.sh | sh
```


## 🚀 Using the modules

Reference modules using their Git source with version pinning:

```hcl
module "<name>" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//<module-path>?ref=v1.0.0"
}
```

Then initialize and apply:

```bash
tofu init
tofu plan
tofu apply
```

## 📖 Examples

### API Key

Creates a nullplatform API key with specific grants and tags.

```hcl
module "agent_api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v1.0.0"

  name = "AGENT"

  grants = [
    { nrn = "organization=123:account=456", role_slug = "controlplane:agent" },
    { nrn = "organization=123:account=456", role_slug = "developer" },
    { nrn = "organization=123:account=456", role_slug = "ops" },
  ]

  tags = [
    { key = "managedBy", value = "IaC" },
  ]
}
```

### Agent

Deploys the nullplatform agent into a Kubernetes cluster via Helm. Requires an API key.

```hcl
module "agent" {
  source         = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v1.0.0"
  api_key        = module.agent_api_key.api_key
  cluster_name   = "my-cluster"
  nrn            = "organization=123:account=456:namespace=789"
  tags_selectors = { environment = "production" }
  image_tag      = "latest"
  cloud_provider = "aws"
}
```

### Base

Installs the base Helm chart (gateways, logging, observability).

```hcl
module "base" {
  source       = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/base?ref=v1.0.0"
  np_api_key   = var.np_api_key
  nrn          = var.nrn
  k8s_provider = "eks"
}
```

With gateway security enabled (Azure):

```hcl
module "base" {
  source                       = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/base?ref=v1.0.0"
  np_api_key                   = var.np_api_key
  nrn                          = var.nrn
  k8s_provider                 = "aks"
  gateway_internal_enabled     = true
  gateway_public_azure_nsg_id  = module.base_security.public_gateway_nsg_id
  gateway_private_azure_nsg_id = module.base_security.private_gateway_nsg_id
}
```

### Scope Definition

Creates scope types and action specifications from templates.

```hcl
module "scope_definition" {
  source                   = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_definition?ref=v1.0.0"
  nrn                      = var.nrn
  np_api_key               = var.np_api_key
  service_path             = "k8s"
  service_spec_name        = "Containers Default"
  service_spec_description = "Allows you to deploy in K8S clusters"
}
```

### Scope Definition Agent Association

Links agents with scope definitions via notification channels.

```hcl
module "scope_notification_api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v1.0.0"

  name = "SCOPE-NOTIFICATION-CHANNEL-K8S"

  grants = [
    { nrn = "organization=123:account=456", role_slug = "controlplane:agent" },
    { nrn = "organization=123:account=456", role_slug = "ops" },
  ]

  tags = [
    { key = "managedBy", value = "IaC" },
    { key = "usedBy",    value = "K8S" },
  ]
}

module "scope_definition_agent_association" {
  source                   = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_definition_agent_association?ref=v1.0.0"
  nrn                      = var.nrn
  api_key                  = module.scope_notification_api_key.api_key
  scope_specification_id   = module.scope_definition.service_specification_id
  scope_specification_slug = module.scope_definition.service_slug
  tags_selectors           = { environment = "production" }

  depends_on = [module.agent]
}
```

### Service Definition Agent Association

Associates agents with service definitions for specific backends (e.g., PostgreSQL).

```hcl
module "service_notification_api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v1.0.0"

  name = "SERVICE-NOTIFICATION-CHANNEL-POSTGRESQL"

  grants = [
    { nrn = "organization=123:account=456", role_slug = "controlplane:agent" },
    { nrn = "organization=123:account=456", role_slug = "admin" },
    { nrn = "organization=123:account=456", role_slug = "ops" },
  ]

  tags = [
    { key = "managedBy",  value = "IaC" },
    { key = "usedBy",     value = "POSTGRESQL" },
  ]
}

module "service_definition_agent_association" {
  source                     = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/service_definition_agent_association?ref=v1.0.0"
  api_key                    = module.service_notification_api_key.api_key
  nrn                        = var.nrn
  tags_selectors             = { environment = "production" }
  service_specification_id   = "123"
  service_specification_slug = "PostgreSQL"
  service_path               = "databases/postgres"

  depends_on = [module.agent]
}
```

### Metrics (Prometheus)

Configures Prometheus as the metrics provider in nullplatform.

```hcl
module "prometheus" {
  source              = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/prometheus?ref=v1.0.0"
  prometheus_namespace = "prometheus"
}

module "metrics" {
  source               = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/metrics?ref=v1.0.0"
  np_api_key           = var.np_api_key
  nrn                  = var.nrn
  dimensions           = { cluster = "my-cluster" }
  prometheus_namespace = "prometheus"

  depends_on = [module.prometheus]
}
```

### Infrastructure: Azure (full example)

```hcl
module "resource_group" {
  source              = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/resource_group?ref=v1.0.0"
  resource_group_name = "rg-myorg-poc"
  location            = "eastus2"
  subscription_id     = var.azure_subscription_id
}

module "vnet" {
  source              = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/vnet?ref=v1.0.0"
  address_space       = ["10.0.0.0/16"]
  vnet_name           = "vnet-myorg-poc"
  location            = "eastus2"
  resource_group_name = module.resource_group.resource_group_name
  subnets_definition  = var.subnets_definition
  subscription_id     = var.azure_subscription_id
}

module "aks" {
  source              = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/aks?ref=v1.0.0"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  cluster_name        = "myorg-poc"
  subscription_id     = var.azure_subscription_id
  vnet_subnet_id      = module.vnet.subnet_ids["subnet-2"]
  system_pool_vm_size = "Standard_B2ms"
  user_pool_vm_size   = "Standard_B2ms"
}

module "dns" {
  source              = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/dns?ref=v1.0.0"
  domain_name         = "myorg.example.com"
  resource_group_name = module.resource_group.resource_group_name
  subscription_id     = var.azure_subscription_id
}

module "acr" {
  source                 = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/acr?ref=v1.0.0"
  containerregistry_name = "acrmyorgpoc"
  resource_group_name    = module.resource_group.resource_group_name
  location               = "eastus2"
  subscription_id        = var.azure_subscription_id
  sku                    = "Basic"
}
```


## 📄 Module documentation

Each module must include its own `README.md` file describing:

- **Purpose** — what the module does and when to use it.  
- **Inputs** — variables (`variables.tf`) with descriptions, types, and default values.  
- **Outputs** — (`outputs.tf`) explaining what’s returned.  
- **Usage examples** — small working HCL snippets.  
- **Notes** — any internal dependencies, restrictions, or compatibility details.


## 🧪 Validations and CI/CD workflows

In `.github/workflows/`, you can include workflows for:

- Terraform / Tofu syntax validation.  
- Auto-formatting with `tofu fmt`.  
- Logical validation using `tofu validate`.  

These ensure code consistency and prevent configuration drift.


## 📌 Versioning and releases

- Follow **semantic versioning**: `vX.Y.Z`
- Keep backward compatibility within **minor** versions.
- Increment the **major** version for breaking changes.


## 🛠️ Best practices

- Keep each module isolated: one module = one clear responsibility.  
- Avoid circular dependencies between modules.  
- Document all variables (mark required vs optional).  
- Tag and version releases before using them in production.  
- Centralize repeated logic in these modules to avoid duplication.


## 👥 Contributing

If you want to add or modify a module:

1. Create a `feature/` or `fix/` branch.
2. Add tests or validations if applicable.
3. Update the module's documentation.
4. Open a Pull Request for review.

### Commit message format

This repository uses [Conventional Commits](https://www.conventionalcommits.org/) to ensure consistent commit messages. A pre-commit hook validates all commit messages automatically.

**Valid commit examples:**

```bash
feat: add new EKS module
feat(aws): add support for multiple availability zones
fix: resolve VPC peering connection issue
fix(azure): correct DNS zone configuration
docs: update README with usage examples
refactor: simplify IAM role creation
chore: update provider versions
```

**Invalid commit examples:**

```bash
added new feature        # ❌ missing type prefix
Fix bug                  # ❌ type must be lowercase
feat add login           # ❌ missing colon after type
```

**Setup pre-commit hooks:**

```bash
# Install pre-commit (if not already installed)
brew install pre-commit

# Install the commit-msg hook
pre-commit install --hook-type commit-msg
```

---

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
