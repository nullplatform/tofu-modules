# Module: acr_push_token

## Description

Creates a push-only credential for an existing Azure Container Registry: a repository-scoped ACR token bound to the built-in `_repositories_push` scope map. It replaces the registry admin user as the credential CI pushes images with.

## Architecture

The module reads the registry's built-in `_repositories_push` scope map with the `azurerm_container_registry_scope_map` data source, creates an `azurerm_container_registry_token` bound to it, and generates its password with `azurerm_container_registry_token_password`. The token name is the username; the generated password is exposed as a sensitive output. Both feed the `nullplatform/asset/docker_server` module.

## Features

- Push and pull on every repository of the registry, without the delete and registry-management rights of the admin user
- Optional password expiry (`password_expiry`, RFC 3339)
- Works against an existing registry, whether or not it was created with `infrastructure/azure/acr`

## Basic Usage

```hcl
module "acr_push_token" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/acr_push_token?ref=<version>"

  containerregistry_name = "your-containerregistry-name"
  resource_group_name    = "your-resource-group-name"
}
```

## Using Outputs

```hcl
module "asset_docker_server" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/asset/docker_server?ref=<version>"

  nrn          = "your-nrn"
  login_server = module.acr.acr_login_server
  path         = "your-path"
  username     = module.acr_push_token.username
  password     = module.acr_push_token.password
}
```

## Pulling from AKS without secrets

This module is one half of running Azure without static registry credentials in the cluster, the same way EKS pulls from ECR through its node role:

| Concern | Module | Setting |
|---|---|---|
| AKS pulls images | `infrastructure/azure/aks` | `acr_id = module.acr.acr_id`, `attach_acr = true` (AcrPull on the kubelet identity) |
| CI pushes images | `infrastructure/azure/acr_push_token` + `nullplatform/asset/docker_server` | username/password from this module |
| Admin user | `infrastructure/azure/acr` | `admin_enabled = false` |
| Application pods | k8s scope configuration | `IMAGE_PULL_SECRETS.ENABLED = false` (the `azure` scope default) |

Migrating an existing install, in order:

1. Apply `aks` with `attach_acr = true` and check that a pod with no `imagePullSecrets` pulls from the registry.
2. Turn image pull secrets off (scope configuration, or `image_pull_secrets` on `nullplatform/agent`) and delete the per-namespace pull secrets.
3. Apply this module and re-apply `docker_server` with its outputs; run a build to confirm the push.
4. Set `admin_enabled = false` on `acr`.

## Notes

- ACR tokens are not supported on registries that use the "RBAC Registry + ABAC Repository Permissions" mode.
- The kubelet identity is shared by every pod in the cluster: any pod can pull any image of the attached registry.
