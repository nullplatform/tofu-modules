output "notification_channel_id" {
  description = "ID of the created agent notification channel."
  value       = nullplatform_notification_channel.from_template.id
}
