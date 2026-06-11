# Ghostfolio

Investment dashboard for stocks, crypto, and portfolio tracking.

**Status**: Not started (planned as one of the first real workloads after scaffolding)

## Why Ghostfolio?

- Self-hosted alternative to commercial portfolio trackers
- Good data model and import capabilities
- Will integrate with the trading bots and the PostgreSQL layer
- Excellent candidate to demonstrate Ingress, persistent storage (`local-data` SC), and secrets handling

## Planned Architecture

- Deployed via Helm (preferred) or Terraform `helm_release`
- PostgreSQL backend (shared with other apps or dedicated instance — see ../postgres/)
- Exposed at `ghostfolio.nuc8-hades.local` (or similar) via Traefik
- Persistent data in a PVC using the `local-data` StorageClass

## Open Items (tied to project decisions)

- Secrets (API keys for brokers, JWT secrets, DB credentials) — see Q4 (leaning Vault)
- Ingress + TLS/DNS approach — see Q5 (leaning internal DNS solution)
- How the trading bots will feed data into it

## Next Steps for This App

1. Research current Ghostfolio Helm chart (or official Docker + compose → k8s conversion).
2. Create initial `helm/apps/ghostfolio/values.yaml` or Terraform module.
3. Document exact apply steps here and in `docs/apply.md`.
4. Add a basic PostgreSQL dependency or point to the shared DB.

See root [NUC8-Hades-Homelab-Project.md](../../NUC8-Hades-Homelab-Project.md) for overall priorities and decisions.
