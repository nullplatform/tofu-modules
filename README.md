
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
├── infrastructure/                # All reusable Tofu modules
│   ├── aws/
│   │   ├── acm/
│   │   ├── alb_controller/
│   │   ├── backend/
│   │   ├── eks/
│   │   ├── iam/
│   │   │   ├── agent/
│   │   │   └── external_dns/
│   │   ├── ingress/
│   │   ├── route53/
│   │   └── vpc/
│   │
│   ├── azure/
│   │   ├── acr/
│   │   ├── aks/
│   │   ├── dns/
│   │   ├── resource_group/
│   │   └── vnet/
│   │
│   ├── gcp/
│   │   └── iam/
│   │
│   └── commons/
│       ├── cert_manager/
│       ├── external_dns/
│       └── istio/
│
├── nullplatform/
│   ├── account/
│   ├── agent/
│   ├── asset/
│   │   ├── docker_server/
│   │   └── ecr/
│   ├── authorization/
│   ├── base/
│   ├── cloud/
│   │   ├── aws/cloud/
│   │   ├── azure/cloud/
│   │   └── gcp/cloud/
│   ├── code_repository/
│   ├── dimensions/
│   ├── prometheus/
│   ├── scope_definition/
│   ├── scope_definition_agent_association/
│   └── users/
│
├── .github/
│   └── workflows/                 # CI/CD workflows, validations, etc.
├── .pre-commit-config.yaml        # Pre-commit hooks configuration
├── commitlint.config.js           # Conventional commits validation
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

1. **Add the module dependency** to your Tofu project:

   ```hcl
   # Example: Using an infrastructure module (AWS VPC)
   module "vpc" {
     source = "git@github.com:nullplatform/tofu-modules.git//infrastructure/aws/vpc"
     # Alternatively with version pinning:
     # source = "github.com/nullplatform/tofu-modules//infrastructure/aws/vpc?ref=vX.Y.Z"

     # Module parameters
     var1 = "value1"
     var2 = "value2"
   }

   # Example: Using a nullplatform module
   module "account" {
     source = "git@github.com:nullplatform/tofu-modules.git//nullplatform/account"

     # Module parameters
     var1 = "value1"
     var2 = "value2"
   }
   ```

2. **Initialize and apply your Tofu project:**

   ```bash
   tofu init
   tofu plan
   tofu apply
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
