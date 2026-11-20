# Module: package_configuration

## Description

Configures an installed nullplatform package for one place: the agent that serves it there and the package's values

## Architecture

A package is installed once in an organization (`package_installation`) and configured once per place, an NRN and usually dimensions. This module runs `np package configure` for that place from a `terraform_data` resource. The command reads the package's own manifest and creates the components it marks `"on": "configure"`, such as the values and the channel to the agent, so the module knows no kind of package. What is given (the place, the agent's tags, the values, imports) travels in the command's environment, never in the shell command. Any change of it replaces the resource, which runs the command again; the command finds what it created before on the installation's record and updates it.

## Features

- Configures a package for an NRN and its dimensions with one call per place
- Names the agent that serves the place by its tags; two places on one cluster give the same tags and each gets its own values and channel
- Passes the package's values as one JSON document, with their types
- Uses components that already exist instead of creating them, by name (`imports`)
- Runs the package's own `post_configure` lines when given a checkout of the package (`package_dir`)
- Runs again when the place, the agent, the values or the installed version change

## Basic Usage

```hcl
module "package_configuration" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/package_configuration?ref=v9.18.0"

  nrn          = "your-nrn"
  package_slug = "your-package-slug"
  dimensions   = { environment = "production" }
  agent        = { cluster = "your-cluster" }
  values       = { domain = "example.com" }
}
```

Two places on one cluster:

```hcl
module "package_configuration" {
  for_each = { development = "dev.example.com", staging = "stg.example.com" }
  source   = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/package_configuration?ref=v9.18.0"

  nrn          = "your-nrn"
  package_slug = "your-package-slug"
  dimensions   = { environment = each.key }
  agent        = { cluster = "your-cluster" }
  values       = { domain = each.value }
}
```

## What to know

- The machine running the apply needs `np`, a version that has `package configure`, and credentials: `NP_API_KEY` in its environment or `np_api_key`.
- What the command creates is not in the state. The installation records it; `np package status` shows it.
- Destroying the configuration removes it from the state only. `np` has no command to remove a place yet.
- The package must be installed first, with what its manifest creates on install: `package_installation` with `apply_manifest = true`. Make this module depend on it.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
