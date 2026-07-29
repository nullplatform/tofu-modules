locals {
  # `load_balancer` is optional in the "aws-networking-configuration" schema
  # (only `vpc` is required) and its own description states at least one of
  # public/private must be set — sending it as {public = {}, private = {}}
  # when unconfigured is meaningless to the API, which never persists it back,
  # causing perpetual drift. Omit the whole key unless there's real content.
  load_balancer_configured = length(var.load_balancer.public) > 0 || length(var.load_balancer.private) > 0
}