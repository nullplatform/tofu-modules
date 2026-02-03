module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 21.14, < 22.0"

  name               = var.name
  kubernetes_version = var.kubernetes_version

  create_cloudwatch_log_group = false
  create_node_security_group  = false

  # Security group rules for NLB health checks and Istio gateway traffic
  security_group_additional_rules = var.vpc_cidr != null ? {
    ingress_nlb_health_check = {
      description = "Allow NLB health checks (Istio status port)"
      protocol    = "tcp"
      from_port   = 15021
      to_port     = 15021
      type        = "ingress"
      cidr_blocks = [var.vpc_cidr]
    }
    ingress_nlb_https = {
      description = "Allow HTTPS traffic from NLB"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = [var.vpc_cidr]
    }
  } : {}

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  access_entries = var.access_entries
  enable_irsa    = true
  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = var.aws_vpc_vpc_id
  subnet_ids               = var.aws_subnets_private_ids
  control_plane_subnet_ids = var.aws_subnets_private_ids

  # EKS Managed Node Group(s)
  eks_managed_node_groups = var.use_auto_mode ? {} : {
    nullplatform = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = var.ami_type
      instance_types = [var.instance_types]

      min_size                              = var.node_group_min_size
      max_size                              = var.node_group_max_size
      desired_size                          = var.node_group_desired_size
      attach_cluster_primary_security_group = var.attach_cluster_primary_security_group
    }
  }
  # ==========================================
  #  AUTO MODE
  # ==========================================
  create_auto_mode_iam_resources = var.use_auto_mode ? true : false

  compute_config = var.use_auto_mode ? {
    enabled    = true
    node_pools = var.auto_mode_node_pools
  } : null
}
