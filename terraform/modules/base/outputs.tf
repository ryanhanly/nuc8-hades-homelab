# Outputs for the base module
#
# LEARNING:
# Outputs are how a module "reports back" useful information after apply.
# They are also used by the root module or other modules to wire things together.
# In a real project you would output things like "the StorageClass name to use for all apps",
# or "the list of namespaces that downstream modules should target".

output "kubeconfig_used" {
  description = "The kubeconfig path that was used to configure the providers. Useful for debugging."
  value       = var.kubeconfig_path
}

output "storage_class_name" {
  description = "Name of the StorageClass we are managing. All PVCs in this homelab should use this (or the default) unless they have special requirements."
  value       = "local-data"
}

output "managed_namespaces" {
  description = "Namespaces that Terraform is responsible for creating/managing. Good for documentation and for other modules to reference."
  value = [
    "ghostfolio",
    "postgres",
    "monitoring",
    "awx", # even if AWX itself runs in a different way, good to reserve the namespace
  ]
}
