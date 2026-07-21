##############################################################################
# Required Variables
##############################################################################

variable "name" {
  description = "The name of the Snowflake database. Will be uppercased automatically."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]*$", var.name))
    error_message = "Database name must start with a letter and contain only letters, numbers, and underscores."
  }
}

##############################################################################
# Optional Variables — Core Settings
##############################################################################

variable "comment" {
  description = "A comment/description for the database."
  type        = string
  default     = ""
}

variable "data_retention_time_in_days" {
  description = "Number of days to retain Time Travel data. 0 disables Time Travel (transient behavior). Enterprise edition allows up to 90."
  type        = number
  default     = 1

  validation {
    condition     = var.data_retention_time_in_days >= 0 && var.data_retention_time_in_days <= 90
    error_message = "data_retention_time_in_days must be between 0 and 90."
  }
}

variable "max_data_extension_time_in_days" {
  description = "Maximum number of days Snowflake can extend the data retention period for tables in the database."
  type        = number
  default     = 14
}

variable "is_transient" {
  description = "If true, the database is transient and does not have a Fail-safe period. Cannot be changed after creation."
  type        = bool
  default     = false
}

##############################################################################
# Optional Variables — Advanced Settings
##############################################################################

variable "catalog" {
  description = "The database parameter that specifies the default catalog to use for Iceberg tables."
  type        = string
  default     = null
}

variable "default_ddl_collation" {
  description = "Specifies a default collation specification for all schemas and tables added to the database."
  type        = string
  default     = null
}

variable "log_level" {
  description = "Severity level of messages that should be ingested into the active event table. Valid values: TRACE, DEBUG, INFO, WARN, ERROR, FATAL, OFF."
  type        = string
  default     = "OFF"

  validation {
    condition     = contains(["TRACE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL", "OFF"], var.log_level)
    error_message = "log_level must be one of: TRACE, DEBUG, INFO, WARN, ERROR, FATAL, OFF."
  }
}

variable "trace_level" {
  description = "Controls how trace events are ingested into the event table. Valid values: ALWAYS, ON_EVENT, OFF."
  type        = string
  default     = "OFF"

  validation {
    condition     = contains(["ALWAYS", "ON_EVENT", "OFF"], var.trace_level)
    error_message = "trace_level must be one of: ALWAYS, ON_EVENT, OFF."
  }
}

variable "suspend_task_after_num_failures" {
  description = "How many times a task must fail in a row before it is automatically suspended."
  type        = number
  default     = 10
}

variable "task_auto_retry_attempts" {
  description = "Maximum automatic retries allowed for user tasks in the database."
  type        = number
  default     = 0
}

variable "user_task_managed_initial_warehouse_size" {
  description = "The initial size of the warehouse for serverless tasks."
  type        = string
  default     = "Medium"
}

variable "user_task_minimum_trigger_interval_in_seconds" {
  description = "Minimum amount of time between trigger events for a continuous task."
  type        = number
  default     = 30
}

variable "user_task_timeout_ms" {
  description = "Time limit for a single run of a user task, in milliseconds."
  type        = number
  default     = 3600000
}

variable "quoted_identifiers_ignore_case" {
  description = "If true, the case of quoted identifiers is ignored."
  type        = bool
  default     = false
}

variable "replace_invalid_characters" {
  description = "Specifies whether to replace invalid UTF-8 characters with the Unicode replacement character."
  type        = bool
  default     = false
}

variable "storage_serialization_policy" {
  description = "Storage serialization policy for Iceberg tables. Valid values: COMPATIBLE, OPTIMIZED."
  type        = string
  default     = "OPTIMIZED"

  validation {
    condition     = contains(["COMPATIBLE", "OPTIMIZED"], var.storage_serialization_policy)
    error_message = "storage_serialization_policy must be one of: COMPATIBLE, OPTIMIZED."
  }
}

##############################################################################
# Optional Variables — Tags
##############################################################################

variable "tags" {
  description = "Map of Snowflake tag fully qualified names to tag values to associate with the database. Key format: 'DATABASE.SCHEMA.TAG_NAME'."
  type        = map(string)
  default     = {}
}

##############################################################################
# Optional Variables — Replication
##############################################################################

variable "enable_replication" {
  description = "Whether to enable cross-region replication for the database."
  type        = bool
  default     = false
}

variable "replication_allowed_accounts" {
  description = "List of account identifiers (ORGNAME.ACCOUNT_NAME format) allowed to create replicas."
  type        = list(string)
  default     = []
}

variable "replication_ignore_edition_check" {
  description = "If true, bypasses the Snowflake edition check when enabling replication."
  type        = bool
  default     = true
}

##############################################################################
# Optional Variables — Default Roles
##############################################################################

variable "create_default_roles" {
  description = "If true, creates READ, READWRITE, and ADMIN database roles with appropriate privileges."
  type        = bool
  default     = true
}
