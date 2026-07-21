##############################################################################
# Snowflake Database Module
# Manages Snowflake databases with optional replication, data retention,
# tags, and comment metadata. Designed for enterprise multi-environment use.
##############################################################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.90"
    }
  }
}

##############################################################################
# Database
##############################################################################

resource "snowflake_database" "this" {
  name    = upper(var.name)
  comment = var.comment

  data_retention_time_in_days                 = var.data_retention_time_in_days
  max_data_extension_time_in_days             = var.max_data_extension_time_in_days
  is_transient                                = var.is_transient
  catalog                                     = var.catalog
  default_ddl_collation                       = var.default_ddl_collation
  log_level                                   = var.log_level
  trace_level                                 = var.trace_level
  suspend_task_after_num_failures             = var.suspend_task_after_num_failures
  task_auto_retry_attempts                    = var.task_auto_retry_attempts
  user_task_managed_initial_warehouse_size    = var.user_task_managed_initial_warehouse_size
  user_task_minimum_trigger_interval_in_seconds = var.user_task_minimum_trigger_interval_in_seconds
  user_task_timeout_ms                        = var.user_task_timeout_ms
  quoted_identifiers_ignore_case              = var.quoted_identifiers_ignore_case
  replace_invalid_characters                  = var.replace_invalid_characters
  storage_serialization_policy                = var.storage_serialization_policy
}

##############################################################################
# Database Tags
##############################################################################

resource "snowflake_tag_association" "database_tags" {
  for_each = var.tags

  object_identifiers = [snowflake_database.this.fully_qualified_name]
  object_type        = "DATABASE"
  tag_id             = each.key
  tag_value          = each.value
}

##############################################################################
# Database Replication (Optional)
##############################################################################

resource "snowflake_database_replication_config" "this" {
  count = var.enable_replication ? 1 : 0

  depends_on          = [snowflake_database.this]
  database_name       = snowflake_database.this.name
  ignore_edition_check = var.replication_ignore_edition_check
  allowed_accounts    = var.replication_allowed_accounts
}

##############################################################################
# Database Role — Read Only
##############################################################################

resource "snowflake_database_role" "read_only" {
  count    = var.create_default_roles ? 1 : 0
  database = snowflake_database.this.name
  name     = "${upper(var.name)}_READ"
  comment  = "Read-only access to ${upper(var.name)} database"
}

resource "snowflake_grant_privileges_to_database_role" "read_only_usage" {
  count             = var.create_default_roles ? 1 : 0
  database_role_name = "\"${snowflake_database.this.name}\".\"${snowflake_database_role.read_only[0].name}\""
  privileges        = ["USAGE"]

  on_database = snowflake_database.this.name
}

##############################################################################
# Database Role — Read Write
##############################################################################

resource "snowflake_database_role" "read_write" {
  count    = var.create_default_roles ? 1 : 0
  database = snowflake_database.this.name
  name     = "${upper(var.name)}_READWRITE"
  comment  = "Read-write access to ${upper(var.name)} database"
}

resource "snowflake_grant_privileges_to_database_role" "read_write_usage" {
  count             = var.create_default_roles ? 1 : 0
  database_role_name = "\"${snowflake_database.this.name}\".\"${snowflake_database_role.read_write[0].name}\""
  privileges        = ["USAGE", "CREATE SCHEMA"]

  on_database = snowflake_database.this.name
}

##############################################################################
# Database Role — Admin
##############################################################################

resource "snowflake_database_role" "admin" {
  count    = var.create_default_roles ? 1 : 0
  database = snowflake_database.this.name
  name     = "${upper(var.name)}_ADMIN"
  comment  = "Admin access to ${upper(var.name)} database"
}

resource "snowflake_grant_privileges_to_database_role" "admin_all" {
  count             = var.create_default_roles ? 1 : 0
  database_role_name = "\"${snowflake_database.this.name}\".\"${snowflake_database_role.admin[0].name}\""
  all_privileges    = true

  on_database = snowflake_database.this.name
}
