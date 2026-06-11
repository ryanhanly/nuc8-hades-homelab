# Root Terraform configuration for NUC8-Hades Homelab
# See terraform/README.md for scope (full reprovisioning per Q2) and decisions.

terraform {
  required_version = ">= 1.5.0"

  # Backend will be local for the homelab (no remote state yet).
  # Consider adding S3/GCS or a simple git-backed backend later if multi-user.
}

# ------------------------------------------------------------------
# LEARNING: Provider configuration at the root level
# ------------------------------------------------------------------
#
# It is common to configure providers in the root module and then pass
# configuration down into child modules (or let child modules re-configure
# using the same variables).
#
# For your single-node K3s setup we will pass the kubeconfig path into
# the base module so it can configure both the kubernetes and helm providers
# internally. This keeps the module self-contained for now.

variable "kubeconfig_path" {
  description = "Path to kubeconfig. Passed down to the base module. See modules/base/variables.tf for the full explanation (very important for learning)."
  type        = string
  default     = "~/.kube/config"
}

# We still declare the providers at root so `terraform providers` and
# `terraform plan` know about them, even if the actual config lives in the module.
# This is a common pattern.

provider "kubernetes" {
  # The real configuration is done inside the module for this learning exercise.
  # In more advanced setups you would configure it once here and pass the
  # provider alias or use the kubernetes provider's "exec" / "token" blocks.
}

provider "helm" {
  # Same idea as above.
}

# ------------------------------------------------------------------
# Call the base module (this is the first real work toward Q2)
# ------------------------------------------------------------------

module "base" {
  source = "./modules/base"

  kubeconfig_path = var.kubeconfig_path
  # cluster_context can be passed if you have multiple contexts
}

# Future modules will be added here:
# module "awx"  { source = "./modules/awx"  ... }
# module "apps" { source = "./modules/apps" ... }

# ------------------------------------------------------------------
# Root-level outputs (useful for humans)
# ------------------------------------------------------------------

output "base_module_outputs" {
  description = "Everything the base module is exposing. Look at these after your first apply. (This is a big nested map.)"
  value       = module.base
}

# These are re-exported at the root level so that the learning instructions
# in docs/apply.md can use simple commands like:
#   terraform output node_names
#   terraform output node_count
# Without having to dig into base_module_outputs.
output "node_names" {
  description = "Names of the nodes visible to Terraform. Good sanity check."
  value       = module.base.node_names
}

output "node_count" {
  description = "How many nodes the Kubernetes provider can see. Should be 1 on your current setup."
  value       = module.base.node_count
}

output "learning_note" {
  value = <<-EOT
    You have now connected Terraform to your live K3s cluster and are managing
    part of the base layer (StorageClass + namespaces).

    This is the beginning of the Q2 full reprovisioning journey.

    Next time you (or future you) install a fresh Ubuntu + K3s, you will be able
    to run `terraform apply` and get the same foundation without manual steps.

    See modules/base/main.tf — it is written as a lesson (lots of comments).
  EOT
}

