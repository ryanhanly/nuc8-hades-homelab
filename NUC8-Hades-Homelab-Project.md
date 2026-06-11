# NUC8-Hades Homelab - Project Document

This is the central living document for the project (referenced from [README.md](./README.md)).

## Collaboration Workflow (Grok Build on MacBook)

**Grok Build Location**: Installed on MacBook only.  
**Development Machine**: MacBook (VS Code + Grok Build)  
**Target Machine**: NUC8-Hades (via Remote-SSH)

### Daily Workflow
1. Open VS Code on MacBook → Connect to `ryanh@nuc8-hades.local` via Remote-SSH.
2. Open folder: `~/nuc8-hades-homelab`
3. Use Grok Build on MacBook to generate code / plans.
4. Paste generated code into files on the NUC (via VS Code).
5. Apply changes on the NUC using the integrated terminal.

---

## Project Goals & Vision

A practical, single-node Kubernetes homelab on the **Intel NUC8i7HNB (Hades Canyon)** that serves dual purposes:
- Daily-use self-hosted platform (finance tools, personal data tracking, automation)
- Learning + portfolio project demonstrating modern DevOps practices

**Core uses**:
- Learning & Automation: K3s + AWX (Ansible Tower)
- Finance: Trading/crypto bots + Investment Dashboard (Ghostfolio)
- Personal Data: PostgreSQL databases for Archery training and Physical fitness tracking
- Future: Backend APIs for Flutter mobile apps

**Design Principles** (from architecture):
- Declarative — Prefer Terraform + Kubernetes manifests / Helm
- Reproducible — Everything defined as code
- Observable — Monitor everything
- Secure — Least privilege, secrets management, network policies
- Learning Focused — Document decisions, trade-offs, and learnings

---

## Current Status (as of 2026-06-11)

| Component                    | Status        | Notes / Access                          |
|-----------------------------|---------------|-----------------------------------------|
| Ubuntu 26.04 LTS Server     | ✅ Done       | -                                       |
| K3s Kubernetes + Traefik    | ✅ Done       | `kubectl` ready                         |
| AWX (Ansible Automation)    | ✅ Done       | http://awx.nuc8-hades.local             |
| Storage (local-data SC)     | ✅ Done       | `/data/` volume + custom StorageClass   |
| GitOps / Terraform          | In Progress   | Q1/Q2 decisions made — scaffolding + full reprovisioning scope | 
| Ghostfolio (Investment)     | Not started   | -                                       |
| PostgreSQL (Archery + Fitness) | Not started | -                                    |
| Trading / Crypto Bots       | Not started   | -                                       |
| Monitoring (Prometheus/Grafana) | Not started | -                                     |
| Backups & GitOps (ArgoCD/Flux) | Planned    | -                                       |

Hardware baseline: Intel NUC8i7HNB (i7-8705G, 32GB RAM), static IP `192.168.0.254`, `*.nuc8-hades.local` domain.

---

## Open Questions & Decisions Needed

These questions were captured at the beginning of active development work to drive alignment, avoid rework, and create a clear decision log.  
Reference them by ID (e.g., "this relates to Q2") when discussing or making changes.

