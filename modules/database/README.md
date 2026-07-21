# Snowflake Database Module

Terraform module for creating and managing Snowflake databases with enterprise-grade defaults. Supports Time Travel, replication, tagging, and automatic creation of read/write/admin database roles.

---

## Features

- Creates a Snowflake database with full parameter control
- Creates default database roles: `READ`, `READWRITE`, `ADMIN`
- Associates Snowflake object tags
- Optionally enables cross-region replication
- Input validation on all critical variables
- Compatible with multi-environment deployments (dev / qa / prod)

---

## Usage

### Basic

```hcl
module "raw_database" {
  source  = "git::https://github.com/<YOUR_ORG>/snowflake-terraform.git//modules/database?ref=v1.0.0"

  name    = "RAW"
  comment = "Raw ingestion layer — Bronze"
}
```

### Full Example

```hcl
module "analytics_database" {
  source = "git::https://github.com/<YOUR_ORG>/snowflake-terraform.git//modules/database?ref=v1.0.0"

  name                        = "ANALYTICS"
  comment                     = "Gold layer — curated analytics data"
  data_retention_time_in_days = 7
  is_transient                = false
  create_default_roles        = true

  tags = {
    "GOVERNANCE_DB.PUBLIC.ENVIRONMENT" = "PROD"
    "GOVERNANCE_DB.PUBLIC.TEAM"        = "DATA_PLATFORM"
    "GOVERNANCE_DB.PUBLIC.COST_CENTER" = "ANALYTICS"
  }

  enable_replication           = true
  replication_allowed_accounts = ["myorg.my_secondary_account"]
}
```

---

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Database name (auto-uppercased) | `string` | — | ✅ |
| `comment` | Description of the database | `string` | `""` | no |
| `data_retention_time_in_days` | Time Travel retention days (0–90) | `number` | `1` | no |
| `max_data_extension_time_in_days` | Max extension of data retention | `number` | `14` | no |
| `is_transient` | Create as transient (no Fail-safe) | `bool` | `false` | no |
| `create_default_roles` | Create READ / READWRITE / ADMIN roles | `bool` | `true` | no |
| `tags` | Map of Snowflake tag FQN → value | `map(string)` | `{}` | no |
| `enable_replication` | Enable cross-region replication | `bool` | `false` | no |
| `replication_allowed_accounts` | Accounts allowed to replicate | `list(string)` | `[]` | no |
| `log_level` | Database log level | `string` | `"OFF"` | no |
| `trace_level` | Database trace level | `string` | `"OFF"` | no |

See `variables.tf` for the full list.

---

## Outputs

| Name | Description |
|------|-------------|
| `database_name` | Name of the created database |
| `database_id` | Fully qualified ID |
| `database_fully_qualified_name` | Fully qualified name |
| `read_only_role_name` | Name of the READ role |
| `read_write_role_name` | Name of the READWRITE role |
| `admin_role_name` | Name of the ADMIN role |
| `replication_enabled` | Whether replication is enabled |

---

## Requirements

| Tool | Version |
|------|---------|
| Terraform | >= 1.5.0 |
| Snowflake Provider | ~> 0.90 |

---

## Versioning

This module uses [semantic versioning](https://semver.org/). Always pin to a specific tag in production:

```hcl
source = "git::https://github.com/<YOUR_ORG>/snowflake-terraform.git//modules/database?ref=v1.0.0"
```

---

## Related Modules

- `modules/schema` — Schema management within databases
- `modules/warehouse` — Compute warehouse management  
- `modules/role` — Account-level role management
- `modules/user` — User lifecycle management
