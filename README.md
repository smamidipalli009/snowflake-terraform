# snowflake-terraform

> Enterprise Terraform modules for Snowflake — versioned, reusable, CI/CD-ready.

This repository contains the **official Terraform modules** for the Snowflake platform. Modules are independently versioned using Git tags and consumed by the `snowflake-cicd` deployment repository.

---

## Module Catalog

| Module | Status | Description |
|--------|--------|-------------|
| [`modules/database`](modules/database/README.md) | ✅ Stable | Database with Time Travel, replication, tagging, default roles |
| `modules/warehouse` | 🚧 In Progress | Compute warehouses with auto-suspend, resource monitors |
| `modules/schema` | 🔜 Planned | Schemas with managed access and masking policies |
| `modules/role` | 🔜 Planned | Account-level roles and RBAC hierarchy |
| `modules/user` | 🔜 Planned | User lifecycle, key pair auth, default role/warehouse |
| `modules/resource_monitor` | 🔜 Planned | Credit quota alerting per warehouse or account |
| `modules/storage_integration` | 🔜 Planned | S3 / Azure Blob / GCS integrations |
| `modules/network_policy` | 🔜 Planned | IP allowlist / blocklist management |
| `modules/masking_policy` | 🔜 Planned | Dynamic data masking for PII columns |

---

## Consuming a Module

Always pin to a specific tag in production. Never use `main`.

```hcl
module "raw_database" {
  source = "git::https://github.com/<YOUR_ORG>/snowflake-terraform.git//modules/database?ref=v1.0.0"

  name    = "PROD_RAW"
  comment = "Raw ingestion layer"

  data_retention_time_in_days = 7
  create_default_roles        = true
}
```

---

## Versioning Strategy

This repo uses [semantic versioning](https://semver.org/) via Git tags:

| Change | Version bump |
|--------|-------------|
| Bug fix, non-breaking | Patch: `v1.0.0` → `v1.0.1` |
| New variable, new optional feature | Minor: `v1.0.0` → `v1.1.0` |
| Breaking change (variable removed, renamed) | Major: `v1.0.0` → `v2.0.0` |

Tags are created automatically by GitHub Actions on every merge to `main`.

---

## Local Development

### Prerequisites

```bash
# Terraform
brew install terraform

# TFLint
brew install tflint

# Snowflake provider will be downloaded automatically
```

### Validate a module locally

```bash
cd modules/database
terraform init -backend=false
terraform validate
terraform fmt -check
```

### Run TFLint

```bash
tflint --recursive modules/
```

---

## Repository Structure

```
snowflake-terraform/
├── modules/
│   └── database/
│       ├── main.tf          # Resources
│       ├── variables.tf     # Input variables with validation
│       ├── outputs.tf       # Outputs consumed by other modules
│       ├── versions.tf      # Provider and Terraform version pins
│       ├── README.md        # Module documentation
│       └── examples/
│           ├── basic/       # Minimal usage example
│           └── full/        # Multi-DB Bronze/Silver/Gold example
└── .github/
    └── workflows/
        └── module-ci.yml    # Validate → Lint → Auto-tag release
```

---

## CI/CD

| Event | Jobs Run |
|-------|----------|
| PR to `main` | Validate, Format check, TFLint, Example validation |
| Merge to `main` | All of above + Auto-tag + GitHub Release |

---

## Related Repositories

| Repo | Purpose |
|------|---------|
| [`snowflake-cicd`](https://github.com/<YOUR_ORG>/snowflake-cicd) | Consumes these modules to deploy to DEV / QA / PROD |
| `snowflake-monitoring` | Cost, query, and warehouse monitoring automation |
| `snowflake-user-automation` | RBAC and user lifecycle automation |
