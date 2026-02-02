locals {
  # Combine user cloud-init with OCIR credential provider cloud-init when enabled
  combined_cloud_init = var.enable_ocir_pull ? concat(
    [local.ocir_credential_provider_cloud_init],
    var.worker_cloud_init
  ) : var.worker_cloud_init
}

module "oke" {
  source  = "oracle-terraform-modules/oke/oci"
  version = "5.3.3"

  providers = {
    oci      = oci
    oci.home = oci
  }

  compartment_id = var.compartment_id
  region         = var.region
  cluster_name   = var.cluster_name

  kubernetes_version = "v1.34.1"
  cluster_type       = "enhanced"

  # ---------------------------------------------------------
  # VCN Configuration
  # ---------------------------------------------------------
  create_vcn = false
  vcn_id     = var.existing_vcn_id

  # ---------------------------------------------------------
  # Control Plane / API Endpoint Configuration
  # ---------------------------------------------------------
  control_plane_is_public           = var.control_plane_is_public
  assign_public_ip_to_control_plane = var.assign_public_ip_to_control_plane
  control_plane_nsg_ids             = var.control_plane_nsg_ids

  # Subnets existentes
  subnets = {
    cp = {
      create = "never"
      id     = var.api_endpoint_subnet_id
    }
    workers = {
      create = "never"
      id     = var.node_pool_subnet_id
    }
    pub_lb = {
      create = "never"
      id     = var.service_lb_subnet_id
    }
  }

  cni_type = "flannel"

  # ---------------------------------------------------------
  # WORKER POOLS
  # ---------------------------------------------------------
  worker_pool_mode = "node-pool"
  worker_pool_size = 2

  worker_pools = var.worker_pools

  # When OCIR pull is enabled, we disable default cloud-init and use our own
  # that includes the credential provider setup with kubelet-extra-args
  worker_disable_default_cloud_init = var.enable_ocir_pull
  worker_cloud_init                 = local.combined_cloud_init

  # ---------------------------------------------------------
  # Bastion & Operator
  # ---------------------------------------------------------
  create_bastion  = false
  create_operator = false

  # ---------------------------------------------------------
  # OIDC Configuration (required for Workload Identity)
  # ---------------------------------------------------------
  oidc_discovery_enabled = true

  # ---------------------------------------------------------
  # Output Configuration
  # ---------------------------------------------------------
  output_detail = true
}