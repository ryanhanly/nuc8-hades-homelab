## Revised Workflow (Grok Build on MacBook)

**Grok Build Location**: Installed on MacBook only.
**Development Machine**: MacBook (VS Code + Grok Build)
**Target Machine**: NUC8-Hades (via Remote-SSH)

### Daily Workflow:
1. Open VS Code on MacBook → Connect to `ryanh@nuc8-hades.local` via Remote-SSH.
2. Open folder: `~/nuc8-hades-homelab`
3. Use Grok Build on MacBook to generate code / plans.
4. Paste generated code into files on the NUC (via VS Code).
5. Apply changes on the NUC using the integrated terminal.
