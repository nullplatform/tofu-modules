# Module: docker_server

## Description

Creates and configures a Docker server provider in nullplatform for container registry authentication and management

## Features

- Creates a nullplatform Docker server provider configuration
- Configures Docker registry authentication with login server credentials
- Supports custom registry paths for organized image storage
- Manages Docker username and password credentials securely
- Integrates with nullplatform resource naming (NRN) system
- Enables automated Docker registry access for nullplatform applications

## Basic Usage

```hcl
module "docker_server" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/asset/docker_server?ref=v1.45.0"

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
