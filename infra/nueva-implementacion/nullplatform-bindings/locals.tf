locals {
  eks_cluster_name         = data.terraform_remote_state.infrastructure.outputs.eks_cluster_name
  public_zone_id           = data.terraform_remote_state.infrastructure.outputs.public_zone_id
  private_zone_id          = data.terraform_remote_state.infrastructure.outputs.private_zone_id
  scope_specification_id   = data.terraform_remote_state.nullplatform.outputs.scope_specification_id
  scope_specification_slug = data.terraform_remote_state.nullplatform.outputs.scope_specification_slug
}
