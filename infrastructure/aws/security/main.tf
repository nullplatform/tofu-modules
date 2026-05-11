###############################################################################
# AWS SECURITY GROUPS FOR ISTIO GATEWAYS
# These security groups restrict the health check port (15021) to VPC CIDR
# while allowing HTTPS (443) traffic as needed.
###############################################################################

###############################################################################
# DATA SOURCES - Derive VPC and CIDR from cluster name
###############################################################################

# Get EKS cluster info to derive VPC ID
data "aws_eks_cluster" "this" {
  count = var.cluster_name != "" ? 1 : 0
  name  = var.cluster_name

  lifecycle {
    precondition {
      condition     = var.cluster_name != ""
      error_message = "cluster_name is required."
    }
  }
}

# Get VPC info to derive CIDR block
data "aws_vpc" "this" {
  count = var.cluster_name != "" ? 1 : 0
  id    = data.aws_eks_cluster.this[0].vpc_config[0].vpc_id
}

locals {
  need_data = var.gateways_enabled || var.gateway_internal_enabled

  # Derived values from data sources
  aws_vpc_id   = var.cluster_name != "" ? data.aws_vpc.this[0].id : ""
  aws_vpc_cidr = var.cluster_name != "" ? data.aws_vpc.this[0].cidr_block : ""

  # Derive cluster primary SG from data source
  aws_cluster_security_group_id = var.cluster_name != "" ? data.aws_eks_cluster.this[0].vpc_config[0].cluster_security_group_id : ""

  # Use override if provided, otherwise use derived value
  effective_vpc_id                  = var.vpc_id != "" ? var.vpc_id : local.aws_vpc_id
  effective_network_cidr            = var.network_cidr != "" ? var.network_cidr : local.aws_vpc_cidr
  effective_cluster_security_group_id = var.cluster_security_group_id != "" ? var.cluster_security_group_id : local.aws_cluster_security_group_id
}

###############################################################################
# PUBLIC GATEWAY
###############################################################################

