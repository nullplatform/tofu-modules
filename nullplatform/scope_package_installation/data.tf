################################################################################
# Template fetching
#
# Same URL shape and the same guard as scope_definition: a non-2xx is not an
# error for the http provider, so without the postcondition a missing template
# ("404: Not Found") would be parsed as the schema. Skipped with
# var.local_specs_path, when the template is read from disk (locals.tf).
################################################################################
data "http" "scope_configuration_template" {
  count = var.create_scope_configuration && var.local_specs_path == null ? 1 : 0
  url   = "${var.repository_scope_template}/${var.repository_scope_template_branch}/${var.service_path}/specs/scope-configuration.json.tpl"

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Fetch of ${self.url} returned HTTP ${self.status_code}, expected 200."
    }
  }
}
