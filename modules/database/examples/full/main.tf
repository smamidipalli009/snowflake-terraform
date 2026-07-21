##############################################################################
# Example: Full Database Configuration
# Creates three-layer (RAW / STAGING / ANALYTICS) Bronze-Silver-Gold
# databases with replication, tags, and all role options enabled.
##############################################################################

terraform {
  required_version = ">= 1.5.0"
}

provider "snowflake" {
  account  = var.snowflake_account
  username = var.snowflake_username
}

locals {
  env = var.environment # dev | qa | prod

  common_tags = {
    "GOVERNANCE_DB.PUBLIC.ENVIRONMENT" = upper(local.env)
    "GOVERNANCE_DB.PUBLIC.TEAM"        = "DATA_PLATFORM"
    "GOVERNANCE_DB.PUBLIC.MANAGED_BY"  = "TERRAFORM"
  }
}

##############################################################################
# Bronze — Raw / Landing
##############################################################################

module "raw_database" {
  source = "../../"

  name                        = "${upper(local.env)}_RAW"
  comment                     = "Bronze layer — raw ingestion from source systems"
  data_retention_time_in_days = local.env == "prod" ? 7 : 1
  create_default_roles        = true
  tags                        = merge(local.common_tags, {
    "GOVERNANCE_DB.PUBLIC.LAYER" = "BRONZE"
  })
}

##############################################################################
# Silver — Staging / Cleansed
##############################################################################

module "staging_database" {
  source = "../../"

  name                        = "${upper(local.env)}_STAGING"
  comment                     = "Silver layer — cleansed and conformed data"
  data_retention_time_in_days = local.env == "prod" ? 7 : 1
  create_default_roles        = true
  tags                        = merge(local.common_tags, {
    "GOVERNANCE_DB.PUBLIC.LAYER" = "SILVER"
  })
}

##############################################################################
# Gold — Analytics / Curated
##############################################################################

module "analytics_database" {
  source = "../../"

  name                        = "${upper(local.env)}_ANALYTICS"
  comment                     = "Gold layer — curated data for BI and reporting"
  data_retention_time_in_days = local.env == "prod" ? 14 : 1
  create_default_roles        = true

  # Enable replication only in PROD
  enable_replication           = local.env == "prod"
  replication_allowed_accounts = local.env == "prod" ? var.replication_accounts : []

  tags = merge(local.common_tags, {
    "GOVERNANCE_DB.PUBLIC.LAYER" = "GOLD"
  })
}

##############################################################################
# Outputs
##############################################################################

output "raw_database_name"       { value = module.raw_database.database_name }
output "staging_database_name"   { value = module.staging_database.database_name }
output "analytics_database_name" { value = module.analytics_database.database_name }

output "raw_roles" {
  value = {
    read       = module.raw_database.read_only_role_name
    read_write = module.raw_database.read_write_role_name
    admin      = module.raw_database.admin_role_name
  }
}

##############################################################################
# Variables
##############################################################################

variable "snowflake_account" {
  type = string
}

variable "snowflake_username" {
  type = string
}

variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "environment must be dev, qa, or prod."
  }
}

variable "replication_accounts" {
  type    = list(string)
  default = []
}
