module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "${var.organization}-${var.account}"
  cidr = var.vpc.cidr_block

  enable_dns_hostnames = true

  azs             = var.vpc.azs
  private_subnets = var.vpc.private_subnets
  public_subnets  = var.vpc.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  map_public_ip_on_launch = false

  # Uncomment to block all inbound traffic from the Internet Gateway
  # vpc_block_public_access_options = {
  #   internet_gateway_block_mode = "block-ingress"
  # }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}
