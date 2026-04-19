# example-agents

Public, sanitized example agent workspaces for [MindRoom](https://github.com/mindroom-ai/mindroom).

This repository shows how to structure an agent workspace so the persona, operating rules, project knowledge, and reusable skills stay separate instead of collapsing into one oversized prompt. It is intended as a worked example you can fork, trim, and adapt for your own setup.

## What MindRoom Is

MindRoom is an agent platform that lets you give long-lived agents structured context, tools, memory, and skills. This repository does not try to explain the full platform; it shows one practical workspace pattern that fits well inside it.

## Repo Layout

- `dev-agent/` contains the first example agent, a development orchestrator that manages coding agents, review loops, reports, and live-test gates.
- `dev-agent/IDENTITY.md` defines who the agent is.
- `dev-agent/SOUL.md` defines how the agent behaves and what principles it protects.
- `dev-agent/AGENTS.md` defines operating procedures.
- `dev-agent/ARCHITECTURE.md` and `dev-agent/TOOLS.md` hold project-specific context and service notes.
- `dev-agent/MEMORY.md` and `dev-agent/memory/` show the long-term and day-by-day memory pattern.
- `dev-agent/skills/` contains reusable skills you can copy into your own workspace.

## How To Use

1. Clone this repository into `~/.mindroom/agents/<your-agent>/workspace/`.
2. Rename or duplicate `dev-agent/` for your own agent.
3. Rewrite `IDENTITY.md`, `SOUL.md`, `AGENTS.md`, `ARCHITECTURE.md`, `TOOLS.md`, and `MEMORY.md` for your project.
4. Keep the skills you want, delete the rest, and update the placeholder paths and commands.
5. Point your MindRoom agent config at the workspace.

## The Persona Pattern

The split is deliberate:

- `IDENTITY.md`: who the agent is and what job it owns
- `SOUL.md`: values, boundaries, decision rules, and communication style
- `AGENTS.md`: operational procedures and command patterns
- `ARCHITECTURE.md`: project map and deployment model
- `TOOLS.md`: service endpoints, utilities, and caveats
- `MEMORY.md`: durable facts worth carrying forward
- `memory/YYYY-MM-DD.md`: short-lived daily notes

That separation makes updates safer. You can change the project stack without rewriting the persona, or tighten behavioral rules without touching daily memory.

## Contributing

Additional public-safe example agents are welcome by pull request. The bar is:

- useful outside one private setup
- stripped of secrets and personal infrastructure
- concrete enough to copy into a real workspace

