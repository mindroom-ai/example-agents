# Memory Directory

Files in `memory/` are indexed by MindRoom's `memory_backend: file` (matching snippets can be recalled automatically on standard turns, and searched explicitly with `memory` / `search_memories`), while `MEMORY.md` at the workspace root is preloaded on standard turns (up to the configured preload limit).

Search uses keyword matching by default (which sees direct file edits immediately). To enable semantic search (and expose `memory/` through `search_knowledge_base`), configure `memory_search: { mode: semantic }` along with a `memory.embedder` in MindRoom's `config.yaml` — when using semantic mode, read `threads-YYYY-MM.md` directly when up-to-the-minute status matters, since direct edits are not reflected until the semantic index refreshes.

Keeping volatile state here instead of `MEMORY.md` avoids invalidating prompt caches across parallel threads.

## Recommended Layout

- `threads-YYYY-MM.md` — per-thread status log (worktree path, branch, PR link, review round, next step).
- `<topic>.md` — deeper durable notes (e.g. `perf.md`, `infra.md`, `ci.md`) that are too detailed for the `<200`-line `MEMORY.md`.

### Example `threads-2026-11.md` Entry

```markdown
## 2026-11-25 — Fix webhook retry backoff
- Worktree: `<worktrees-root>/app-webhook-backoff` (`fix/webhook-backoff`)
- PR: `#142`
- Status: Round 1 review complete (Opus + GPT); addressing 1 major finding
- Next: re-verify on updated head and score PR
```

Local `memory/**/*.md` files (other than this README) are gitignored so a cloned workspace stays private by default.
