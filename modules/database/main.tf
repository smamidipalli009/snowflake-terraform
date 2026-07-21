resource "snowflake_database" "this" {
  name                        = upper(var.name)
  comment                     = var.comment
  data_retention_time_in_days = var.data_retention_time_in_days
}
