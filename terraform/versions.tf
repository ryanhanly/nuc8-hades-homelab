# Provider version constraints for NUC8-Hades Homelab
# Decision Q7: Document known-good versions here. Strict pinning only when needed for stability.

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      # version = "~> 2.30"   # We will lock this after the first successful plan against your real K3s (Q7 decision)
    }

    helm = {
      source  = "hashicorp/helm"
      # version = "~> 2.13"
    }

    # AWX provider will be added when we work on the awx module (Q8)

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}
