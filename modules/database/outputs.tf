##############################################################################
# Database Outputs
##############################################################################

output "database_name" {
  description = "The name of the created Snowflake database."
  value       = snowflake_database.this.name
}

output "database_id" {
  description = "The fully qualified name (ID) of the created Snowflake database."
  value       = snowflake_database.this.id
}

output "database_fully_qualified_name" {
  description = "The fully qualified name of the database."
  value       = snowflake_database.this.fully_qualified_name
}

##############################################################################
# Database Role Outputs
##############################################################################

output "read_only_role_name" {
  description = "Name of the read-only database role. Null if create_default_roles is false."
  value       = var.create_default_roles ? snowflake_database_role.read_only[0].name : null
}

output "read_write_role_name" {
  description = "Name of the read-write database role. Null if create_default_roles is false."
  value       = var.create_default_roles ? snowflake_database_role.read_write[0].name : null
}

output "admin_role_name" {
  description = "Name of the admin database role. Null if create_default_roles is false."
  value       = var.create_default_roles ? snowflake_database_role.admin[0].name : null
}

##############################################################################
# Replication Outputs
##############################################################################

output "replication_enabled" {
  description = "Whether replication is enabled for this database."
  value       = var.enable_replication
}

output "replication_allowed_accounts" {
  description = "List of accounts allowed to replicate this database."
  value       = var.replication_allowed_accounts
}
