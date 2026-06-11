# Terraform

Infrastructure as Code for the NUC8-Hades Homelab.

## Scope (per project decisions)

**Q2 Decision**: Full reprovisioning capability.

The goal is that Terraform (combined with minimal bootstrap scripts) should be able to recreate the entire homelab environment:

- Base operating system configuration hints / K3s installation
- Storage layout and the `local-data` StorageClass
- AWX (Ansible Automation Platform) installation + configuration (see Q8)
- Networking / Ingress (Traefik)
- All workloads (Ghostfolio, PostgreSQL databases, trading bots, monitoring, etc.)

Because this is a bare-metal single node (Ubuntu on Intel NUC), full "terraform apply brings up a fresh NUC from PXE/netboot" is out of scope for now. Instead we target:

1. A well-documented bootstrap path for a fresh Ubuntu 26.04 install.
2. Terraform that manages **everything after the base OS** (K3s cluster join/config if needed, all Kubernetes resources, AWX config via provider, Helm releases, etc.).

This makes the homelab reproducible and serves as excellent portfolio / learning material.

## Directory Layout

```
terraform/
├── README.md                 # This file
├── main.tf                   # Root module - orchestration
├── versions.tf               # Provider version constraints (see Q7)
├── variables.tf
├── outputs.tf
├── modules/
│   ├── base/                 # K3s bootstrap, storage class, core cluster resources
│   ├── awx/                  # AWX installation + configuration (Q8)
│   ├── storage/              # Persistent volumes, StorageClass (if not in base)
│   └── apps/                 # Per-application modules (ghostfolio, postgres, etc.)
│       ├── ghostfolio/
│       ├── postgres/
│       └── ...
└── ...
```

## Key Decisions Reflected Here

- **Q8 (AWX as code)**: We will use the AWX Terraform provider (or equivalent) to manage organizations, projects, inventories, job templates, credentials, etc. Playbooks themselves live in the `ansible/` directory at the repo root and are referenced from AWX via Git.
- **Q7 (version pinning)**: We will document "known good" versions here and in `docs/versions.md` (to be created). Pin strictly only when instability appears.
- **Q6 (learning instructions)**: Every significant component has clear "apply" steps documented.

## Current State (as of this session)

- Providers configured (kubernetes + helm)
- First real module implemented: `modules/base`
  - Connects to your live K3s via kubeconfig
  - Manages the `local-data` StorageClass (with heavy learning comments)
  - Creates foundational namespaces
  - Includes data sources and outputs for learning/inspection

This is the beginning of delivering on the **Q2 full reprovisioning** decision while following the **Q6 learning focus**.

See the dedicated learning walkthrough in `docs/apply.md`.

See [NUC8-Hades-Homelab-Project.md](../NUC8-Hades-Homelab-Project.md) for full context and open questions (especially Q4 secrets and Q5 ingress/TLS/DNS).

## Next Work

1. (You are here) Get comfortable running `terraform plan` / `apply` against the live cluster and understand what the base module is doing.
2. Clean up the StorageClass management (proper import or removal of safety guards).
3. Research and add the AWX Terraform provider (Q8).
4. Build out more of the base (bootstrap docs/script, Traefik config, etc.).
5. Start the first real app (Ghostfolio is the natural candidate).

## How to Use (see also docs/apply.md)

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

All apply instructions will be maintained in `docs/apply.md` as we build.
