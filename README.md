# MindRoom Example Agents

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![MindRoom](https://img.shields.io/badge/MindRoom-docs-blue)](https://docs.mindroom.chat/)
[![Agents](https://img.shields.io/badge/docs-agents-blue)](https://docs.mindroom.chat/configuration/agents/)
[![Skills](https://img.shields.io/badge/skills-baspowers-purple)](https://github.com/basnijholt/baspowers)

<picture>
  <source media="(prefers-reduced-motion: no-preference)" srcset="https://raw.githubusercontent.com/mindroom-ai/mindroom/main/assets/logo/logo-mark-animated.svg" />
  <img src="https://raw.githubusercontent.com/mindroom-ai/mindroom/main/assets/logo/logo-mark.svg" alt="MindRoom Logo" align="right" width="120" />
</picture>

Public, sanitized example agent workspaces for [MindRoom](https://github.com/mindroom-ai/mindroom) — designed to keep the always-loaded prompt tiny and cache-friendly while workflows, tools, and project knowledge load on demand.

- **One preloaded context file:** only `AGENTS.md` and a short `<200`-line `MEMORY.md` load on standard turns.
- **Composable skills on demand:** built around [`baspowers`](https://github.com/basnijholt/baspowers) (`using-baspowers` loads the right workflow per task).
- **Native cross-model subagents:** implements on one model and runs independent code reviews on two different model families via `run_subagent`.

## Agents

| Agent | What it does | Workflow | Config |
|---|---|---|---|
| **[`dev-agent/`](dev-agent/)** | Autonomous software development agent with worktree isolation, cross-model review loops, PR triage, and PR scoring | [`baspowers`](https://github.com/basnijholt/baspowers) | [`config.yaml`](dev-agent/config.yaml) |

## Workspace at a glance

```text
dev-agent/
├── config.yaml                  # MindRoom plugins + agents.dev snippet (merge into config.yaml)
├── AGENTS.md                    # ⚡ Standard turns — rules, delegation, review policy
├── MEMORY.md                    # ⚡ Standard turns (<200 lines) — durable lessons only
├── ARCHITECTURE.md              # 📖 On demand — repo map, services, test commands
├── TOOLS.md                     # 📖 On demand — git/forge, browser, secrets notes
├── memory/
│   ├── README.md                # 🔍 Recalled & searched — threads-YYYY-MM.md + topics
│   └── .gitkeep
├── skills/
│   ├── README.md                # 🧩 On demand — install baspowers skills here
│   └── developing-example-app/  #    Starter project-specific workspace skill
└── .gitignore                   # Keeps local memory notes & .mindroom/ untracked
```

| Layer | When it loads | What belongs there |
|---|---|---|
| [`AGENTS.md`](dev-agent/AGENTS.md) | Every standard turn (`context_files`) | Operating rules, delegation & review policy, reply style, hard rules |
| [`MEMORY.md`](dev-agent/MEMORY.md) | Every standard turn (`memory_backend: file`) | Curated, low-churn lessons (`<200` lines) |
| [`skills/`](dev-agent/skills/README.md) | On demand (`get_skill_instructions`) | Composable workflows (`baspowers`) and repo-specific runbooks |
| [`ARCHITECTURE.md`](dev-agent/ARCHITECTURE.md), [`TOOLS.md`](dev-agent/TOOLS.md) | On demand (`read_file`) | Stack map, service ports, CLI caveats |
| [`memory/`](dev-agent/memory/README.md) | Auto-recalled matches + `memory` search | Per-thread status (`threads-YYYY-MM.md`) and deeper topic notes |

## Quick start

1. **Copy the workspace** from the repository root into a new MindRoom agent directory (fails safely if `$WORKSPACE` already exists; keeps `.gitignore`, drops the config snippet):

   ```bash
   WORKSPACE=~/.mindroom/mindroom_data/agents/dev/workspace
   mkdir -p "$(dirname "$WORKSPACE")" && mkdir "$WORKSPACE" \
     && cp -R dev-agent/. "$WORKSPACE/" && rm "$WORKSPACE/config.yaml"
   ```

2. **Install `baspowers` skills and required MindRoom plugins** (`baspowers` must be copied as real directories — MindRoom does not follow symlinks inside `skills/`):

   ```bash
   TMP=$(mktemp -d) && git clone --depth 1 https://github.com/basnijholt/baspowers "$TMP" \
     && cp -R "$TMP/skills/"* "$WORKSPACE/skills/" && rm -rf "$TMP"
   mindroom plugins install pull-request-plugin
   mindroom plugins install thread-worktree-plugin
   ```

3. **Enable the agent:** merge `plugins:` and `agents:` from [`dev-agent/config.yaml`](dev-agent/config.yaml) into your MindRoom `config.yaml` (updating `access.users` with your Matrix user ID, plus `model` and `rooms`), then replace `<placeholders>` in `AGENTS.md`, `ARCHITECTURE.md`, `TOOLS.md`, and `skills/developing-example-app/SKILL.md`.

> [!TIP]
> Prefer manual approval gates at each workflow stage? Install [obra/superpowers](https://github.com/obra/superpowers) instead, update the opening line of `AGENTS.md`, and remove or replace the `baspowers`-only skill references (`consulting-cross-model`, `stopping-runaway-prs`, `scoring-pull-requests`).

<details>
<summary><b>Why one context file instead of SOUL.md / IDENTITY.md?</b></summary>

Earlier agent workspaces preloaded five or six persona files (`IDENTITY.md`, `SOUL.md`, `AGENTS.md`, `ARCHITECTURE.md`, `TOOLS.md`, `MEMORY.md`) on every turn. That bloats every request, invites contradicting rules, and causes frequent prompt-cache misses across parallel threads whenever status notes are updated.

Keeping `context_files: [AGENTS.md]` plus a `<200`-line `MEMORY.md` keeps every thread's prefix compact and cache-warm, while `baspowers` skills, `ARCHITECTURE.md`, `TOOLS.md`, and `memory/threads-YYYY-MM.md` load only when needed.

</details>

<details>
<summary><b>Contributing a new example agent</b></summary>

Pull requests for additional public-safe example agents are welcome. Keep submissions:

- useful outside one private setup
- free of secrets, private hostnames, emails, or personal infrastructure
- concrete enough to copy straight into a real MindRoom workspace

</details>
