# Module: package_configuration

## Description

Configures an installed nullplatform package for one place: the agent that serves it there and the package's values

## Architecture

A package is installed once in an organization (`package_installation`) and configured once per place, an NRN and usually dimensions. This module runs `np package configure` for that place from a `terraform_data` resource. The command reads the manifest the installed version keeps and creates the components it marks `"on": "configure"`, such as the values and the channel to the agent, each by its kind's API or by a task the package brings, so the module knows no kind of package. What is given (the place, the agent's tags, the values, imports) travels in the command's environment, never in the shell command. A change of what the package gets there runs the command again, which updates what the place already has; a change of the place itself (its NRN or dimensions) removes the old place and configures the new one. Destroying the module runs `np package unconfigure`. What the installation records for the place is read back with `np package status` and given as outputs.

## Features

- Configures a package for an NRN and its dimensions with one call per place
- Names the agent that serves the place by its tags; two places on one cluster give the same tags and each gets its own values and channel
- Passes the package's values as one JSON document with their types, one group per form the package brings
- Uses components that already exist instead of creating them, by name (`imports`)
- Runs the package's own tasks from the manifest the version keeps: no checkout of the package and no Docker, only `mise` on the machine running the apply (`run_hooks = false` leaves them out)
- Runs again when the agent, the values or the installed version change, without removing the place
- Removes the place on destroy: what configuring created there is removed, what it only used is left
- Gives what the installation records for the place as outputs: `status`, `version`, `resources` (each with its id and ref) and `outputs` (what the package's tasks answered)

## Basic Usage

```hcl
module "package_configuration" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/package_configuration?ref=v9.18.0"

  nrn          = "your-nrn"
  package_slug = "your-package-slug"
  dimensions   = { environment = "production" }
  agent        = { cluster = "your-cluster" }

  # one group per form the package brings, each laid out as its form is
  values = {
    scope     = { networking = { domain_name = "example.com" } }
    placement = { cluster = { namespace = "apps" } }
  }
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
  values       = { scope = { networking = { domain_name = each.value } } }
}
```

## Using Outputs

```hcl
# What the package's own tasks answered for the place, by the names the package chose
output "placeholder_image" {
  value = module.package_configuration.outputs["lambda.deployment.placeholder_image_uri"]
}

# What was created there, each with its id and its ref
locals {
  channel_id = one([for resource in module.package_configuration.resources : resource.id if resource.name == "channel"])
}

# Wait for the place before something that needs it
resource "example_resource" "this" {
  depends_on = [module.package_configuration]
}
```

## What to know

- The machine running the apply needs `np`, a version that has `package configure` and `package unconfigure`, and credentials: `NP_API_KEY` in its environment or `np_api_key`. A package that brings tasks of its own also needs `mise`, which installs the tools those tasks declare; the tasks run as whoever runs the apply, with their cloud credentials and kubectl context.
- What the command creates is not in the state. The installation records it, and this module's outputs read it from there, on every plan too: `read_record = false` turns that off where `np` is not available at plan time.
- Use a package's outputs like any module's: `module.package_configuration.outputs["<name>"]`.
- Destroying the configuration removes the place. A new value, agent or version does not: the place is updated where it is.
- A form's values can also be written with `nullplatform_provider_config`, which has state and a destroy: leave that form's group out here and this module configures the rest of the place.
- The package must be installed first, with what its manifest creates on install: `package_installation` with `apply_manifest = true`. Make this module depend on it.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
