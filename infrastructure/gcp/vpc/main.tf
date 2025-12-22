module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id   = var.project_id
  network_name = var.network_name

  subnets = [
    for s in var.subnets : {
      subnet_name           = s.subnet_name
      subnet_ip             = s.subnet_ip
      subnet_region         = s.subnet_region
      subnet_private_access = true
    }
  ]

  secondary_ranges = var.secondary_ranges
}
