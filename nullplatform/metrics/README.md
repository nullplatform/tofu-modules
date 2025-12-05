# Module: Metrics



## Usage

```hcl
module "metrics" {
  source               = "git::https://github.com/nullplatform/tofu-modules.git///nullplatform/metrics?ref=v1.0.0"
  dimensions           = var.dimensions
  nrn                  = var.nrn
  np_api_key           = var.np_api_key
  prometheus_url       = var.prometheus_url
}
```

***Important!***
This module only configure  the provider of metrics

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->