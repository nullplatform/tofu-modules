################################################################################
# Example: a workflow started by a webhook
#
# The alias registers the webhook while it is active, and the module outputs its
# URL. The URL ends in a capability token, so the output is sensitive: read it
# with `tofu output -json webhook_urls`. The provider reads its API key from
# NULLPLATFORM_API_KEY.
################################################################################
terraform {
  required_providers {
    nullplatform = {
      source  = "nullplatform/nullplatform"
      version = ">= 0.0.114"
    }
  }
}

module "notify" {
  source = "../../"

  key  = "notify"
  name = "Notify"

  # file(), not templatefile(): the workflow's ${{ }} expressions are not
  # Terraform's, and file() leaves them as they are.
  definition = yamldecode(file("${path.module}/workflows/notify.yaml"))
}

output "webhook_urls" {
  description = "Webhook URL of each trigger, by trigger id."
  value       = module.notify.webhook_urls
  sensitive   = true
}
