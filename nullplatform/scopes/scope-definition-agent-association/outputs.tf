################################################################################
# Scope Definition Module Outputs
################################################################################

output "id" {
  value = nullplatform_notification_channel.channel_from_template.id
  description = "The ID of the created notification channel"
}