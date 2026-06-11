# terraform/modules/base

**This module is deliberately written as a learning exercise (see Q6).**

## What This Module Does Right Now (first small step)

- Connects Terraform to your live K3s cluster using a kubeconfig.
- Declaratively manages the `local-data` StorageClass (the one you created manually).
- Creates a small set of foundational namespaces that the rest of the homelab will use.
- Proves the connection works by reading the nodes visible to the API server.

This is the smallest useful slice of the **Q2 full reprovisioning** goal that actually does something real against your current cluster.

## Learning Path (read in order)

1. Read `variables.tf` — especially the long comment about kubeconfig. This is the #1 thing that trips people up when using Terraform with K3s.
2. Read `main.tf` from top to bottom. It is heavily commented with explanations of:
   - How the provider works
   - Why `reclaimPolicy = "Retain"` is important on a homelab
   - The difference between objects that exist vs objects Terraform owns
   - What will probably happen the first time you run `terraform apply`
3. Read `outputs.tf`
4. Then come back here.

## How to Prepare Your NUC (one-time)

On the NUC (via your Remote-SSH session):

```bash
# Make a copy of the K3s kubeconfig that your user can read
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
chmod 600 ~/.kube/config

# Test that kubectl still works with the copy
kubectl get nodes
```

This is the recommended approach for daily development while learning.

## How to Run This Module (see docs/apply.md for full guided lesson)

```bash
cd ~/nuc8-hades-homelab/terraform

terraform init -upgrade

# This should succeed and show you the plan
terraform plan -var="kubeconfig_path=~/.kube/config"

# Then apply (after you have reviewed the plan)
terraform apply -var="kubeconfig_path=~/.kube/config"
```

After the first apply, try these commands to learn:

```bash
# See what Terraform thinks it is managing
terraform state list

# Inspect the StorageClass resource in Terraform's state
terraform state show 'module.base.kubernetes_storage_class_v1.local_data'

# Compare with what is actually in the cluster
kubectl get storageclass local-data -o yaml

# Look at the namespaces we created
kubectl get ns
```

## Important Learning Points for This Step

- **Drift detection**: If you manually edit the StorageClass in the cluster later, `terraform plan` will show the difference.
- **prevent_destroy**: We set this as a safety net while learning. It will stop Terraform from deleting the StorageClass.
- **Import vs create**: Because the StorageClass already exists, the "correct" long-term thing is usually `terraform import`. We can do that together after you see the first apply.
- **Namespaces are cheap**: Creating them in Terraform costs almost nothing but gives you a lot of clarity and reproducibility.

## Current State

First real implementation of the base module (June 2026).

## Next in This Module (future increments)

- Proper handling of the existing StorageClass (import or lifecycle cleanup)
- A simple example PersistentVolume that uses the StorageClass (for teaching)
- Bootstrap script / documentation for a *fresh* Ubuntu install
- Metrics server, Traefik configuration, etc. as we expand the "base"

See the central [NUC8-Hades-Homelab-Project.md](../../../NUC8-Hades-Homelab-Project.md) for all decisions (especially Q2 and Q6).
