# helm/

Helm charts and value overrides for the NUC8-Hades homelab.

## Purpose

Many applications (Ghostfolio, databases, monitoring, etc.) are best installed and managed via Helm.

This directory contains:
- `Chart.yaml` and values files for any locally packaged charts
- `values-*.yaml` overrides for upstream charts
- Scripts or notes for `helm repo add` / `helm upgrade --install`

## Structure (planned)

```
helm/
├── apps/
│   ├── ghostfolio/
│   │   └── values.yaml
│   ├── postgres/
│   │   └── values.yaml
│   └── ...
└── README.md
```

We may also use Helm inside Terraform via the `helm` provider (see terraform/modules/).

## How to Use

See [docs/apply.md](../docs/apply.md) for exact commands (Q6 requirement).

Typical flow:

```bash
helm repo add <repo> <url>
helm upgrade --install ghostfolio oci://... -n ghostfolio -f helm/apps/ghostfolio/values.yaml
```

## Current State

Scaffold only. No charts or values files added yet.

Ghostfolio is the most likely first candidate (see Q1 decision and apps/ghostfolio/).

Full context: [NUC8-Hades-Homelab-Project.md](../NUC8-Hades-Homelab-Project.md)
