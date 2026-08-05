################################################################################
# Example: package the "Managed PostgreSQL (Non-Prod)" service + link, in the
# lambdasebasn namespace (332024164), as a versioned nullplatform package.
#
# Adapted from the original (org 934477941) example: visible_to repointed to
# this namespace and the import{} blocks dropped (these are created fresh here).
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

provider "nullplatform" {
  api_key = var.np_api_key
}

locals {
  nrn = "organization=1255165411:account=95118862:namespace=332024164"
}

# SERVICE SPECIFICATION
resource "nullplatform_service_specification" "managed_postgre_sql_non_prod_service" {
  name                = "Managed PostgreSQL (Non-Prod) Service"
  type                = "dependency"
  assignable_to       = "dimension"
  use_default_actions = true

  visible_to = [local.nrn]

  dimensions = jsonencode({
    "region" : {
      "required" : true
    },
    "environment" : {
      "values" : ["dev", "stg"],
      "required" : true
    }
  })

  attributes = jsonencode({
    "values" : {},
    "schema" : {
      "type" : "object",
      "required" : ["db_flavor"],
      "properties" : {
        "region" : { "type" : "string", "config" : { "key" : "aws.region" }, "readOnly" : true, "visibleOn" : [] },
        "db_flavor" : {
          "enum" : ["STANDARD", "PERFORMANCE", "HIGH_PERFORMANCE"],
          "type" : "string", "order" : 4, "title" : "Flavor", "default" : "STANDARD",
          "description" : "STANDARD: 1 ACU | PERFORMANCE: 2 ACUs | HIGH_PERFORMANCE: 4 ACUs"
        },
        "price_net" : { "type" : "string", "order" : 3, "title" : "Data Transfer Price", "default" : "U$S 20/TB", "readOnly" : true, "description" : "Cross-AZ transfer cost. Free within same AZ." },
        "account_id" : { "type" : "string", "config" : { "key" : "aws.account_id" }, "readOnly" : true, "visibleOn" : [] },
        "price_data" : { "type" : "string", "order" : 2, "title" : "Storage Price", "default" : "U$S 100/TB", "readOnly" : true, "description" : "Aurora storage cost per terabyte per month" },
        "price_infra" : { "type" : "string", "order" : 1, "title" : "Infrastructure Price", "default" : "U$S 39 to U$S 291", "readOnly" : true, "description" : "Price of the infrastructure per month" },
        "service_name" : { "type" : "string", "default" : "Managed PostgreSQL (non-prod) Service Tester", "readOnly" : true, "visibleOn" : [] },
        "pg_app_password" : { "type" : "string", "export" : { "secret" : false, "target" : "PG_APP_PASSWORD" }, "readOnly" : true, "visibleOn" : [] },
        "pg_app_username" : { "type" : "string", "export" : { "secret" : false, "target" : "PG_APP_USERNAME" }, "readOnly" : true, "visibleOn" : [] },
        "pg_database_name" : { "type" : "string", "export" : { "secret" : false, "target" : "PG_DATABASE_NAME" }, "readOnly" : true, "visibleOn" : [] },
        "pg_app_secret_arn" : { "type" : "string", "export" : { "secret" : true, "target" : "PG_APP_SECRET_ARN" }, "readOnly" : true, "visibleOn" : [] },
        "pg_reader_endpoint" : { "type" : "string", "export" : { "secret" : false, "target" : "PG_READER_ENDPOINT" }, "readOnly" : true, "visibleOn" : [] },
        "pg_writer_endpoint" : { "type" : "string", "export" : { "secret" : false, "target" : "PG_WRITER_ENDPOINT" }, "readOnly" : true, "visibleOn" : [] },
        "pg_migration_password" : { "type" : "string", "export" : { "secret" : false, "target" : "PG_MIGRATION_PASSWORD" }, "readOnly" : true, "visibleOn" : [] },
        "pg_migration_username" : { "type" : "string", "export" : { "secret" : false, "target" : "PG_MIGRATION_USERNAME" }, "readOnly" : true, "visibleOn" : [] },
        "pg_migration_secret_arn" : { "type" : "string", "export" : { "secret" : true, "target" : "PG_MIGRATION_SECRET_ARN" }, "readOnly" : true, "visibleOn" : [] }
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

# LINK SPECIFICATION
resource "nullplatform_link_specification" "managed_postgre_sql_non_prod_link" {
  name                = "Managed PostgreSQL (non-prod) Link"
  specification_id    = nullplatform_service_specification.managed_postgre_sql_non_prod_service.id
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

  # Owner NRN — the org/account/namespace the package (and its artifacts) live in.
  nrn = local.nrn

  # The bill of materials, one flat list. Pass whole resources — the module reads
  # each one's id + snapshot itself and expands every spec's default actions as
  # children. `parent_resource` places a component under another (link → service).
  components = [
    {
      type     = "service_specification"
      resource = nullplatform_service_specification.managed_postgre_sql_non_prod_service
    },
    {
      type            = "link_specification"
      resource        = nullplatform_link_specification.managed_postgre_sql_non_prod_link
      parent_resource = nullplatform_service_specification.managed_postgre_sql_non_prod_service
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
    # slug = "managed-postgres-nonprod"
    # name = "Managed PostgreSQL (Non-Prod)"
  }
}

output "package_id" {
  value = module.packaged_service.package_id
}
output "package_default_version" {
  value = module.packaged_service.default_version
}
