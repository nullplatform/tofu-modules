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

  access_entries = {
    default = {
      user_name         = var.access_entries_user_name
      principal_arn = var.access_entries_principal_arn

      policy_associations = {
        default = {
          policy_arn = var.policy_associations_default_policy_arn
          access_scope = {}
        }
      }
    }
  }

# Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = var.aws_vpc_vpc_id
  subnet_ids               = var.aws_subnets_private_ids
  control_plane_subnet_ids = var.aws_subnets_private_ids

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    nullplatform = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = var.ami_type
      instance_types = [var.instance_types]

      min_size     = 2
      max_size     = 10
      desired_size = 2
    }
  }
}