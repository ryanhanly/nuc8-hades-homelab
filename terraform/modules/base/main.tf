# terraform/modules/base/main.tf
#
# This is the heart of the "base" layer for your homelab.
# 
# === LEARNING OBJECTIVES (Q6) ===
# By the end of working with this file you should understand:
# 1. How the Terraform Kubernetes provider actually connects to a cluster.
# 2. The difference between a Kubernetes object that "just exists" vs one that is *managed by Terraform*.
# 3. Why StorageClass + reclaimPolicy + volumeBindingMode matter a lot on a single-node homelab.
# 4. How declaring things in Terraform moves you toward the Q2 goal of "full reprovisioning".
# 5. The importance of being careful when Terraform first sees objects that were created manually.
#
# Read this file top to bottom. The comments are the lesson.

# ------------------------------------------------------------------
# 1. Provider configuration inside the module
# ------------------------------------------------------------------
# 
# LEARNING:
# The Kubernetes provider can be configured in several ways.
# Here we pass the config from the root module (best practice for composition).
# This also makes the module testable with different kubeconfigs (e.g. kind, k3d, real K3s).

provider "kubernetes" {
  config_path    = var.kubeconfig_path
  config_context = var.cluster_context
}

# We also configure Helm here so that when we later add Helm releases
# (Ghostfolio, Postgres operator, etc.) they use the same cluster connection.
provider "helm" {
  kubernetes {
    config_path    = var.kubeconfig_path
    config_context = var.cluster_context
  }
}

# ------------------------------------------------------------------
# 2. The local-data StorageClass (the most important first resource)
# ------------------------------------------------------------------
#
# This is the custom StorageClass you already created manually on the NUC.
# 
# LEARNING - Why declare a StorageClass in Terraform?
#
# On a normal cloud Kubernetes cluster you often use "managed" StorageClasses
# (e.g. gp3, premium-ssd) provided by the cloud.
#
# On your bare-metal single-node NUC you had to create one yourself that:
# - Uses the local hostPath / filesystem
# - Has the right reclaimPolicy
# - Has the right volumeBindingMode so PVCs actually get bound on this node
#
# By declaring it here:
# - It becomes part of your "desired state"
# - When you (eventually) reprovision a fresh NUC, `terraform apply` will create it for you
# - You get a record of *why* you chose these particular settings
#
# Important attributes explained:
#
# reclaimPolicy = "Retain"   ← Very important for homelab data!
#   "Delete" would delete the data on the disk when the PVC is deleted.
#   "Retain" means the PV stays around (and the data) even if the PVC is removed.
#   This is usually what you want when you're learning and experimenting.
#
# volumeBindingMode = "WaitForFirstConsumer"
#   This is the modern/recommended setting.
#   It means the PV is not provisioned until a Pod actually needs it.
#   On a single node this mostly prevents scheduling problems.
#
# allowedTopologies (optional)
#   You can pin volumes to specific nodes. Useful later if you add more nodes.

resource "kubernetes_storage_class_v1" "local_data" {
  metadata {
    name = "local-data"

    # Annotations and labels are part of the object.
    # Terraform will enforce these too.
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "false"
      "homelab.nuc8-hades/description"              = "Local hostPath storage for persistent homelab workloads. Managed by Terraform."
    }
  }

  storage_provisioner = "kubernetes.io/no-provisioner"

  reclaim_policy      = "Retain"                   # See big comment above
  volume_binding_mode = "WaitForFirstConsumer"

  # This is the key part for a "local" StorageClass on a single node.
  # It tells Kubernetes: "when you create a PV for this SC, use this path pattern on the node".
  # The actual directory (/data) must already exist on the host (you already did this).
  parameters = {
    # Some people also set fsType here, but for hostPath it's usually not needed.
  }

  # LEARNING SAFETY:
  # Because this StorageClass probably already exists from your manual setup,
  # the first time you run terraform apply it may complain that the object exists
  # but is not managed by Terraform.
  #
  # Best long-term approach (Q2 reprovisioning):
  #   terraform import 'module.base.kubernetes_storage_class_v1.local_data' local-data
  #
  # We keep prevent_destroy as a temporary safety net during the learning/adoption phase.
  # Once imported and you've reviewed the diff, we can remove or adjust it.

  lifecycle {
    # prevent_destroy is a great guardrail while learning.
    # It will stop you from accidentally deleting the StorageClass (and potentially losing data references).
    prevent_destroy = true
  }
}

# ------------------------------------------------------------------
# 3. Foundational Namespaces
# ------------------------------------------------------------------
#
# LEARNING:
# Namespaces are the basic unit of isolation in Kubernetes.
# Even on a single-node homelab they are extremely useful because:
# - They let you use the same resource names in different environments (dev/prod, or different apps)
# - You can apply RBAC, network policies, resource quotas per namespace later
# - They make `kubectl get all -n ghostfolio` much cleaner
#
# Declaring them in Terraform means:
# - They will be created automatically on a fresh reprovision
# - You have a single place that documents "these are the namespaces that matter in this homelab"
#
# We create a few now even though the apps aren't deployed yet.
# This is intentional — it is part of building the "base" that everything else sits on.

locals {
  base_namespaces = [
    "ghostfolio",
    "postgres",
    "monitoring",
    "awx", # reserved even if AWX is installed differently
  ]
}

resource "kubernetes_namespace_v1" "base" {
  for_each = toset(local.base_namespaces)

  metadata {
    name = each.value

    labels = merge(
      {
        "homelab.nuc8-hades/managed-by" = "terraform"
        "homelab.nuc8-hades/purpose"    = "base"
      },
      # Keep the control-plane label that the AWX operator expects.
      # This prevents Terraform from trying to remove it on every plan.
      # (We observed this label during import and chose to include it
      # in desired state rather than ignore_changes.)
      each.value == "awx" ? { "control-plane" = "controller-manager" } : {}
    )

    annotations = {
      "homelab.nuc8-hades/description" = "Created by the base Terraform module as part of homelab foundation."
    }
  }
}

# ------------------------------------------------------------------
# 4. (Optional but educational) A simple data source
# ------------------------------------------------------------------
#
# Data sources let Terraform *read* information from the cluster without managing it.
# This is extremely useful for learning and for making your config smarter.

data "kubernetes_nodes" "all" {
  # This will let us see what nodes Terraform can see.
  # On your single-node K3s this should return one node.
}

# ------------------------------------------------------------------
# 5. Example output that proves the connection worked
# ------------------------------------------------------------------

output "node_count" {
  description = "How many nodes the Kubernetes provider can see. Should be 1 on your current setup."
  value       = length(data.kubernetes_nodes.all.nodes)
}

output "node_names" {
  description = "Names of the nodes visible to Terraform. Good sanity check."
  value       = [for n in data.kubernetes_nodes.all.nodes : n.metadata[0].name]
}
