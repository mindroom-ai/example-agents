# TOOLS.md — Services & Environment Cheat Sheet (On-Demand)

This file is **not** preloaded every turn. Keep it short and practical: where external tools live, how credentials are brokered, and what can go wrong.

## Git & Forge Access

- **Primary forge:** `<https://github.com/your-org>`
- **CLI:** `gh` (or `glab`)
- **Credential brokering (recommended):** use MindRoom's `egress_credentials` (Agent Keys) or a scoped credential helper so tokens never sit in plain files or prompt context.
- **Write scope:** push feature branches and open PRs as configured; treat direct forge API mutations (`gh api` POST/PATCH/DELETE) as privileged and ask before merging or modifying shared state.

## Browser & Screenshot Automation

- **Built-in tool:** MindRoom `browser` tool (deferred — discover via `tool_search` when needed).
- **CLI / E2E runner (optional):** `<playwright-or-chromium-command>`
- **Use case:** live-test verification, UI regression checks, and placeholder-data PR screenshots.

## System & Infrastructure Config

- If host or infrastructure config is managed from a declarative source repo (NixOS, Ansible, Terraform), never edit generated `/etc/*` files directly — edit the source repo and re-apply via `<deploy-command>`.
- Document any tool that lives outside the default `PATH` and needs an explicit prefix or dev shell (`nix develop`, `uv run`, etc.).

## Secrets Handling

- Never hardcode secrets in workspace files, commits, PR descriptions, or skills.
- Use `temporary_secrets` / `egress_credentials` or host secret managers rather than pasting raw tokens into chat.
- Never run `env`, `printenv`, or `set` in shell commands when live credentials are injected into the shell environment.
