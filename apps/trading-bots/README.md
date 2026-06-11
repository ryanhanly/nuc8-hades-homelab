# Trading & Crypto Bots

Automated trading and data collection bots.

**Status**: Not started

## Purpose

- Fetch market data (stocks, crypto, forex)
- Execute strategies (paper trading first, then real with caution)
- Store results and signals into PostgreSQL (feeding Ghostfolio and analytics)
- Expose minimal APIs or webhooks for the future mobile apps

## Important Notes

This is higher risk (real money). Start with:
- Paper trading / simulation only
- Read-only data collection bots
- Strong secret handling for exchange API keys (Q4 Vault decision will be critical)

## Technology Options

Common self-hosted choices:
- Freqtrade (Python, very popular for crypto)
- Jesse, Hummingbot, or custom Python/Go bots
- CCXT library for exchange connectivity

## Integration Points

- PostgreSQL (shared with Ghostfolio / personal data)
- Ghostfolio (for portfolio updates)
- AWX (for scheduled job execution and monitoring of the bots — ties into Q8)

## Next

- Choose initial bot framework
- Define data model for signals/trades
- Create deployment approach (Docker + k8s Deployment, or sidecar pattern)

Full context in [NUC8-Hades-Homelab-Project.md](../../NUC8-Hades-Homelab-Project.md).
