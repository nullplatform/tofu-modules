#tfsec:ignore:aws-eks-no-public-cluster-access-to-cidr
#tfsec:ignore:aws-eks-no-public-cluster-access
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 21.14, < 22.0"

  name               = var.name
  kubernetes_version = var.kubernetes_version

  create_cloudwatch_log_group            = var.create_cloudwatch_log_group
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
  enabled_log_types                      = var.enabled_log_types
  encryption_config                      = var.encryption_config
  # Derive `create_kms_key` from `encryption_config.provider_key_arn`:
  #   - When the operator passes a CMK ARN, force `create_kms_key = false` so
  #     the upstream module uses the supplied ARN. (Otherwise upstream's
  #     default `create_kms_key = true` would silently override the operator's
  #     ARN with an auto-generated key — defeating the BYO-CMK use case.)
  #   - When the operator does not pass a CMK ARN (default `{}`), leave
  #     `create_kms_key = true` to match the upstream default and preserve
  #     the wrapper's pre-existing behavior (an auto-managed KMS key is
  #     created, encrypting etcd secrets out of the box).
  # `var.encryption_config` is `nullable = false` so this expression is
  # null-safe (consumers cannot pass an explicit `null`).
  create_kms_key             = var.encryption_config.provider_key_arn == null
  create_node_security_group = false

  # Security group rules for NLB health checks and Istio gateway traffic
  security_group_additional_rules = var.security_group_additional_rules ? {
    ingress_nlb_health_check = {
      description = "Allow NLB health checks (Istio status port)"
      protocol    = "tcp"
      from_port   = 15021
      to_port     = 15021
      type        = "ingress"
      cidr_blocks = concat([data.aws_vpc.this.cidr_block], var.additional_network_cidrs)
    }
    ingress_nlb_https = {
      description = "Allow HTTPS traffic from NLB"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = concat([data.aws_vpc.this.cidr_block], var.additional_network_cidrs)
    }
  } : {}

  addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = aws_iam_role.ebs_csi_driver.arn
    }
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

  endpoint_public_access       = var.endpoint_public_access
  endpoint_private_access      = var.endpoint_private_access
  endpoint_public_access_cidrs = var.endpoint_public_access_cidrs

  authentication_mode = var.authentication_mode

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
