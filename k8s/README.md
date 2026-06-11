# k8s/

Raw Kubernetes manifests for the NUC8-Hades homelab.

## Purpose

This directory holds plain YAML manifests (Deployments, Services, IngressRoutes, ConfigMaps, Secrets, etc.) that are **not** managed via Helm or Terraform.

We prefer:
- Helm charts (see ../helm/) for complex off-the-shelf apps (Ghostfolio, etc.)
- Terraform + kubernetes/helm providers for declarative GitOps-style management (see ../terraform/)

Raw manifests here are for:
- Simple custom resources
- Things that don't have good Helm charts
- Quick one-off experiments
- Base cluster objects that are easier to express directly

## Structure

```
k8s/
├── base/          # Cluster-wide or foundational objects (namespaces, storage, network policies, etc.)
├── apps/          # App-specific raw manifests (when not using Helm or TF)
│   ├── ghostfolio/
│   └── ...
└── README.md
```

## How to Apply

See the central [docs/apply.md](../docs/apply.md) for current recommended commands (per Q6 decision: always include clear instructions).

Typical pattern (example only):

```bash
kubectl apply -k k8s/base          # or individual files
kubectl apply -f k8s/apps/ghostfolio/
```

Always prefer `kubectl apply --dry-run=client -f ...` first when learning.

## Relationship to Other Directories

- **terraform/**: Primary home for desired state of most resources (including many Kubernetes objects).
- **helm/**: Helm values and chart customizations.
- **apps/**: Higher-level app configuration, docs, and deployment notes.

See [NUC8-Hades-Homelab-Project.md](../NUC8-Hades-Homelab-Project.md) for the full decision context.
