<h2 align="center">
    <a href="https://httpie.io" target="blank_">
        <img height="100" alt="nullplatform" src="https://nullplatform.com/favicon/android-chrome-192x192.png" />
    </a>
    <br>
    <br>
    # Nullplatform Tofu Modules
    <br>
</h2>



This repository contains the **shared Tofu modules** used by Nullplatform to standardize and reuse infrastructure across all projects.

---

## 📦 Repository structure

```
.
├── infrastructue/                  # All reusable Tofu modules
│   ├── aws/
│   |   |──acm/
│   |   |──alb-controller/
|   |   |──backend/
|   |   |──eks/
|   |   |──ingress/
|   |   |──route53/
|   |   |──vpc/
│   │
│   ├── azure/
|   |     |──vnet/
|   |     |──acr/
|   |     |──dns/
|   |     |──resource_group/
|   |
|   |
│   |── gcp/
|   |
|   |──commons
|        |── cert-manager/
|        |── external-dns/
|        |── istio/
|
|──nullplatform/
|   |──cloud
│   │   ├──azure/
|   |   |──aws/
|   |   |──gcp/
|   |
|   |
│   |──account/
│   |──asset/
|   |──code_repository/
|   |──dimensions/
|   |──prometheus/
|   |──users/
|
|
├── .github/
│      |── workflows/            # CI/CD workflows, validations, etc.
├── .gitignore
└── README.md                 # This file
```

---
## Prerequisites

Our modules use gomplate and np cli(nullplatform cli). Therefore, we need to install them:


```bash
https://docs.gomplate.ca/installing/

```

```bash
curl https://cli.nullplatform.com/install.sh | sh

```

## 🚀 How to use the modules

1. In your Tofu project, add the dependency to the desired module:

   ```hcl
   module "my_module" {
     source = "git@github.com:nullplatform/tofu-modulues.git//modules/moduleA"
     # or: source = "github.com/nullplatform/tofu-modules//modules/moduleA?ref=vX.Y.Z"

     # Module parameters:
     var1 = "value1"
     var2 = "value2"
     # ...
   }
   ```

2. Run Tofu commands:

   ```bash
   tofu init
   tofu plan
   tofu apply
   ```

3. Check the module *outputs* so you can use them in other resources.

---

## 📄 Module documentation

Each module folder  should include its own `README.md` describing:

- Purpose of the module.
- Variables (`variables.tf`) with descriptions, types, and default values.
- Outputs (`outputs.tf`) with explanations.
- Usage example (small HCL snippet).
- Notes about internal dependencies, restrictions, or compatibility.


---

## 🧪 Validations and CI/CD workflows

In `.github/workflows/` you may include pipelines such as:

- Terraform syntax validation.
- `tofu fmt` for automatic formatting.
- `tofu validate` for logical checks.


---

## 📌 Versioning / Releases

- Use **semantic tags** (`vX.Y.Z`) to version the repository.
- Ideally, modules should keep compatibility across minor versions. Breaking changes should bump the major version.


---

## 🛠️ Best practices

- Keep each module isolated: one module = one clear responsibility.
- Avoid unnecessary cross-references between modules.
- Clearly document required vs optional variables.
- Tag and version the repository before using it in production.
- Centralize repeated logic in these modules to avoid duplication.

---

## 👥 Contributions

If you want to add or modify a module:

1. Create a `feature/` or `fix/` branch.
2. Add tests or validations if applicable.
3. Update or generate documentation for the affected module.
4. Open a Pull Request for review.

---





<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->