resource "oci_objectstorage_bucket" "tofu_state" {
  compartment_id = var.compartment_id
  name           = var.bucket_name
  namespace      = var.namespace

  access_type  = var.access_type
  storage_tier = var.storage_tier
  versioning   = var.versioning

  freeform_tags = merge(
    {
      "Purpose"   = "tofu-state"
      "ManagedBy" = "opentofu"
    },
    var.tags
  )
}
