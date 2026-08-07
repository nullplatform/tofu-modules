# A non-2xx is not an error for the http provider: the body would render as the template.
data "http" "parameter_storage_spec_template" {
  url = "${var.repository_parameter_storage_spec}/${var.repository_parameter_storage_spec_branch}/${var.template_path}"

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Fetch of ${self.url} returned HTTP ${self.status_code}, expected 200."
    }
  }
}

data "external" "parameter_storage_spec" {
  depends_on = [data.http.parameter_storage_spec_template]

  program = ["sh", "-c", <<-EOT
    template_b64="${base64encode(data.http.parameter_storage_spec_template.response_body)}"
    processed_json=$(echo "$template_b64" | base64 -d | \
    NRN='${var.nrn}' \
    gomplate)
    printf '%s\n' "$processed_json" | jq -c '{json: tojson}'
  EOT
  ]
}