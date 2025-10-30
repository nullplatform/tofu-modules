################################################################################
# Git Repository Clone
################################################################################

# Clone the repository once and use local files
resource "null_resource" "clone_repo" {
  triggers = {
    repo_url = var.github_repo_url
    ref      = var.github_ref
  }

  provisioner "local-exec" {
    command = <<-EOT
      set -e
      REPO_DIR="${path.root}/.terraform-repo"

      # Force remove if exists (even if git locked)
      if [ -d "$REPO_DIR" ]; then
        chmod -R +w "$REPO_DIR" 2>/dev/null || true
        rm -rf "$REPO_DIR"
      fi

      # Clone fresh copy
      git clone --depth 1 --branch ${var.github_ref} ${var.github_repo_url} "$REPO_DIR"
    EOT
  }
}

################################################################################
# Notification Channel Template Fetching
################################################################################

# Read notification channel template from local git clone
data "local_file" "notification_channel_template" {
  depends_on = [null_resource.clone_repo]
  filename   = "${path.root}/.terraform-repo/${var.service_path}/specs/notification-channel.json.tpl"
}

################################################################################
# Notification Channel Processing
################################################################################

# Process notification channel template with service and API context
data "external" "notification_channel" {
  depends_on = [data.local_file.notification_channel_template]

  program = ["sh", "-c", <<-EOT
    template_b64="${base64encode(data.local_file.notification_channel_template.content)}"
    processed_json=$(echo "$template_b64" | base64 -d | \
    NRN='${var.nrn}' \
    NP_API_KEY='${nullplatform_api_key.nullplatform_agent_api_key.api_key}' \
    REPO_PATH='${var.repo_path}' \
    SERVICE_PATH='${var.service_path}' \
    SERVICE_SLUG='${var.service_specification_slug}' \
    SERVICE_SPECIFICATION_ID='${var.service_specification_id}' \
    gomplate)
    echo "$processed_json" | jq -c '{json: tojson}'
  EOT
  ]
}

locals {
  notification_channel_parsed = jsondecode(data.external.notification_channel.result.json)
}