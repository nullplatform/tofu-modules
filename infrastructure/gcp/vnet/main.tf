module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id   = var.project_id
  network_name = var.vpc_name

  subnets = [
    for s in var.subnets_definition : {
      subnet_name           = s.name
      subnet_ip             = s.address_prefix
      subnet_region         = s.location
      subnet_private_access = true
    }
  ]

  secondary_ranges = var.secondary_ranges
}