# Security Group for Public Gateway (AWS/EKS)
# - Port 443 (HTTPS): Open to internet (0.0.0.0/0)
# - Port 15021 (Health Check): Restricted to VPC CIDR only
resource "aws_security_group" "public_gateway" {
  count = var.gateways_enabled ? 1 : 0

  name        = "${var.cluster_name}-istio-public-gateway"
  description = "Security group for Istio public gateway - HTTPS open, health check restricted to VPC"
  vpc_id      = local.effective_vpc_id

  tags = {
    Name      = "${var.cluster_name}-istio-public-gateway"
    ManagedBy = "terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_gateway_https" {
  count = var.gateways_enabled ? 1 : 0

  security_group_id = aws_security_group.public_gateway[0].id
  description       = "HTTPS from internet"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.cluster_name}-istio-public-https"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_gateway_health_check" {
  count = var.gateways_enabled && var.health_check_rules_enabled ? 1 : 0

  security_group_id = aws_security_group.public_gateway[0].id
  description       = "Istio health check from VPC only"
  from_port         = 15021
  to_port           = 15021
  ip_protocol       = "tcp"
  cidr_ipv4         = local.effective_network_cidr

  tags = {
    Name = "${var.cluster_name}-istio-public-health-check"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_gateway_health_check_additional" {
  for_each = var.gateways_enabled && var.health_check_rules_enabled ? toset(var.additional_network_cidrs) : toset([])

  security_group_id = aws_security_group.public_gateway[0].id
  description       = "Istio health check from additional CIDR"
  from_port         = 15021
  to_port           = 15021
  ip_protocol       = "tcp"
  cidr_ipv4         = each.value

  tags = {
    Name = "${var.cluster_name}-istio-public-health-check-additional"
  }
}

resource "aws_vpc_security_group_egress_rule" "public_gateway_all" {
  count = var.gateways_enabled ? 1 : 0

  security_group_id = aws_security_group.public_gateway[0].id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.cluster_name}-istio-public-egress"
  }
}

###############################################################################
# PRIVATE GATEWAY
###############################################################################

# Security Group for Private/Internal Gateway (AWS/EKS)
# - Port 443 (HTTPS): Restricted to VPC CIDR only
# - Port 15021 (Health Check): Restricted to VPC CIDR only
resource "aws_security_group" "private_gateway" {
  count = var.gateway_internal_enabled ? 1 : 0

  name        = "${var.cluster_name}-istio-private-gateway"
  description = "Security group for Istio private gateway - All traffic restricted to VPC"
  vpc_id      = local.effective_vpc_id

  tags = {
    Name      = "${var.cluster_name}-istio-private-gateway"
    ManagedBy = "terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_gateway_https" {
  count = var.gateway_internal_enabled ? 1 : 0

  security_group_id = aws_security_group.private_gateway[0].id
  description       = "HTTPS from VPC only"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = local.effective_network_cidr

  tags = {
    Name = "${var.cluster_name}-istio-private-https"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_gateway_health_check" {
  count = var.gateway_internal_enabled && var.health_check_rules_enabled ? 1 : 0

  security_group_id = aws_security_group.private_gateway[0].id
  description       = "Istio health check from VPC only"
  from_port         = 15021
  to_port           = 15021
  ip_protocol       = "tcp"
  cidr_ipv4         = local.effective_network_cidr

  tags = {
    Name = "${var.cluster_name}-istio-private-health-check"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_gateway_https_additional" {
  for_each = var.gateway_internal_enabled ? toset(var.additional_network_cidrs) : toset([])

  security_group_id = aws_security_group.private_gateway[0].id
  description       = "HTTPS from additional CIDR"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = each.value

  tags = {
    Name = "${var.cluster_name}-istio-private-https-additional"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_gateway_health_check_additional" {
  for_each = var.gateway_internal_enabled && var.health_check_rules_enabled ? toset(var.additional_network_cidrs) : toset([])

  security_group_id = aws_security_group.private_gateway[0].id
  description       = "Istio health check from additional CIDR"
  from_port         = 15021
  to_port           = 15021
  ip_protocol       = "tcp"
  cidr_ipv4         = each.value

  tags = {
    Name = "${var.cluster_name}-istio-private-health-check-additional"
  }
}

###############################################################################
# CLUSTER SG RULES
# When cluster_security_group_id is provided, allow traffic from the gateway
# SGs to the cluster SG on the gateway port and health check port.
# This is required for ALB setups where the ALB uses the gateway SGs and
# needs to reach pods running in the cluster.
###############################################################################

resource "aws_vpc_security_group_ingress_rule" "cluster_from_public_gateway_traffic" {
  count = var.gateways_enabled && var.cluster_name != "" ? 1 : 0

  security_group_id            = local.effective_cluster_security_group_id
  description                  = "Traffic from public ALB to Istio gateway"
  from_port                    = var.gateway_port
  to_port                      = var.gateway_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.public_gateway[0].id

  tags = {
    Name = "${var.cluster_name}-cluster-from-public-alb-traffic"
  }
}

resource "aws_vpc_security_group_ingress_rule" "cluster_from_public_gateway_health" {
  count = var.gateways_enabled && var.cluster_name != "" ? 1 : 0

  security_group_id            = local.effective_cluster_security_group_id
  description                  = "Health check from public ALB to Istio gateway"
  from_port                    = 15021
  to_port                      = 15021
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.public_gateway[0].id

  tags = {
    Name = "${var.cluster_name}-cluster-from-public-alb-health"
  }
}

resource "aws_vpc_security_group_ingress_rule" "cluster_from_private_gateway_traffic" {
  count = var.gateway_internal_enabled && var.cluster_name != "" ? 1 : 0

  security_group_id            = local.effective_cluster_security_group_id
  description                  = "Traffic from private ALB to Istio gateway"
  from_port                    = var.gateway_port
  to_port                      = var.gateway_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.private_gateway[0].id

  tags = {
    Name = "${var.cluster_name}-cluster-from-private-alb-traffic"
  }
}

resource "aws_vpc_security_group_ingress_rule" "cluster_from_private_gateway_health" {
  count = var.gateway_internal_enabled && var.cluster_name != "" ? 1 : 0

  security_group_id            = local.effective_cluster_security_group_id
  description                  = "Health check from private ALB to Istio gateway"
  from_port                    = 15021
  to_port                      = 15021
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.private_gateway[0].id

  tags = {
    Name = "${var.cluster_name}-cluster-from-private-alb-health"
  }
}

resource "aws_vpc_security_group_egress_rule" "private_gateway_all" {
  count = var.gateway_internal_enabled ? 1 : 0

  security_group_id = aws_security_group.private_gateway[0].id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.cluster_name}-istio-private-egress"
  }
}
