# Module: docker_server

## Description

Creates a nullplatform Docker server provider configuration with authentication credentials for container registry access

## Architecture

The module creates a single nullplatform_provider_config resource of type 'docker-server'. Input variables for NRN, login server, path, username, and password flow directly into the resource's attributes as a JSON-encoded setup configuration. The attributes define server connection details including the registry server URL, repository path, authentication credentials, and namespace usage settings.

## Features

- Creates nullplatform provider configuration for Docker server integration
- Configures Docker registry authentication with username and password credentials
- Sets registry path for container image storage location
- Supports custom login server endpoints for different registry providers
- Defaults username to '_json_key_base64' for service account JSON key authentication
- Disables namespace usage in the Docker server setup

## Basic Usage

```hcl
module "docker_server" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/asset/docker_server?ref=v1.51.0"

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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.67 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | >= 0.0.67 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.docker_server](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_login_server"></a> [login\_server](#input\_login\_server) | Docker login server name | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | The nullplatform resource name (NRN) | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | Docker password | `string` | n/a | yes |
| <a name="input_path"></a> [path](#input\_path) | Path to the created registry | `string` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | Docker username | `string` | `"_json_key_base64"` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "docker_server",
  "description": "Creates a nullplatform Docker server provider configuration with authentication credentials for container registry access",
  "architecture": "The module creates a single nullplatform_provider_config resource of type 'docker-server'. Input variables for NRN, login server, path, username, and password flow directly into the resource's attributes as a JSON-encoded setup configuration. The attributes define server connection details including the registry server URL, repository path, authentication credentials, and namespace usage settings.",
  "features": [
    "Creates nullplatform provider configuration for Docker server integration",
    "Configures Docker registry authentication with username and password credentials",
    "Sets registry path for container image storage location",
    "Supports custom login server endpoints for different registry providers",
    "Defaults username to '_json_key_base64' for service account JSON key authentication",
    "Disables namespace usage in the Docker server setup"
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
    }
  ],
  "outputs": [],
  "hash": "84c1caf9b48feba0e0aeb2a64d869d5c"
}
END_AI_METADATA -->
