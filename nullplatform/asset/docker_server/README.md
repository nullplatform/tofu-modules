# Module: docker_server

## Description

Configures a Docker server provider in nullplatform by creating a provider config resource with registry connection details

## Architecture

This module creates a single nullplatform_provider_config resource of type docker-server. The resource receives the NRN (nullplatform resource name) as its identifier and encodes the Docker registry connection attributes as a JSON payload. Input variables for login_server, path, username, and password are mapped directly into the attributes block using jsonencode, with use_namespace hardcoded to false.

## Features

- Creates a nullplatform_provider_config resource scoped to a specific NRN for Docker registry integration
- Encodes Docker server connection attributes as a structured JSON payload within the provider config
- Configures Docker registry access with login server URL, path, username, and password credentials
- Defaults username to '_json_key_base64' to support GCP Artifact Registry service account key authentication
- Disables namespace usage by hardcoding use_namespace to false in the registry setup

## Basic Usage

```hcl
module "docker_server" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/asset/docker_server?ref=v8.0.0"

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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.95 |

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
  "description": "Configures a Docker server provider in nullplatform by creating a provider config resource with registry connection details",
  "architecture": "This module creates a single nullplatform_provider_config resource of type docker-server. The resource receives the NRN (nullplatform resource name) as its identifier and encodes the Docker registry connection attributes as a JSON payload. Input variables for login_server, path, username, and password are mapped directly into the attributes block using jsonencode, with use_namespace hardcoded to false.",
  "features": [
    "Creates a nullplatform_provider_config resource scoped to a specific NRN for Docker registry integration",
    "Encodes Docker server connection attributes as a structured JSON payload within the provider config",
    "Configures Docker registry access with login server URL, path, username, and password credentials",
    "Defaults username to '_json_key_base64' to support GCP Artifact Registry service account key authentication",
    "Disables namespace usage by hardcoding use_namespace to false in the registry setup"
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
  "hash": "b6b458425db5a92d873309c76e4ad2f9"
}
END_AI_METADATA -->
