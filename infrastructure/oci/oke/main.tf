module "oke" {
  source  = "oracle-terraform-modules/oke/oci"
  version = "5.3.3"
  providers = {
    oci.home = oci.home
  }

  compartment_id = var.compartment_id
  region         = var.region
  cluster_name   = var.cluster_name

  kubernetes_version = "v1.34.1"

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
  control_plane_nsg_ids             = []

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

  worker_pools = {
    pool_principal = {
      mode             = "node-pool"
      shape            = "VM.Standard.E4.Flex"
      ocpus            = 2
      memory           = 16
      size             = 2
      boot_volume_size = 50
    }
  }

  # ---------------------------------------------------------
  # Bastion & Operator
  # ---------------------------------------------------------
  create_bastion  = false
  create_operator = false
}