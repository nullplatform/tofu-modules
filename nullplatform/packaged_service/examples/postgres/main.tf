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

# PACKAGE the service + link into a versioned package.
module "packaged_service" {
  source = "../../"

  nrn = local.nrn

  service_specification = nullplatform_service_specification.managed_postgre_sql_non_prod_service
  link_specification    = nullplatform_link_specification.managed_postgre_sql_non_prod_link

  package_version = "0.0.1"     # your imagined `version`
  alias           = { default = "0.0.1" }
  artifacts       = []
}

output "package_id" {
  value = module.packaged_service.package_id
}
output "package_default_version" {
  value = module.packaged_service.default_version
}
