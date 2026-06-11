# Variables for the base module
# 
# LEARNING NOTE (Q6 focus):
# Variables make the module reusable and testable.
# For a single-node homelab we could hardcode more things,
# but using variables teaches you how real Terraform modules are built
# and makes it easier to support "fresh reprovision" later (Q2).

variable "kubeconfig_path" {
  description = <<-EOT
    Path to the kubeconfig file that Terraform will use to talk to your K3s cluster.
    
    LEARNING: 
    - The Kubernetes provider needs credentials + cluster address to talk to the API server.
    - On K3s, the server writes a kubeconfig at /etc/rancher/k3s/k3s.yaml by default.
    - That file is usually owned by root with mode 600, so your normal user can't read it.
    
    Common solutions (we'll use the first for learning):
    1. Copy it to a location your user can read: 
       sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
       sudo chown $(id -u):$(id -g) ~/.kube/config
       chmod 600 ~/.kube/config
    
    2. Tell Terraform the original path and run terraform with sudo (not recommended for daily use).
    
    3. Use the KUBECONFIG environment variable.
    
    For full reprovisioning (Q2), you will eventually want a more robust way
    (perhaps generated during bootstrap or using a service account token).
  EOT
  type    = string
  default = "~/.kube/config"
}

variable "cluster_context" {
  description = "Optional: specific context name inside the kubeconfig to use. Leave empty to use the current/default context."
  type        = string
  default     = null
}
