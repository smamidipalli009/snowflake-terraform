output "database_name" {
  description = "Name of the created database"
  value       = snowflake_database.this.name
}

output "database_id" {
  description = "ID of the created database"
  value       = snowflake_database.this.id
}
