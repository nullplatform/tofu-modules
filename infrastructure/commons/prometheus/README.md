# Module: Prometheus

Deploys **Prometheus** using Helm.

## Usage

```hcl
module "prometheus" {
  source               = "git::https://github.com/nullplatform/tofu-modules.git///nullplatform/prometheus?ref=v1.0.0"
  prometheus_namespace = var.prometheus_namespace
  nullplatform_port    = var.nullplatform_port
}
```

***Important!***
This module only installs Prometheus; you must configure the metrics provider in order to integrate with Null Platform.


<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
