<h2 align="center">
  <a href="https://nullplatform.com" target="_blank">
    <img height="100" alt="nullplatform" src="https://nullplatform.com/favicon/android-chrome-192x192.png" />
  </a>
  <br><br>
  Nullplatform Tofu modules
  <br>
</h2>

Shared **OpenTofu / Terraform** modules used by nullplatform to standardize and reuse infrastructure across cloud providers and the nullplatform control plane.

## Repository structure

```
infrastructure/
├── aws/        # AWS modules (EKS, VPC, IAM, ALB, ACM, ...)
├── azure/      # Azure modules (AKS, VNet, ACR, DNS, ...)
├── gcp/        # GCP modules (GKE, VPC, Cloud DNS, ...)
├── oci/        # OCI modules (OKE, VCN, ...)
└── commons/    # Cloud-agnostic modules (cert-manager, external-dns, istio, prometheus)

nullplatform/   # Nullplatform control-plane modules (agent, api_key, scope_definition, ...)
```

Each module has its own `README.md` documenting inputs, outputs, and usage.

## Usage

Reference any module via its Git source, pinned to a release tag:

```hcl
module "vpc" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/vpc?ref=v6.10.0"

  # module inputs ...
}
```

Then:

```bash
tofu init
tofu plan
tofu apply
```

See the [latest releases](https://github.com/nullplatform/tofu-modules/releases) for available versions.

## Versioning

Releases follow [Semantic Versioning](https://semver.org/) and are automated via [release-please](https://github.com/googleapis/release-please). See [CHANGELOG.md](CHANGELOG.md) for the full release history.

## Contributing

Pull requests to `main` are validated by CI for branch naming and [Conventional Commits](https://www.conventionalcommits.org/).

**Branch naming**: `<type>/<description>` — e.g. `feat/add-eks-module`, `fix/vpc-cidr-validation`, `docs/update-readme`.

**Commit messages**: Conventional Commits format. Valid types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.

```
feat(aws/eks): add support for managed node groups
fix(gcp/vpc): correct subnet CIDR validation
docs: update root README with usage examples
```

**Pre-commit hooks** (optional, recommended) run `tofu fmt`, `tofu validate`, `tofu test`, and commit-message linting locally:

```bash
brew install pre-commit
pre-commit install
pre-commit install --hook-type commit-msg
```

See [`.pre-commit-config.yaml`](.pre-commit-config.yaml) for the full hook list.
