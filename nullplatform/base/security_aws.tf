###############################################################################
# AWS SECURITY GROUPS FOR ISTIO GATEWAYS
# These security groups restrict the health check port (15021) to VPC CIDR
# while allowing HTTPS (443) traffic as needed.
###############################################################################

locals {
  create_aws_security = var.gateway_security_enabled && var.k8s_provider == "eks"
}

###############################################################################
# DATA SOURCES - Derive VPC and CIDR from cluster name
###############################################################################

# Get EKS cluster info to derive VPC ID
data "aws_eks_cluster" "this" {
  count = local.create_aws_security ? 1 : 0
  name  = var.cluster_name

  lifecycle {
    precondition {
      condition     = var.cluster_name != ""
      error_message = "cluster_name is required when gateway_security_enabled is true and k8s_provider is 'eks'."
    }
  }
}

# Get VPC info to derive CIDR block
data "aws_vpc" "this" {
  count = local.create_aws_security ? 1 : 0
  id    = data.aws_eks_cluster.this[0].vpc_config[0].vpc_id
}

locals {
  # Derived values from data sources
  aws_vpc_id   = local.create_aws_security ? data.aws_vpc.this[0].id : ""
  aws_vpc_cidr = local.create_aws_security ? data.aws_vpc.this[0].cidr_block : ""

  # Use override if provided, otherwise use derived value
  effective_aws_vpc_id       = var.vpc_id != "" ? var.vpc_id : local.aws_vpc_id
  effective_aws_network_cidr = var.network_cidr != "" ? var.network_cidr : local.aws_vpc_cidr
}

# Security Group for Public Gateway (AWS/EKS)
# - Port 443 (HTTPS): Open to internet (0.0.0.0/0)
# - Port 15021 (Health Check): Restricted to VPC CIDR only
resource "aws_security_group" "public_gateway" {
  count = local.create_aws_security && var.gateways_enabled ? 1 : 0

  name        = "${var.cluster_name}-istio-public-gateway"
  description = "Security group for Istio public gateway - HTTPS open, health check restricted to VPC"
  vpc_id      = local.effective_aws_vpc_id

  tags = {
    Name      = "${var.cluster_name}-istio-public-gateway"
    ManagedBy = "terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_gateway_https" {
  count = local.create_aws_security && var.gateways_enabled ? 1 : 0

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
  count = local.create_aws_security && var.gateways_enabled ? 1 : 0

  security_group_id = aws_security_group.public_gateway[0].id
  description       = "Istio health check from VPC only"
  from_port         = 15021
  to_port           = 15021
  ip_protocol       = "tcp"
  cidr_ipv4         = local.effective_aws_network_cidr

  tags = {
    Name = "${var.cluster_name}-istio-public-health-check"
  }
}

resource "aws_vpc_security_group_egress_rule" "public_gateway_all" {
  count = local.create_aws_security && var.gateways_enabled ? 1 : 0

  security_group_id = aws_security_group.public_gateway[0].id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.cluster_name}-istio-public-egress"
  }
}

# Security Group for Private/Internal Gateway (AWS/EKS)
# - Port 443 (HTTPS): Restricted to VPC CIDR only
# - Port 15021 (Health Check): Restricted to VPC CIDR only
resource "aws_security_group" "private_gateway" {
  count = local.create_aws_security && var.gateway_internal_enabled ? 1 : 0

  name        = "${var.cluster_name}-istio-private-gateway"
  description = "Security group for Istio private gateway - All traffic restricted to VPC"
  vpc_id      = local.effective_aws_vpc_id

  tags = {
    Name      = "${var.cluster_name}-istio-private-gateway"
    ManagedBy = "terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_gateway_https" {
  count = local.create_aws_security && var.gateway_internal_enabled ? 1 : 0

  security_group_id = aws_security_group.private_gateway[0].id
  description       = "HTTPS from VPC only"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = local.effective_aws_network_cidr

  tags = {
    Name = "${var.cluster_name}-istio-private-https"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_gateway_health_check" {
  count = local.create_aws_security && var.gateway_internal_enabled ? 1 : 0

  security_group_id = aws_security_group.private_gateway[0].id
  description       = "Istio health check from VPC only"
  from_port         = 15021
  to_port           = 15021
  ip_protocol       = "tcp"
  cidr_ipv4         = local.effective_aws_network_cidr

  tags = {
    Name = "${var.cluster_name}-istio-private-health-check"
  }
}

resource "aws_vpc_security_group_egress_rule" "private_gateway_all" {
  count = local.create_aws_security && var.gateway_internal_enabled ? 1 : 0

  security_group_id = aws_security_group.private_gateway[0].id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.cluster_name}-istio-private-egress"
  }
}
