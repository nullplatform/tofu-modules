# Module: docker_server

## Description

Configures a Docker registry provider in nullplatform with server credentials and path settings

## Architecture

Creates a nullplatform_provider_config resource of type 'docker-server' with encoded JSON attributes containing Docker registry connection details. The module accepts credentials (login_server, username, password), path configuration, and optional dimensions for multi-tenant segmentation, then encodes these into a JSON attributes block that nullplatform uses to authenticate and route container image operations. The NRN (nullplatform resource name) links this provider configuration to specific nullplatform resources.

## Features

- Creates Docker server provider configuration in nullplatform
- Configures Docker registry authentication with username and password credentials
- Sets registry path and login server endpoint for container image operations
- Supports multi-dimensional segmentation through optional dimensions map
- Defaults username to '_json_key_base64' for GCP service account authentication patterns
- Disables namespace usage in Docker registry configuration

## Basic Usage

```hcl
module "docker_server" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/asset/docker_server?ref=v3.3.0"

  login_server = "your-login-server"
  nrn          = "your-nrn"
  password     = "your-password"
  path         = "your-path"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.docker_server.id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.86 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.docker_server](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimensions to segment the nullplatform provider config (e.g. by region, environment) | `map(string)` | `{}` | no |
| <a name="input_login_server"></a> [login\_server](#input\_login\_server) | Docker login server name | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | The nullplatform resource name (NRN) | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | Docker password | `string` | n/a | yes |
| <a name="input_path"></a> [path](#input\_path) | Path to the created registry | `string` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | Docker username | `string` | `"_json_key_base64"` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "docker_server",
  "description": "Configures a Docker registry provider in nullplatform with server credentials and path settings",
  "architecture": "Creates a nullplatform_provider_config resource of type 'docker-server' with encoded JSON attributes containing Docker registry connection details. The module accepts credentials (login_server, username, password), path configuration, and optional dimensions for multi-tenant segmentation, then encodes these into a JSON attributes block that nullplatform uses to authenticate and route container image operations. The NRN (nullplatform resource name) links this provider configuration to specific nullplatform resources.",
  "features": [
    "Creates Docker server provider configuration in nullplatform",
    "Configures Docker registry authentication with username and password credentials",
    "Sets registry path and login server endpoint for container image operations",
    "Supports multi-dimensional segmentation through optional dimensions map",
    "Defaults username to '_json_key_base64' for GCP service account authentication patterns",
    "Disables namespace usage in Docker registry configuration"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "The nullplatform resource name (NRN)",
      "required": true
    },
    {
      "name": "login_server",
      "description": "Docker login server name",
      "required": true
    },
    {
      "name": "path",
      "description": "Path to the created registry",
      "required": true
    },
    {
      "name": "password",
      "description": "Docker password",
      "required": true
    },
    {
      "name": "username",
      "description": "Docker username",
      "required": false
    },
    {
      "name": "dimensions",
      "description": "Dimensions to segment the nullplatform provider config (e.g. by region, environment)",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "9c245562b5f4aedbe4403b0150ec33c5"
}
END_AI_METADATA -->
