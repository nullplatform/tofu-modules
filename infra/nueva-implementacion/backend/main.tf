# =============================================================================
# Backend - S3 for Terraform State
# =============================================================================
module "backend" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/backend?ref=v1.34.0"
}
