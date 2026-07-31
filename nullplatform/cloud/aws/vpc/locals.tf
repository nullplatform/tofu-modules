locals {
  # `load_balancer` sent empty (unconfigured) is meaningless to the API,
  # which never persists it back, causing drift — omit unless it has content.
  load_balancer_configured = length(var.load_balancer.public) > 0 || length(var.load_balancer.private) > 0
}