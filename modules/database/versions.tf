##############################################################################
# Provider Version Constraints
# Pin these to prevent unexpected upgrades in CI/CD.
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
