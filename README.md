# example-agents

<picture>
  <source media="(prefers-reduced-motion: no-preference)" srcset="https://raw.githubusercontent.com/mindroom-ai/mindroom/main/assets/logo/logo-mark-animated.svg" />
  <img src="https://raw.githubusercontent.com/mindroom-ai/mindroom/main/assets/logo/logo-mark.svg" alt="MindRoom Logo" align="right" width="120" />
</picture>

Public, sanitized example agent workspaces for [MindRoom](https://github.com/mindroom-ai/mindroom).

This repository shows how to structure a MindRoom agent workspace so the always-loaded system prompt stays tiny and cache-friendly while workflows, project knowledge, and working notes load on demand. Fork, trim, and adapt it for your own setup.

## What MindRoom Is

MindRoom is an agent platform that gives long-lived agents structured context, tools, memory, subagents, and skills inside Matrix rooms. This repository does not try to explain the full platform; it shows a practical workspace layout that works well in daily use.

## Repo Layout

- `dev-agent/` — a development agent modeled after MindRoom's own `DevAgent`, built around the [`baspowers`](https://github.com/basnijholt/baspowers) skill library and MindRoom's native subagents (`run_subagent` / `continue_subagent`).
  - `dev-agent/config.yaml` — sample MindRoom `agents:` snippet (single preloaded context file, self-delegation, deferred tools, file memory, skill learning, optional prompt curation).
  - `dev-agent/AGENTS.md` — the **only** preloaded context file (`context_files: [AGENTS.md]`), holding concise operating rules, delegation/review policy, and hard rules.
  - `dev-agent/MEMORY.md` — curated, low-churn long-term memory (`<200` lines, preloaded by `memory_backend: file`).
  - `dev-agent/memory/` — per-thread status logs (`threads-YYYY-MM.md`) and topical notes searched on demand via `memory`.
  - `dev-agent/ARCHITECTURE.md` and `dev-agent/TOOLS.md` — on-demand project and service references (not preloaded every turn).
  - `dev-agent/skills/` — workspace skills directory (install `baspowers` here, plus project-specific skills like the included `developing-example-app` template).

## The Lean Workspace Pattern

Earlier agent workspaces often preloaded half a dozen persona files (`IDENTITY.md`, `SOUL.md`, `AGENTS.md`, `ARCHITECTURE.md`, `TOOLS.md`, `MEMORY.md`) on every turn. That wastes context, multiplies prompt-cache invalidations across parallel threads, and invites conflicting rules.

Instead, this layout separates **always-loaded** from **on-demand**:

| Layer | Loaded when | Purpose |
|---|---|---|
| `AGENTS.md` | Every standard turn (`context_files`) | Operating rules, delegation/review policy, reply style, hard rules |
| `MEMORY.md` | Every standard turn (`memory_backend: file`) | Short (`<200` lines), durable lessons that change rarely |
| `skills/<name>/SKILL.md` | On demand (`get_skill_instructions`) | Composable workflows (`baspowers`) and project-specific runbooks |
| `ARCHITECTURE.md`, `TOOLS.md` | On demand (`read_file`) | Repo map, services, commands, and environment caveats |
| `memory/*.md` | Automatic match recall on standard turns, plus explicit `memory` / `search_memories` | Thread status logs (`threads-YYYY-MM.md`) and deeper topical notes (keyword search by default; optional semantic mode) |

## How To Use

1. Copy the contents of `dev-agent/` (including `.gitignore`, excluding `config.yaml`) into your MindRoom agent workspace (for example `~/.mindroom/mindroom_data/agents/dev/workspace/`).
2. Install the [`baspowers`](https://github.com/basnijholt/baspowers) skills into `"$WORKSPACE/skills/"` as **real directories** (MindRoom does not follow symlinks inside `skills/`):

   ```bash
   WORKSPACE=~/.mindroom/mindroom_data/agents/dev/workspace
   git clone --depth 1 https://github.com/basnijholt/baspowers /tmp/baspowers
   cp -R /tmp/baspowers/skills/* "$WORKSPACE/skills/"
   ```

   > Prefer manual approval gates at each workflow stage? You can use [obra/superpowers](https://github.com/obra/superpowers) instead — update the bootstrap line in `AGENTS.md` and remove or replace the `baspowers`-only skill references (`consulting-cross-model`, `stopping-runaway-prs`, `scoring-pull-requests`).

3. Merge `dev-agent/config.yaml` into your MindRoom `config.yaml` and replace the placeholder model names, room keys, and Matrix user IDs.
4. Replace the `<placeholders>` in `AGENTS.md`, `ARCHITECTURE.md`, `TOOLS.md`, and `skills/developing-example-app/SKILL.md` with your real repos and commands.

## Contributing

Additional public-safe example agents are welcome by pull request. The bar is:

- useful outside one private setup
- stripped of secrets, private hostnames, and personal infrastructure
- concrete enough to copy into a real MindRoom workspace
