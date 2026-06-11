# Apply Instructions for NUC8-Hades Homelab

This document exists because of **Q6 Decision (Option A)**: we want clear, learning-oriented instructions for every major change so the "how" and "why" are explicit.

**Always**:
- Read the relevant component README first (e.g. `terraform/README.md`, `apps/ghostfolio/README.md`)
- Prefer dry-run / plan steps
- Update this file and the component READMEs when the apply process changes
- Work on the NUC via VS Code Remote-SSH (per the workflow in `NUC8-Hades-Homelab-Project.md`)
- For quick session restarts, also read `docs/SESSION-HANDOFF.md` first.

---

## Terraform + Kubernetes Provider — Learning Walkthrough (Current Focus)

This section was written specifically for the first real implementation work (Option 1 you chose).

**Goal of this lesson**: Get Terraform talking to your live K3s cluster and have it manage the `local-data` StorageClass + a few namespaces. You will *understand* what is happening, not just run commands.

### Step 0: One-time Kubeconfig Preparation (on the NUC)

```bash
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
chmod 600 ~/.kube/config

# Verify kubectl still works with your user
kubectl get nodes -o wide
```

**Why this step?**  
K3s creates the admin kubeconfig as root-only by default. Terraform (running as your user) needs to read it. Copying it is the cleanest way while learning.

### Step 1: Initialize

On the NUC, in the repo:

```bash
cd ~/nuc8-hades-homelab/terraform

terraform init -upgrade
```

This downloads the `kubernetes` and `helm` providers (see `versions.tf`).

### Step 2: Plan (the most important command while learning)

```bash
terraform plan -var="kubeconfig_path=~/.kube/config" -out=tfplan
```

**What you should do**:
- Read the entire plan output slowly.
- Look for the `kubernetes_storage_class_v1.local_data` resource.
- Look for the four `kubernetes_namespace_v1` resources.
- Look at the data source `kubernetes_nodes.all`.
- Notice the "known after apply" values.

**Questions to ask yourself**:
- Why does Terraform want to *create* the StorageClass even though you already made one manually?
- What would happen if we removed `prevent_destroy = true` and ran apply?
- Why is it also creating namespaces even though no apps are deployed yet?

### Step 3: Apply (only after you have reviewed the plan)

```bash
terraform apply tfplan
# or
terraform apply -var="kubeconfig_path=~/.kube/config"
```

Type `yes` when prompted.

### Step 4: Explore what just happened (this is where the learning happens)

Run these commands and really look at the output:

```bash
# What does Terraform think it owns?
terraform state list

# Detailed view of the StorageClass in Terraform state
terraform state show 'module.base.kubernetes_storage_class_v1.local_data'

# Compare with the live cluster object
kubectl get storageclass local-data -o yaml

# See the namespaces Terraform created
kubectl get namespaces --show-labels

# Prove the connection worked (from the data source in the module)
# These are root-level outputs (re-exported from the module in main.tf
# so the simple commands below work directly).
terraform output node_names
terraform output node_count
```

### Step 5: Experiment (highly recommended)

Try these and observe the behavior:

1. Manually add an annotation to the StorageClass:
   ```bash
   kubectl annotate storageclass local-data homelab.nuc8-hades/test-annotation=hello --overwrite
   ```
   Then run `terraform plan` again. What does it say?

2. Look at the `reclaimPolicy` in the live object vs what we declared.

3. Delete one of the namespaces we created with Terraform:
   ```bash
   kubectl delete namespace ghostfolio
   ```
   Run plan/apply. What happens?

These experiments teach you **drift detection** and **desired state** — core concepts of both Terraform and GitOps.

### Adopting Existing Resources (the situation you are in right now)

When resources were created manually before Terraform (like your original `local-data` StorageClass and the `awx` namespace), the clean approach is:

- Use `terraform import` for things you want Terraform to manage going forward (especially things important for Q2 reprovisioning).
- Let Terraform create brand new resources that don't exist yet (ghostfolio, postgres, monitoring namespaces).
- After import, review the plan diff carefully — Terraform will often want to "reconcile" labels/annotations to match your code.
- For the StorageClass, importing lets you own the `reclaim_policy`, `volume_binding_mode`, etc. declaratively.

This is the recommended path for your homelab objectives.

### After This Lesson

- The StorageClass and namespaces are now (mostly) under Terraform's control.
- We can later do a proper `terraform import` for the StorageClass so the state is clean.
- Future modules (awx, ghostfolio, etc.) can depend on `module.base.storage_class_name` and the namespaces.

See:
- `terraform/modules/base/main.tf` (the actual lesson — read the comments)
- `terraform/modules/base/README.md`
- `terraform/main.tf` (how the root calls the module)

---

## Regular Terraform Workflow (after the learning exercise)

### Initial one-time setup (on the NUC)

```bash
cd ~/nuc8-hades-homelab/terraform
terraform init -upgrade
```

### Normal workflow

```bash
cd ~/nuc8-hades-homelab/terraform

# See what will change
terraform plan -var="kubeconfig_path=~/.kube/config"

# Review the plan carefully (especially on a homelab you care about)

# Apply
terraform apply -var="kubeconfig_path=~/.kube/config"
```

### Targeting specific modules (once we have them)

```bash
terraform apply -target=module.base -var="kubeconfig_path=~/.kube/config"
```

### State

Currently using local state (in the `terraform/` directory on the NUC).  
Do **not** commit `.terraform/` or `*.tfstate*` files (already in `.gitignore`).

Later we may add a remote backend if needed.

---

## Kubernetes (raw manifests in k8s/)

```bash
# Dry run first (highly recommended while learning)
kubectl apply --dry-run=client -f k8s/base/ -R

# Apply
kubectl apply -f k8s/base/ -R

# Or with kustomize if we adopt it
kubectl apply -k k8s/base
```

---

## Helm

```bash
# Add repos as needed (example)
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Install/upgrade an app (example for Ghostfolio - will be refined)
helm upgrade --install ghostfolio \
  oci://ghcr.io/ghostfolio/ghostfolio-helm \
  -n ghostfolio --create-namespace \
  -f helm/apps/ghostfolio/values.yaml \
  --wait
```

Always include the `-f values` file so configuration lives in Git.

---

## AWX / Ansible Automation

Because of the **Q8 decision**, AWX itself is increasingly driven by Terraform.

For playbooks:

1. Make changes in `ansible/playbooks/...` or roles.
2. Commit and push (so AWX's Git project sees the update).
3. In AWX UI (or later via TF), launch the relevant job template.

For direct testing on the NUC (bypass AWX temporarily):

```bash
cd ~/nuc8-hades-homelab/ansible
ansible-playbook -i inventories/nuc8-hades playbooks/whatever.yml --ask-become-pass
```

---

## General Tips

- Work in small commits when possible.
- After any apply, run `kubectl get pods -A` and check the relevant Ingress / Service.
- For learning: after a successful apply, explain in the commit message or in this doc *what* each resource does.
- If something goes wrong, capture the exact error + the command that produced it before trying to "just fix it".

---

## Updating These Instructions

If you change how something is applied (new flags, new order, Terraform workspaces, etc.), update:
1. This file
2. The README in the relevant directory (`terraform/README.md`, `apps/xxx/README.md`, etc.)
3. The central [NUC8-Hades-Homelab-Project.md](../NUC8-Hades-Homelab-Project.md) if it affects high-level process

Last significant update: 2026-06-11 (initial scaffold)
