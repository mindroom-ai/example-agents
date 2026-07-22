# Upstream Source

This repo is a **sanitized public snapshot** of an internal MindRoom agent workspace.

| Field | Value |
|-------|-------|
| Source repo (private) | `mindroom-config` |
| Source commit SHA     | `2858792ef9f5e4bd26a90aa890ac5845b810e8d4` |
| Snapshot date         | 2026-07-22 |
| Snapshot author       | DevAgent (automated) |

## Purpose of this file

This file pins the exact upstream commit this snapshot was derived from,
so that when the upstream workspace evolves, the diff to port forward is
mechanical:

```bash
# In the private upstream workspace:
git diff 2858792ef9f5e4bd26a90aa890ac5845b810e8d4..HEAD -- \
  AGENTS.md SOUL.md IDENTITY.md ARCHITECTURE.md TOOLS.md MEMORY.md skills/
```

Review the diff, port any non-personal changes into this public repo, then
bump the SHA above to the new upstream HEAD and update the snapshot date.
