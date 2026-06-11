# Known Good Versions & Constraints

Per **Q7 Decision (Option B)**: We document "current known good" versions here rather than over-pinning early.

Update this file whenever the running versions on the NUC change or when we validate a new combination.

## Base Infrastructure (as of 2026-06-11)

| Component          | Version / Details                  | Notes |
|--------------------|------------------------------------|-------|
| Ubuntu             | 26.04 LTS Server                   | - |
| K3s                | (to be recorded from `kubectl version`) | Current running version |
| Traefik (via K3s)  | (from K3s)                         | - |
| AWX                | (record exact version from UI or `awx --version`) | - |
| Storage            | Local NVMe + custom `local-data` StorageClass | - |

## Terraform

| Provider / Tool    | Version Constraint (in code)      | Known Good | Last Validated |
|--------------------|-----------------------------------|------------|----------------|
| Terraform          | >= 1.5.0                          | -          | 2026-06-11 (scaffold) |
| kubernetes         | (to be set)                       | -          | - |
| helm               | (to be set)                       | -          | - |
| awx (provider)     | TBD - research needed (Q8)        | -          | - |

## Applications (when deployed)

| App                | Chart / Image Version | Helm / TF values file | Notes |
|--------------------|-----------------------|-----------------------|-------|
| Ghostfolio         | -                     | -                     | Not deployed yet |
| PostgreSQL         | -                     | -                     | Not deployed yet |

## How to Record a New "Known Good"

1. Run the validation / apply on the NUC.
2. Note the exact versions (`kubectl version --short`, `helm list`, AWX version, `terraform providers`, etc.).
3. Update this table + the date.
4. Consider whether this is a good point to add stricter version pins in `terraform/versions.tf`.

See the main [NUC8-Hades-Homelab-Project.md](../NUC8-Hades-Homelab-Project.md) for the full Q7 decision and context.
