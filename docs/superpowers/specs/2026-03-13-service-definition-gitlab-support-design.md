# Design: GitLab Support for `service_definition` Module

**Date:** 2026-03-13
**Status:** Approved
**Scope:** `nullplatform/service_definition` module only

---

## Context

The `service_definition` module fetches service spec templates (JSON) from a remote git repository via HTTP data sources. Currently it only supports GitHub, constructing URLs using `raw.githubusercontent.com` and authenticating with a Bearer token.

The goal is to add support for GitLab — both `gitlab.com` (SaaS) and self-hosted instances — while cleaning up variable names to be provider-agnostic.

Backward compatibility is **not required**: existing callers will need to update their variable names.

---

## Approach

**Option A — Generic variables + `git_provider` switch** (selected)

Rename provider-specific variables to generic names and add a `git_provider` variable. URL construction and authentication headers are computed in `locals.tf` based on the provider.

Other options considered and rejected:
- **Parallel `github_*` / `gitlab_*` variable sets** — bloated, redundant
- **Two separate modules** — code duplication, worse DX

---

## Variable Changes

### Removed

| Old Variable | Replaced By |
|---|---|
| `repository_service_spec_org` | `repository_org` |
| `repository_service_spec_repo` | `repository_name` |
| `repository_service_spec_branch` | `repository_branch` |
| `github_token` | `repository_token` |

### Added / New

| Variable | Type | Default | Description |
|---|---|---|---|
| `git_provider` | `string` | `"github"` | Git provider: `"github"` or `"gitlab"`. Validated with a `validation` block. |
| `repository_org` | `string` | `"nullplatform"` | GitHub organization or GitLab group owning the repository |
| `repository_name` | `string` | `"service"` | Repository name |
| `repository_branch` | `string` | `"main"` | Branch to fetch specs from |
| `repository_token` | `string` | `null` (sensitive) | Access token. GitHub: Bearer token. GitLab: Personal Access Token (PAT). |
| `gitlab_host` | `string` | `"gitlab.com"` | GitLab host. Only used when `git_provider = "gitlab"`. Enables self-hosted GitLab support. |

### Unchanged

`nrn`, `service_path`, `service_name`, `available_actions`, `available_links`, `extra_visibile_to_nrns`, `dimensions`

---

## `locals.tf` Changes

```hcl
locals {
  raw_base_url = var.git_provider == "github" ? (
    "https://raw.githubusercontent.com/${var.repository_org}/${var.repository_name}/refs/heads/${var.repository_branch}/${var.service_path}"
  ) : (
    "https://${var.gitlab_host}/${var.repository_org}/${var.repository_name}/-/raw/${var.repository_branch}/${var.service_path}"
  )

  auth_headers = var.repository_token == null ? {} : (
    var.git_provider == "github" ? (
      { Authorization = "Bearer ${var.repository_token}" }
    ) : (
      { "PRIVATE-TOKEN" = var.repository_token }
    )
  )
}
```

`data.tf` requires **no changes** — it already references `local.raw_base_url` and `local.auth_headers`.

---

## Files to Modify

| File | Change |
|---|---|
| `nullplatform/service_definition/variables.tf` | Remove 4 old variables, add 6 new ones with validation on `git_provider` |
| `nullplatform/service_definition/locals.tf` | Update `raw_base_url` and `auth_headers` logic |
| `nullplatform/service_definition/README.md` | Update variable documentation |

---

## Out of Scope

- `service_definition_agent_association` — no changes needed
- Bitbucket or other providers — not in scope
- Template format changes — specs remain JSON, no format differences by provider
