# Module: docker_server

## Description

Configures a nullplatform provider with a Docker server setup

## Architecture

The module creates a nullplatform_provider_config resource of type docker-server, which is configured with the provided login server, path, username, and password. The nullplatform_provider_config resource is then used to set up the Docker server. The module uses the nullplatform API key for authentication. The username is set to _json_key_base64 by default, but can be overridden by the user.

## Features

- Configures a nullplatform provider with a Docker server setup
- Sets up a Docker login server with the provided credentials
- Authenticates with the nullplatform API using the provided API key

## Basic Usage

```hcl
module "docker_server" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/asset/docker_server?ref=v1.47.0"

  login_server = "your-login-server"
  np_api_key   = "your-np-api-key"
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
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key for authentication | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | The nullplatform resource name (NRN) | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | Docker password | `string` | n/a | yes |
| <a name="input_path"></a> [path](#input\_path) | Path to the created registry | `string` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | Docker username | `string` | `"_json_key_base64"` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "docker_server",
  "description": "Configures a nullplatform provider with a Docker server setup",
  "architecture": "The module creates a nullplatform_provider_config resource of type docker-server, which is configured with the provided login server, path, username, and password. The nullplatform_provider_config resource is then used to set up the Docker server. The module uses the nullplatform API key for authentication. The username is set to _json_key_base64 by default, but can be overridden by the user.",
  "features": [
    "Configures a nullplatform provider with a Docker server setup",
    "Sets up a Docker login server with the provided credentials",
    "Authenticates with the nullplatform API using the provided API key"
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
      "name": "np_api_key",
      "description": "Nullplatform API key for authentication",
      "required": true
    },
    {
      "name": "username",
      "description": "Docker username",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "a92e12e0d84ac068abae3f9a954ba240"
}
END_AI_METADATA -->
