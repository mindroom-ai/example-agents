# DevAgent

`dev-agent/` is a worked example of a MindRoom development agent built around the [`baspowers`](https://github.com/basnijholt/baspowers) skill library and MindRoom's native subagents (`run_subagent` / `continue_subagent`).

## How It Works

- **Minimal always-loaded prompt:** On standard turns, only `AGENTS.md` (via `context_files`) and a short `MEMORY.md` (via `memory_backend: file`) are preloaded. Workflow protocols live in `skills/`, and stack/service details live in `ARCHITECTURE.md` and `TOOLS.md` to be read on demand. Minimal-mode subagents skip preloaded context files and receive only the task brief (plus optional `minimal_instructions`).
- **Skill-driven workflow (`baspowers`):** At the start of each task, the agent loads `using-baspowers` and follows the matching process skills (`brainstorming`, `writing-plans`, `systematic-debugging`, `test-driven-development`, `subagent-driven-development`, `requesting-code-review`, `stopping-runaway-prs`, `scoring-pull-requests`, `verification-before-completion`, and others).
- **Native cross-model subagents:** With `delegate_to: [dev]`, the agent spawns fresh copies of itself using `run_subagent(..., minimal=true)` — implementing on one model and running independent code reviews on two models from different families, with clear blocking criteria and a stop-and-simplify cap.
- **Deferred tools:** Frequently used tools (`shell`, `coding`, `matrix_message`) stay loaded; everything else (`todo`, `memory`, `browser`, `scheduler`, `workflow`, thread tools, secret helpers) loads on demand with `defer: true`.
- **Cache-friendly memory:** `MEMORY.md` stays under ~200 lines for durable rules only, while per-thread status notes go in `memory/threads-YYYY-MM.md` so editing status does not cold-rewrite prompt caches across parallel threads.

## Quick Start

1. Copy the contents of `dev-agent/` (including `.gitignore`, excluding `config.yaml`) into your agent's MindRoom workspace (e.g. `~/.mindroom/mindroom_data/agents/dev/workspace/`).
2. Install the `baspowers` skills into `"$WORKSPACE/skills/"` as real directories (MindRoom does not follow symlinks inside `skills/`):

   ```bash
   WORKSPACE=~/.mindroom/mindroom_data/agents/dev/workspace
   git clone --depth 1 https://github.com/basnijholt/baspowers /tmp/baspowers
   cp -R /tmp/baspowers/skills/* "$WORKSPACE/skills/"
   ```

3. Merge `dev-agent/config.yaml` into your MindRoom `config.yaml`, adjusting `model`, `rooms`, `access`, and any optional plugins.
4. Customize `<placeholders>` in `AGENTS.md`, `ARCHITECTURE.md`, `TOOLS.md`, and `skills/developing-example-app/SKILL.md` for your repositories and toolchain.
