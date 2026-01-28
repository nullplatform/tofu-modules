# ---------------------------------------------------------
# OCIR (Oracle Container Image Registry) Access Policies
# ---------------------------------------------------------
# This creates IAM policies that allow:
# 1. OKE worker nodes (instances) to pull images from OCIR via Instance Principal
# 2. OKE workloads (pods) to pull images from OCIR via Workload Identity
#
# For Instance Principal image pulls, we use the OKE Credential Provider:
# https://github.com/oracle-devrel/oke-credential-provider-for-ocir

locals {
  # Validate tenancy_id is provided when enable_ocir_pull is true
  validate_tenancy_id = var.enable_ocir_pull && var.tenancy_id == null ? tobool("tenancy_id is required when enable_ocir_pull is true") : true

  # Build policy statements for workload identity (pods)
  ocir_workload_policy_statements = var.enable_ocir_pull ? (
    length(var.ocir_pull_namespaces) > 0
    ? [for ns in var.ocir_pull_namespaces :
      "Allow any-user to read repos in tenancy where all {request.principal.type = 'workload', request.principal.namespace = '${ns}', request.principal.cluster_id = '${module.oke.cluster_id}'}"
    ]
    : ["Allow any-user to read repos in tenancy where all {request.principal.type = 'workload', request.principal.cluster_id = '${module.oke.cluster_id}'}"]
  ) : []

  # Policy statement for worker nodes (instances) to pull images using Dynamic Group
  ocir_nodes_policy_statements = var.enable_ocir_pull ? [
    "Allow dynamic-group ${var.cluster_name}-ocir-nodes to read repos in tenancy"
  ] : []

  # Cloud-init script for OCIR credential provider
  # This enables kubelet to pull private images from OCIR using Instance Principal
  # Based on: https://github.com/oracle-devrel/oke-credential-provider-for-ocir
  #
  # IMPORTANT: When enable_ocir_pull=true, we disable the default OKE cloud-init
  # and use this script which runs oke-init.sh with kubelet-extra-args for the credential provider
  ocir_credential_provider_cloud_init = var.enable_ocir_pull ? {
    content_type = "text/x-shellscript"
    content      = <<-EOT
#!/bin/bash
set -ex

# Get OKE init script from metadata service
curl --fail -H "Authorization: Bearer Oracle" -L0 \
  http://169.254.169.254/opc/v2/instance/metadata/oke_init_script | base64 --decode > /var/run/oke-init.sh

# Create kubernetes config directory if it doesn't exist
mkdir -p /etc/kubernetes

# Download OCIR credential provider binary using curl (wget may not be available)
curl -fsSL -o /usr/local/bin/credential-provider-oke \
  https://github.com/oracle-devrel/oke-credential-provider-for-ocir/releases/latest/download/oke-credential-provider-for-ocir-linux-amd64

# Download credential provider config
curl -fsSL -o /etc/kubernetes/credential-provider-config.yaml \
  https://github.com/oracle-devrel/oke-credential-provider-for-ocir/releases/latest/download/credential-provider-config.yaml

# Make binary executable
chmod 755 /usr/local/bin/credential-provider-oke

# Run OKE init script with kubelet extra args for credential provider
bash /var/run/oke-init.sh --kubelet-extra-args "--image-credential-provider-bin-dir=/usr/local/bin/ --image-credential-provider-config=/etc/kubernetes/credential-provider-config.yaml"
    EOT
  } : null
}

# Policy for OKE workloads (pods) - Workload Identity
resource "oci_identity_policy" "ocir_workload_identity" {
  count          = var.enable_ocir_pull ? 1 : 0
  provider       = oci.home
  compartment_id = var.tenancy_id
  name           = "${var.cluster_name}-ocir-workload-identity"
  description    = "Allow OKE workloads in cluster ${var.cluster_name} to pull images from OCIR"
  statements     = local.ocir_workload_policy_statements

  lifecycle {
    ignore_changes = [defined_tags, freeform_tags]
  }
}

# Dynamic Group for OKE worker nodes - Required for Instance Principal authentication
resource "oci_identity_dynamic_group" "ocir_nodes" {
  count          = var.enable_ocir_pull ? 1 : 0
  provider       = oci.home
  compartment_id = var.tenancy_id
  name           = "${var.cluster_name}-ocir-nodes"
  description    = "Dynamic group for OKE worker nodes in cluster ${var.cluster_name} to pull images from OCIR"
  matching_rule  = "All {instance.compartment.id = '${var.compartment_id}'}"

  lifecycle {
    ignore_changes = [defined_tags, freeform_tags]
  }
}

# Policy for OKE worker nodes (instances) - Required for image pulls via Instance Principal
resource "oci_identity_policy" "ocir_nodes" {
  count          = var.enable_ocir_pull ? 1 : 0
  provider       = oci.home
  compartment_id = var.tenancy_id
  name           = "${var.cluster_name}-ocir-nodes"
  description    = "Allow OKE worker nodes in cluster ${var.cluster_name} to pull images from OCIR"
  statements     = local.ocir_nodes_policy_statements

  depends_on = [oci_identity_dynamic_group.ocir_nodes]

  lifecycle {
    ignore_changes = [defined_tags, freeform_tags]
  }
}
