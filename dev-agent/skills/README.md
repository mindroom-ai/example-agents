# Workspace Skills

MindRoom automatically loads every valid skill directory under `<workspace>/skills/` for the owning agent — no `skills:` allowlist entry in `config.yaml` is required.

## Installing `baspowers`

`dev-agent/AGENTS.md` is built around the [`baspowers`](https://github.com/basnijholt/baspowers) skill library (`using-baspowers`, `brainstorming`, `writing-plans`, `test-driven-development`, `systematic-debugging`, `subagent-driven-development`, `requesting-code-review`, `stopping-runaway-prs`, `scoring-pull-requests`, `verification-before-completion`, and others).

Copy the `baspowers` skill directories into this folder as **real directories** (MindRoom does not follow symlinks inside `skills/`):

```bash
WORKSPACE=~/.mindroom/mindroom_data/agents/dev/workspace
git clone --depth 1 https://github.com/basnijholt/baspowers /tmp/baspowers
cp -R /tmp/baspowers/skills/* "$WORKSPACE/skills/"
```

To update later, pull `/tmp/baspowers` (or re-clone) and copy `skills/*` again.

> If you prefer manual approval gates between every stage instead of autonomous progression, you can install [obra/superpowers](https://github.com/obra/superpowers) instead — update the opening line of `AGENTS.md` and remove or replace the `baspowers`-only skill references (`consulting-cross-model`, `stopping-runaway-prs`, `scoring-pull-requests`).

## Adding Project-Specific Skills

Keep domain-specific runbooks (build quirks, release steps, repo conventions) as separate workspace skills alongside `baspowers` instead of bloating `AGENTS.md`.

See `developing-example-app/SKILL.md` for a minimal starter template:
- directory name matches the frontmatter `name:` (lowercase, hyphenated)
- `description:` is one short trigger-first sentence (≤60 chars works best with `skill_manage`)
- never store literal credentials in skill files
