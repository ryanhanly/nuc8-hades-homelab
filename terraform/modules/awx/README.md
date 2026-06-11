# terraform/modules/awx

Terraform module to manage AWX (Ansible Automation Platform) configuration.

## Q8 Decision Context

We decided to treat AWX itself as infrastructure-as-code:
- Use Terraform (via the AWX provider) to create and maintain organizations, projects (pointing at this Git repo), inventories, credentials, job templates, etc.
- Playbooks and roles continue to live in the `ansible/` directory at the repo root.

## Goals

- Make the automation platform reproducible.
- Reduce drift between what is configured in the AWX UI and what is declared in code.
- Allow a fresh homelab rebuild to bring AWX back to a useful state with minimal manual clicking.

## Current State

Scaffold placeholder. 

Research needed:
- Which AWX Terraform provider is best maintained in 2026 (dennybaa/awx, or others)?
- How to authenticate the provider against the existing AWX instance (tokens, etc.).
- Overhead vs. benefit on a single-user homelab.

## Planned Contents

- `main.tf` — resources for organizations, projects, etc.
- `variables.tf`
- `outputs.tf`
- Possibly data sources to import existing AWX objects gradually.

See [NUC8-Hades-Homelab-Project.md](../../../NUC8-Hades-Homelab-Project.md) Decisions Log for the full Q8 rationale.
