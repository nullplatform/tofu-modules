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
│   │   ├── ingress/
│   │   ├── route53/
│   │   └── vpc/
│   │
│   ├── azure/
│   │   ├── acr/
│   │   ├── dns/
│   │   ├── resource_group/
│   │   └── vnet/
│   │
│   ├── gcp/
│   │   └── ...
│   │
│   └── commons/
│       ├── cert_manager/
│       ├── external_dns/
│       └── istio/
|       └── prometheus/
|
│
├── nullplatform/
│   ├── cloud/
│   │   ├── aws/
│   │   ├── azure/
│   │   └── gcp/
│   │
│   ├── account/
│   ├── asset/
│   ├── code_repository/
│   ├── dimensions/
│   ├── metrics/
│   └── users/
│
├── .github/
│   └── workflows/                 # CI/CD workflows, validations, etc.
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
   module "my_module" {
     source = "git@github.com:nullplatform/tofu-modules.git//modules/moduleA"
     # Alternatively:
     # source = "github.com/nullplatform/tofu-modules//modules/moduleA?ref=vX.Y.Z"

     # Module parameters
     var1 = "value1"
     var2 = "value2"
     # ...
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
3. Update the module’s documentation.
4. Open a Pull Request for review.

---

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
