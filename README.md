
# NUC8-Hades Homelab

A personal **Kubernetes homelab** built on an **Intel NUC8i7HNB (Hades Canyon)** using K3s, AWX, and modern DevOps practices.


## Overview

This project transforms a compact but powerful Intel NUC into a self-hosted platform for:

- **Learning & Automation** — Kubernetes (K3s) + AWX (Ansible Tower)
- **Finance Tools** — Trading/crypto bots + Investment Dashboard
- **Personal Data** — Databases for Archery training and Physical fitness tracking
- **Mobile Development** — Backend APIs for future Flutter apps

### Key Features
- Single-node **K3s Kubernetes** cluster
- **AWX** (open-source Ansible Automation Platform)
- Organized persistent storage with custom StorageClass
- Static IP + clean local domain (`*.nuc8-hades.local`)
- Ready for Terraform, GitOps, and monitoring

## Current Status

| Component                    | Status     | Access |
|-----------------------------|------------|--------|
| Ubuntu 26.04 LTS Server     | ✅ Done    | - |
| K3s Kubernetes              | ✅ Done    | `kubectl` ready |
| AWX (Ansible)               | ✅ Done    | `http://awx.nuc8-hades.local` |
| Storage Management          | ✅ Done    | `/data/` + `local-data` StorageClass |
| GitOps / Terraform          | In Progress | Q1 (scaffold) + Q2 (full reprovisioning) decisions made. Structure created. |

## Architecture

- **Hardware**: Intel NUC8i7HNB (i7-8705G, 32GB RAM, Vega Graphics)
- **OS**: Ubuntu 26.04 LTS Server
- **Networking**: Static IP `192.168.0.254`
- **Orchestration**: K3s + Traefik Ingress
- **Automation**: AWX
- **Storage**: Local persistent volumes

## Project Structure

```bash
nuc8-hades-homelab/
├── README.md
├── NUC8-Hades-Homelab-Project.md
├── terraform/          # Infrastructure as Code
├── k8s/                # Kubernetes manifests
├── ansible/            # Playbooks (exported from AWX)
├── apps/               # Ghostfolio, databases, bots, etc.
├── docs/               # Architecture diagrams & guides
└── .gitignore
```

## Getting Started
### Prerequisites

- Intel NUC8i7HNB (or similar)
- Ubuntu 26.04 LTS Server
- Static IP configured

### Quick Setup
```bash
# Clone this repo
git clone https://github.com/YOURUSERNAME/nuc8-hades-homelab.git
cd nuc8-hades-homelab

# Explore the central project document (goals, status, open questions, decisions, roadmap)
cat NUC8-Hades-Homelab-Project.md
```
## Roadmap

- [x] Base OS + K3s + AWX
- [ ] Investment Dashboard (Ghostfolio)
- [ ] PostgreSQL databases (Archery + Physical Training)
- [ ] Trading & Crypto bots
- [ ] Terraform infrastructure definitions
- [ ] Monitoring (Prometheus + Grafana)
- [ ] Mobile app backends + Flutter clients
- [ ] Automated backups & GitOps (ArgoCD/Flux)

## Showcase / Learning Objectives
This repository serves as both a functional homelab and a portfolio project demonstrating skills in:
- Kubernetes administration
- Infrastructure as Code (Terraform)
- Ansible automation
- Self-hosted applications to test out as potentila mobile apps

### Made with ❤️ on Intel NUC8-Hades
Last updated: 2026-06-11