| ID  | Question | Why It Matters | Options / Considerations | Status | Decision / Notes |
|-----|----------|----------------|---------------------------|--------|------------------|
| Q1  | What should be the very first concrete deliverable / priority? | Sets the initial momentum and shows value quickly. Wrong starting point wastes effort on scaffolding that may not be used immediately. | a) Scaffold full directory structure (`terraform/`, `k8s/`, `apps/`, `helm/`) + placeholder docs<br>b) First real Terraform work (model existing cluster or just workloads?)<br>c) Deploy Ghostfolio end-to-end as the "first win"<br>d) Something else (e.g. monitoring baseline) | Decided | **Option A** — Scaffold full directory structure (`terraform/`, `k8s/`, `apps/`, `helm/`) + placeholder docs first. |
| Q2  | What is the intended scope of Terraform at this stage? | Determines how much of the "already done" base we try to codify vs. treating the running K3s cluster as given. | a) Workloads & apps only (namespaces, PVCs, deployments, Ingress, Secrets, StorageClass usage) on top of the existing cluster<br>b) Full reprovisioning story (K3s install, AWX, networking, storage layout, etc.) for true "one command to recreate the homelab"<br>c) Hybrid (start with workloads, add base later) | Decided | **Option B** — Full reprovisioning story in Terraform (K3s install, AWX, networking, storage layout, plus workloads) for true one-command recreate of the homelab. |
| Q3  | How should we use / evolve `NUC8-Hades-Homelab-Project.md` and docs/ going forward? | This file is already referenced in the README as "the project document". Keeping decisions, backlog, and rationale here (or in docs/) is core to the project's "document everything" principle. | a) Keep this file as the single source of truth (workflow + goals + open questions + decisions log + roadmap)<br>b) Split: keep workflow here, move detailed decisions/roadmap to `docs/decisions.md` + `docs/roadmap.md`<br>c) Use Architecture Decision Records (ADRs) in `docs/adrs/` | Decided | Keep `NUC8-Hades-Homelab-Project.md` as the central project document (workflow + decisions + roadmap) for now. Option B (splitting to dedicated docs/) may be considered later as the project grows in complexity. |
| Q4  | What is our secrets & sensitive config strategy? | Ghostfolio, DB passwords, trading API keys, AWX credentials, etc. will appear quickly. Poor choice now creates tech debt or security issues. | a) AWX credentials + job templates (leverage what we already have)<br>b) Kubernetes Secrets (for now) + good .gitignore discipline + notes<br>c) Sealed Secrets or External Secrets Operator<br>d) HashiCorp Vault (or similar) inside the cluster<br>e) Mix (AWX for automation, sealed-secrets for k8s) | Open - Researching | Leaning **Option D** (HashiCorp Vault). Haven't used it in this context before; need to understand integration/impact on AWX credentials and secrets management. |
| Q5  | Ingress, domain, and TLS strategy for the near term? | All apps will need clean hostnames (`ghostfolio.nuc8-hades.local` etc.). HTTPS vs HTTP affects security posture and real-world usage. | a) Stick with Traefik + plain HTTP + `*.nuc8-hades.local` (manual /etc/hosts or mDNS on clients) for now<br>b) Add self-signed or internal CA certs immediately<br>c) Plan for Let's Encrypt (even internal ACME?) or Tailscale/Headscale + proper certs later<br>d) Introduce a simple internal DNS solution (e.g. CoreDNS override, Pi-hole, Technitium) | Open - Researching | Leaning **Option D** (simple internal DNS solution). Do not want to incur external costs but want to move away from plain HTTP. |
| Q6  | How much "how to apply" guidance should be generated alongside code? | The workflow relies on the human pasting files then running commands on the NUC. Generated instructions reduce errors and make the repo more usable by others (or future self). | a) Always include clear `kubectl apply`, `terraform apply`, `helm upgrade`, AWX job notes in READMEs or a `docs/apply.md`<br>b) Provide scripts / make targets / taskfiles where practical<br>c) Minimal instructions (human knows the cluster) | Decided | **Option A** — Always include clear apply instructions (kubectl, helm, terraform, AWX) in relevant READMEs or a central `docs/apply.md`. This supports learning the theory of what is being done. |
| Q7  | Do we need to pin specific versions / constraints early (K3s, Terraform providers, Postgres, Ghostfolio, etc.)? | Reproducibility and avoiding "it worked on my cluster" surprises. | a) Pin versions in Terraform providers, Helm values, k3s install commands, etc. from the start<br>b) Document "current known good" versions in docs/ and pin only when pain appears<br>c) Use Renovate / Dependabot later for updates | Decided | **Option B** — Document "current known good" versions in docs/ and pin versions only when pain or instability appears. Consider Renovate/Dependabot later. |
| Q8  | How do we manage AWX content (playbooks, inventories, credentials) going forward? | AWX is already running and is a major automation surface. We want it reproducible too. | a) Keep everything in the AWX UI for now; periodically export playbooks to `ansible/`<br>b) Treat AWX as "infrastructure" and drive it declaratively (AWX Terraform provider, or AWX CLI + git-backed projects)<br>c) Hybrid: critical automation in repo + AWX as execution engine | Decided | **Option B** — Use Terraform to manage the configuration of AWX (treat the automation platform itself as infrastructure-as-code). Playbooks, inventories, etc. will be managed in the GitHub repo. Evaluate Terraform provider overhead; if too high, adjust approach. |

**How to use this table**: When we decide something, move the row (or a summary) to the Decisions Log below, update the Status, and add a date + short rationale. Update the main README Current Status table when relevant.

---

## Decisions Log

Record resolved questions here with date, rationale, and any follow-up actions. This becomes valuable historical context.

