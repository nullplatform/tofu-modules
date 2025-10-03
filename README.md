<h2 align="center">
    <a href="https://httpie.io" target="blank_">
        <img height="100" alt="nullplatform" src="https://nullplatform.com/favicon/android-chrome-192x192.png" />
    </a>
    <br>
    <br>
    # Nullplatform Main Terraform Modules
    <br>
</h2>



This repository contains the **shared Terraform modules** used by Nullplatform to standardize and reuse infrastructure across all projects.

---

## 📦 Repository structure

```
.
├── modules/                  # All reusable Terraform modules
│   ├── moduleA/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   ├── moduleB/
│   └── ...
├── .github/
│   └── workflows/            # CI/CD workflows, validations, etc.
├── .gitignore
└── README.md                 # This file
```

---

## 🚀 How to use the modules

1. In your Terraform project, add the dependency to the desired module:

   ```hcl
   module "my_module" {
     source = "git@github.com:nullplatform/main-terraform-modules.git//modules/moduleA"
     # or: source = "github.com/nullplatform/main-terraform-modules//modules/moduleA?ref=vX.Y.Z"
  
     # Module parameters:
     var1 = "value1"
     var2 = "value2"
     # ...
   }
   ```

2. Run Terraform commands:

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. Check the module *outputs* so you can use them in other resources.

---

## 📄 Module documentation

Each module inside `modules/` should include its own `README.md` describing:

- Purpose of the module.
- Variables (`variables.tf`) with descriptions, types, and default values.
- Outputs (`outputs.tf`) with explanations.
- Usage example (small HCL snippet).
- Notes about internal dependencies, restrictions, or compatibility.

Additionally, you can generate automatic documentation (e.g., using `terraform-docs`) if integrated into your pipeline.

---

## 🧪 Validations and CI/CD workflows

In `.github/workflows/` you may include pipelines such as:

- Terraform syntax validation.
- `terraform fmt` for automatic formatting.
- `terraform validate` for logical checks.
- Automatic documentation generation for modules.

---

## 📌 Versioning / Releases

- Use **semantic tags** (`vX.Y.Z`) to version the repository.
- Ideally, modules should keep compatibility across minor versions. Breaking changes should bump the major version.
- The main `README.md` can indicate the recommended (or stable) version.

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

## 🔗 Useful resources

- [Terraform Docs](https://www.terraform.io/docs)  
- [terraform-docs](https://github.com/terraform-docs/terraform-docs)  
- Nullplatform internal manuals (if available)
