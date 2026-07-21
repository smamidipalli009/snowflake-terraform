##############################################################################
# Example: Basic Database
# Creates a single database with defaults.
##############################################################################

terraform {
  required_version = ">= 1.5.0"
}

provider "snowflake" {
  account  = var.snowflake_account
  username = var.snowflake_username
  # Authenticate via SNOWFLAKE_PRIVATE_KEY env var or key pair auth
}

module "raw_database" {
  source = "../../"

  name    = "RAW"
  comment = "Raw landing zone for ingestion"
}

##############################################################################
# Outputs
##############################################################################

output "database_name" {
  value = module.raw_database.database_name
}

output "read_only_role" {
  value = module.raw_database.read_only_role_name
}

##############################################################################
# Variables
##############################################################################

variable "snowflake_account" {
  description = "Snowflake account identifier (ORGNAME-ACCOUNTNAME)"
  type        = string
}

variable "snowflake_username" {
  description = "Snowflake username for the service account"
  type        = string
}
