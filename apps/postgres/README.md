# PostgreSQL (Archery + Physical Fitness)

Databases for personal tracking data.

**Status**: Not started

## Purpose

Dedicated (or namespaced) PostgreSQL instances / databases for:

- Archery training logs (scores, sessions, equipment, progress)
- Physical fitness / training data (workouts, body metrics, etc.)

These will serve as the backend for future Flutter mobile apps and any web dashboards.

## Design Considerations

- Use the `local-data` StorageClass for persistent volumes
- Consider a single Postgres with multiple databases vs. separate instances (trade-off between resource usage and isolation)
- Strong secrets management required (Q4)
- Backup strategy will be important (later roadmap item)

## Current Thinking

- Likely deployed via the Bitnami PostgreSQL Helm chart or Zalando Postgres Operator (if we want more advanced features later)
- Managed primarily through Terraform (per Q2 full-reprovisioning decision)

## Next

- Define schema requirements (even high-level) for Archery and Fitness
- Decide single vs. multiple DB instances
- Create the Helm values or Terraform module under `terraform/modules/apps/postgres/`

See the central project document for related decisions (Q2, Q4, Q6, Q7).
