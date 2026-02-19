data "terraform_remote_state" "infrastructure" {
  backend = "s3"
  config = {
    bucket  = var.backend_bucket
    key     = "infrastructure/terraform.tfstate"
    region  = var.aws_region
    profile = var.aws_profile
  }
}

data "terraform_remote_state" "nullplatform" {
  backend = "s3"
  config = {
    bucket  = var.backend_bucket
    key     = "nullplatform/terraform.tfstate"
    region  = var.aws_region
    profile = var.aws_profile
  }
}
