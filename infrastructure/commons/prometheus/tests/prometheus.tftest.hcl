mock_provider "helm" {}

variables {
  prometheus_version = "29.27.0"
}

################################################################################
# Version pinning
################################################################################

# The helm_release carried no version argument and the module exposed no variable for one,
# so every apply resolved to whatever prometheus-community served latest, with no diff to
# review and no way to pin without editing the module.
run "prometheus_version_reaches_the_release" {
  command = plan

  assert {
    condition     = helm_release.prometheus.version == "29.27.0"
    error_message = "prometheus_version must be wired to the helm_release so the deployed chart is a decision"
  }
}

run "prometheus_version_is_overridable" {
  command = plan

  variables {
    prometheus_version = "29.26.0"
  }

  assert {
    condition     = helm_release.prometheus.version == "29.26.0"
    error_message = "prometheus_version must be settable by the caller"
  }
}
