module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.name
  kubernetes_version = var.kubernetes_version

  create_cloudwatch_log_group = false

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

  eks_managed_node_groups = local.eks_managed_node_groups

  # ==========================================
  #  AUTO MODE
  # ==========================================
  create_auto_mode_iam_resources = var.use_auto_mode ? true : false

  compute_config = var.use_auto_mode ? {
    enabled    = true
    node_pools = var.auto_mode_node_pools
    } : {
    enabled    = false
    node_pools = []
  }
}
