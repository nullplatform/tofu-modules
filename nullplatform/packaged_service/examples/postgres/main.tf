################################################################################
# Example: package a sample PostgreSQL database dependency service + its link as
# a versioned nullplatform package. The specs below are a generic sample — swap
# in your own service_specification / link_specification.
################################################################################

terraform {
  required_providers {
    nullplatform = { source = "nullplatform/nullplatform" }
  }
}

variable "np_api_key" {
  type      = string
  sensitive = true
}

variable "nrn" {
  description = "Owner NRN — organization=…:account=…:namespace=… the package lives in."
  type        = string
}

provider "nullplatform" {
  api_key = var.np_api_key
}

locals {
  nrn = var.nrn
}

# SERVICE SPECIFICATION — a sample managed PostgreSQL dependency.
resource "nullplatform_service_specification" "postgres_service" {
  name                = "Sample PostgreSQL Database"
  type                = "dependency"
  assignable_to       = "dimension"
  use_default_actions = true

  visible_to = [local.nrn]

  dimensions = jsonencode({
    "region" : { "required" : true },
    "environment" : {
      "values" : ["dev", "stg", "prod"],
      "required" : true
    }
  })

  attributes = jsonencode({
    "values" : {},
    "schema" : {
      "type" : "object",
      "required" : ["size"],
      "properties" : {
        "region" : { "type" : "string", "config" : { "key" : "aws.region" }, "readOnly" : true, "visibleOn" : [] },
        "size" : {
          "enum" : ["small", "medium", "large"],
          "type" : "string", "order" : 1, "title" : "Instance size", "default" : "small",
          "description" : "small: 1 vCPU / 2 GB · medium: 2 vCPU / 8 GB · large: 4 vCPU / 16 GB"
        },
        "engine_version" : { "type" : "string", "order" : 2, "title" : "Engine version", "default" : "16", "description" : "PostgreSQL major version." },
        "db_host" : { "type" : "string", "export" : { "secret" : false, "target" : "DB_HOST" }, "readOnly" : true, "visibleOn" : [] },
        "db_port" : { "type" : "string", "export" : { "secret" : false, "target" : "DB_PORT" }, "readOnly" : true, "visibleOn" : [] },
        "db_name" : { "type" : "string", "export" : { "secret" : false, "target" : "DB_NAME" }, "readOnly" : true, "visibleOn" : [] },
        "db_username" : { "type" : "string", "export" : { "secret" : false, "target" : "DB_USERNAME" }, "readOnly" : true, "visibleOn" : [] },
        "db_password" : { "type" : "string", "export" : { "secret" : true, "target" : "DB_PASSWORD" }, "readOnly" : true, "visibleOn" : [] }
      },
      "additionalProperties" : false,
      "uiSchema" : {}
    }
  })

  selectors {
    category     = "Database"
    imported     = false
    provider     = "AWS"
    sub_category = "SQL Database"
  }
}

# LINK SPECIFICATION — how a service consumes the database above.
resource "nullplatform_link_specification" "postgres_link" {
  name                = "Sample PostgreSQL Database Link"
  specification_id    = nullplatform_service_specification.postgres_service.id
  use_default_actions = true
  unique              = false

  visible_to = [local.nrn]

  attributes = jsonencode({
    "values" : {},
    "schema" : {
      "type" : "object",
      "required" : [],
      "properties" : {},
      "additionalProperties" : false,
      "uiSchema" : {}
    }
  })

  selectors {
    category     = "Database"
    imported     = false
    provider     = "AWS"
    sub_category = "PostgreSQL"
  }
}

# ── Package the service + link as a versioned package ────────────────────────
# ONE package revision whose bill of materials mirrors nullplatform_package: the
# service spec (root), the link spec under it, the default actions of both
# (pinned automatically), plus any artifacts. Consumers bind to an immutable
# version instead of the live specs.
module "packaged_service" {
  # For this example, the module in this repo. In real use, pin a released ref:
  #   source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/packaged_service?ref=v1.0.0"
  source = "../../"

  nrn = local.nrn

  # The bill of materials, one flat list. Pass whole resources — the module reads
  # each one's id + snapshot itself and expands every spec's default actions as
  # children. `parent_resource` places a component under another (link → service).
  components = [
    {
      type     = "service_specification"
      resource = nullplatform_service_specification.postgres_service
    },
    {
      type            = "link_specification"
      resource        = nullplatform_link_specification.postgres_link
      parent_resource = nullplatform_service_specification.postgres_service
    },
    # A plain service package needs no artifacts. Add one when the package ships
    # an image / git source / blob — registered inline here:
    #   {
    #     type     = "artifact"
    #     resource = {
    #       name = "provisioner"
    #       type = "git_repository"
    #       meta = { url = "https://github.com/org/pg-provisioner", reference = "v1.2.0" }
    #     }
    #   },
  ]

  # How to publish. `version` is nested (not a top-level module arg) because a
  # top-level `version` is reserved by Terraform for registry sources. slug + name
  # default to the service spec's; override here to set them by hand.
  release = {
    version = "0.0.1"
    default = true
    # slug = "sample-postgresql-database"
    # name = "Sample PostgreSQL Database"
  }
}

output "package_id" {
  value = module.packaged_service.package_id
}
output "package_slug" {
  value = module.packaged_service.package_slug
}
output "package_default_version" {
  value = module.packaged_service.default_version
}
