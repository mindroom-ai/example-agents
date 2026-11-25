# Upstream Source

This repo is a **sanitized public snapshot** modeled after MindRoom's live `DevAgent` workspace.

| Field | Value |
|---|---|
| Model workspace | MindRoom `DevAgent` (`baspowers`-driven workflow) |
| External skill library | [`basnijholt/baspowers`](https://github.com/basnijholt/baspowers) |
| Snapshot date | 2026-11-25 |
| Snapshot author | DevAgent |

## Updating This Snapshot

When porting improvements from a live MindRoom dev workspace into `dev-agent/`:

1. Keep `AGENTS.md` and `MEMORY.md` lean, generic, and free of private hostnames, repo names, secrets, environment variable names for private keys, or user-specific details.
2. Keep `dev-agent/config.yaml` valid against MindRoom's current `agents:` configuration schema, leaving optional plugins commented with links.
3. Do not vendor third-party skill repositories into `dev-agent/skills/`; document how to install them instead.
4. Update the snapshot date above.
