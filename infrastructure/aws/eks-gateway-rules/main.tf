###############################################################################
# EKS GATEWAY RULES
# Creates ingress rules on the EKS cluster primary security group to allow
# traffic from Istio gateway security groups (public and/or private).
#
# Use this module alongside infrastructure/aws/security to connect ALB gateway
# SGs to the cluster SG without triggering plan-time evaluation errors.
# Call this module AFTER both the EKS cluster and the security module exist.
###############################################################################

resource "aws_vpc_security_group_ingress_rule" "cluster_from_public_gateway_traffic" {
  count = var.gateways_enabled ? 1 : 0

  security_group_id            = var.cluster_security_group_id
  description                  = "Traffic from public ALB to Istio gateway"
  from_port                    = var.gateway_port
  to_port                      = var.gateway_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.public_gateway_security_group_id

  tags = {
    Name = "${var.name}-cluster-from-public-alb-traffic"
  }
}

resource "aws_vpc_security_group_ingress_rule" "cluster_from_public_gateway_health" {
  count = var.gateways_enabled ? 1 : 0

  security_group_id            = var.cluster_security_group_id
  description                  = "Health check from public ALB to Istio gateway"
  from_port                    = 15021
  to_port                      = 15021
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.public_gateway_security_group_id

  tags = {
    Name = "${var.name}-cluster-from-public-alb-health"
  }
}

resource "aws_vpc_security_group_ingress_rule" "cluster_from_private_gateway_traffic" {
  count = var.gateway_internal_enabled ? 1 : 0

  security_group_id            = var.cluster_security_group_id
  description                  = "Traffic from private ALB to Istio gateway"
  from_port                    = var.gateway_port
  to_port                      = var.gateway_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.private_gateway_security_group_id

  tags = {
    Name = "${var.name}-cluster-from-private-alb-traffic"
  }
}

resource "aws_vpc_security_group_ingress_rule" "cluster_from_private_gateway_health" {
  count = var.gateway_internal_enabled ? 1 : 0

  security_group_id            = var.cluster_security_group_id
  description                  = "Health check from private ALB to Istio gateway"
  from_port                    = 15021
  to_port                      = 15021
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.private_gateway_security_group_id

  tags = {
    Name = "${var.name}-cluster-from-private-alb-health"
  }
}
