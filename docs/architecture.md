# Architecture Documentation

## Overview

This homelab runs on a single **Intel NUC8i7HNB (Hades Canyon)** node and serves as both a learning platform and a practical daily-use system.

## Hardware

- **Model**: Intel NUC8i7HNB (Hades Canyon)
- **CPU**: Intel Core i7-8705G (4 cores / 8 threads)
- **GPU**: Intel HD 630 + AMD Radeon RX Vega M GL
- **RAM**: 32GB DDR4
- **Storage**: NVMe SSD (98GB usable root) + organized `/data/` volume
- **Networking**: Static IP `192.168.0.254`, Gigabit Ethernet

## Software Stack

| Layer              | Technology                  | Purpose |
|--------------------|-----------------------------|---------|
| **OS**             | Ubuntu 26.04 LTS Server     | Base operating system |
| **Orchestration**  | K3s (lightweight Kubernetes)| Container orchestration |
| **Ingress**        | Traefik                     | HTTP routing + load balancing |
| **Automation**     | AWX (Ansible Tower)         | Configuration management & playbooks |
| **Storage**        | Local Persistent Volumes + custom `local-data` StorageClass | Persistent data for apps & DBs |
| **Monitoring**     | (Planned) Prometheus + Grafana | Observability |
| **IaC**            | Terraform                   | Infrastructure as Code |

## Directory Structure

```bash
nuc8-hades-homelab/
├── README.md
├── NUC8-Hades-Homelab-Project.md
├── docs/
│   └── architecture.md          # ← This file
├── terraform/                   # Terraform configurations
├── k8s/                         # Raw Kubernetes manifests
├── helm/                        # Helm charts & values
├── apps/                        # Application-specific configs
│   ├── ghostfolio/
│   ├── postgres/
│   └── trading-bots/
├── ansible/                     # Exported AWX playbooks
└── .github/                     # GitHub Actions / workflows (future)
```

## Network & Access

- Internal Access: http://awx.nuc8-hades.local, http://ghostfolio.nuc8-hades.local, etc.
- IP: 192.168.0.254
- DNS: Local hostname resolution via /etc/hosts on client machines

## Data Flow
1. Trading Bots → Fetch market data → Store in PostgreSQL → Feed Investment Dashboard
2. Archery / Training Apps → Mobile apps → Backend APIs → PostgreSQL
3. AWX → Automates deployments, backups, and maintenance tasks

## Future Expansion

- Add internal SATA SSD or external storage with Longhorn
- Add monitoring stack
- Implement GitOps with ArgoCD or Flux
- Add reverse proxy (Traefik) with proper HTTPS (Let's Encrypt)
- Scale to multi-node (additional NUCs or Raspberry Pis)

## Design Principles

- Declarative — Prefer Terraform + Kubernetes manifests
- Reproducible — Everything should be code-defined
- Observable — Monitor everything
- Secure — Least privilege, secrets management, network policies
- Learning Focused — Document everything for future reference and portfolio


----
Last Updated: $(date)