- **2026-06-11 - Q1**: Decided Option A (scaffold full directory structure + placeholder docs first). Rationale: Provides a solid, organized foundation before writing substantial code. Matches the "first concrete deliverable" goal without committing to a specific app yet. Follow-up: Directories and initial files created (see structure in architecture.md and this doc).
- **2026-06-11 - Q2**: Decided Option B (full reprovisioning in Terraform). Rationale: Aligns with design principles of declarative and reproducible. Goal is eventual "one command to recreate the entire homelab". Follow-up: Terraform structure will include modules for base (K3s, networking, storage, AWX) in addition to apps. Existing running cluster will be treated as the first "production" instance.
- **2026-06-11 - Q3**: Decided to keep `NUC8-Hades-Homelab-Project.md` as the central living project document for now (workflow + open questions + decisions log + roadmap + status). Rationale: Low friction; README already points here. Option B (splitting into dedicated docs/ files) is noted as a possible future evolution if the project grows significantly.
- **2026-06-11 - Q6**: Decided Option A (include clear apply / theory instructions everywhere). Rationale: Primary user need is to learn and understand the "why" and "how" of each change. Follow-up: `docs/apply.md` will be created and per-component READMEs will contain explicit commands.
- **2026-06-11 - Q7**: Decided Option B (loose pinning + document known-good versions). Rationale: Avoid premature optimization on a small homelab while still enabling reproducibility through documentation.
- **2026-06-11 - Q8**: Decided Option B (Terraform manages AWX configuration; content in Git). Rationale: Strong desire to make the automation platform itself declarative and version-controlled in the repo. Follow-up: Research the AWX Terraform provider (or alternatives like awx.awx or community providers) and evaluate overhead vs. benefit. Playbooks will live in `ansible/` (or `terraform/modules/awx/`).

*(Open items Q4 and Q5 remain under research — will be decided when we reach secrets and ingress work.)*

---

## Roadmap & Priorities

From README + architecture (updated with 2026-06-11 decisions).

**Completed**
- [x] Base OS + K3s + AWX
- [x] Storage management (`/data/` + `local-data` StorageClass)
- [x] Initial documentation (architecture, this project doc, README)
- [x] Q1–Q3, Q6–Q8 decisions captured and scaffolded

**Current Focus (GitOps / Terraform — full reprovisioning scope)**
- [x] Scaffold complete (Q1) — directories + placeholders + apply docs
- [x] First real Terraform work started (Option 1 chosen): providers + `modules/base` connected to live K3s, managing `local-data` StorageClass + namespaces. Heavy emphasis on learning (Q6).
- [ ] Clean up first module (import of existing StorageClass, remove temporary safety measures)
- [ ] Expand base module + add bootstrap documentation/script for true reprovisioning (Q2)
- [ ] Research & add AWX management via Terraform (Q8)
- [ ] Research & decide on secrets (Q4 — leaning Vault) and ingress/TLS/DNS (Q5 — leaning internal DNS)
- [ ] Initial app deployments, starting with Ghostfolio
- [ ] PostgreSQL databases for Archery + Physical Training
- [ ] Trading & Crypto bots
- [ ] Monitoring (Prometheus + Grafana)
- [ ] Version documentation discipline (Q7)

**Later**
- [ ] Automated backups & GitOps (ArgoCD / Flux)
- [ ] Mobile app backends + Flutter clients
- [ ] Proper internal HTTPS (Q5)
- [ ] Scale to multi-node (additional hardware)
- [ ] Longhorn or expanded storage

---

## Session Continuity Protocol (for Grok Build resets / memory limits)

Because Grok sessions can reset or lose long context, we follow these rules for reliable continuation:

**At the start of any new Grok session (or after a long break):**
- Read the dedicated handoff file first: `docs/SESSION-HANDOFF.md`
- Then read this file (`NUC8-Hades-Homelab-Project.md`) for full decisions and roadmap.
- Read the current focused learning doc: `docs/apply.md`.
- Read the README of the active module (currently `terraform/modules/base/README.md`).
- Ask the user for the most recent terminal output or current state if needed.

**At the end of a productive session:**
- Update `docs/SESSION-HANDOFF.md` with the latest state and next action.
- Also update the "Current Focus", "Next Steps", and "Latest Session Handoff" sections in this document if significant progress was made.
- Commit and push from the Mac so the NUC clone stays in sync.
- Keep the handoff file concise and actionable.

This protocol (combined with the detailed instructions in `docs/apply.md` and the learning comments in the module READMEs) lets us resume cleanly even after a full session reset.

## Next Steps

1. Directories and skeleton files created per Q1 (this session).
2. Populate key Terraform files (providers, main skeleton, module outlines for base reprovisioning + AWX per Q2/Q8).
3. Create `docs/apply.md` with initial guidance (per Q6).
4. Research next open items (Q4 Vault + Q5 internal DNS) and propose options when relevant.
5. Update this document (and README status) as work progresses.
6. Keep all generated artifacts aligned with the design principles (declarative, reproducible, documented, learning-focused).

---

**Latest Session Handoff** (2026-06-12, end of day)
- Completed StorageClass reconciliation (`local-data` reclaim_policy now `Retain`).
- Fixed root outputs — `terraform output node_names` now works directly and returns `["nuc8-hades"]`.
- Created dedicated `docs/SESSION-HANDOFF.md` + improved continuity protocol.
- Still in the middle of the Terraform learning walkthrough (`docs/apply.md`).
- **Next when resuming**: Read `docs/SESSION-HANDOFF.md` first, then finish Step 4 + Step 5 experiments.

**Last updated**: 2026-06-12 (end of day - created dedicated SESSION-HANDOFF.md)

*This document should be updated whenever major decisions are made or the status changes.*