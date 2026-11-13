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

################################################################################
# Scrape configuration
################################################################################

# null-platform-metrics scraped the logs-controller on every node while the chart's
# kubernetes-pods job scraped the same pods by annotation: every series came twice.
run "no_duplicate_logs_controller_scrape_job" {
  command = plan

  assert {
    condition     = !strcontains(helm_release.prometheus.values[0], "null-platform-metrics")
    error_message = "the logs-controller is scraped by annotation; a second job doubles every nullplatform_* series"
  }
}
