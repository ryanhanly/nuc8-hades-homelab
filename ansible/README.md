# ansible/

Playbooks, roles, inventories, and related automation for the NUC8-Hades homelab.

## Relationship to AWX (Q8 Decision)

Per the 2026-06-11 decision on Q8:

- AWX configuration (organizations, projects, job templates, credentials, inventories, etc.) will be managed declaratively with Terraform where practical.
- The actual playbooks, roles, and content will live in this `ansible/` directory (or subdirectories) and be referenced from AWX as Git-based projects.
- This keeps the automation logic in Git and under version control.

## Structure (planned)

```
ansible/
├── playbooks/           # Reusable playbooks
│   ├── site.yml
│   ├── k3s.yml
│   ├── awx.yml
│   └── ...
├── inventories/         # Or dynamic inventory
├── roles/               # Custom roles (if any)
├── group_vars/
├── host_vars/
└── README.md
```

## Usage

Most execution will happen through AWX job templates.

For local / one-off runs on the NUC:

```bash
ansible-playbook -i inventories/nuc8-hades playbooks/site.yml
```

See `docs/apply.md` for the latest recommended commands and any AWX-specific instructions.

## Current State

Scaffold directory only. Content will be added when we start automating base setup or app deployments.

Full decision history: [NUC8-Hades-Homelab-Project.md](../NUC8-Hades-Homelab-Project.md#decisions-log)
