# apps/

Application-specific configuration, documentation, and deployment notes for the NUC8-Hades homelab.

## Purpose

Each subdirectory under `apps/` represents one logical application or service group (Ghostfolio, the Archery + Fitness PostgreSQL instances, trading bots, etc.).

Inside each app folder you will typically find:
- `README.md` — purpose, architecture notes, data model (for DBs), access URLs, dependencies
- Configuration (values, env files that are safe to commit, or references to secrets)
- Deployment notes specific to that app
- Any custom scripts or small manifests that don't belong in terraform/k8s/helm

## Current Applications

- [ghostfolio](./ghostfolio/) — Investment dashboard (first target per early roadmap)
- [postgres](./postgres/) — Shared or dedicated PostgreSQL for personal data (Archery training + Physical fitness tracking)
- [trading-bots](./trading-bots/) — Crypto / stock trading automation

## Decisions Context

See the central [NUC8-Hades-Homelab-Project.md](../NUC8-Hades-Homelab-Project.md), especially:
- Q1 (first deliverable was scaffolding — now moving toward actual apps)
- Q2 (Terraform will ultimately manage most of the app resources)
- Q4 (secrets strategy — leaning Vault)
- Q6 (detailed apply instructions will live alongside the code)

## How to Deploy an App

Always follow the instructions in the individual app's README **and** the central `docs/apply.md`.

Do not apply things ad-hoc without updating the documentation.
