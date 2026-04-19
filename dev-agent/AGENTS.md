# AGENTS.md — DevAgent Operating Procedures

## Every Session Startup

1. Read the loaded context files: `IDENTITY.md`, `SOUL.md`, `AGENTS.md`, `ARCHITECTURE.md`.
2. Read `MEMORY.md` for stable project knowledge.
3. Read today's and yesterday's notes in `memory/` for recent context.
4. Check the issue tracker and any open living reports before starting new work.

## Memory System

- `MEMORY.md`: durable patterns, operator preferences, architectural rules
- `memory/YYYY-MM-DD.md`: daily notes, temporary context, current threads
- `skills/project-dev/references/issues.md`: backlog and phase tracking
- `skills/project-dev/references/reports/<ISSUE-REF>.md`: living reports

Always write important state to files. Never rely on conversational memory.

## Development Workflow

### Starting Work

1. Load the `project-dev` skill instructions.
2. Check the issue tracker.
3. Pick up or file an issue.
4. Create `skills/project-dev/references/reports/<ISSUE-REF>.md`.
5. Spawn agents. Do not investigate or implement substantial work inline.

### Spawning Agents

Use placeholders from `ARCHITECTURE.md` and adapt them to your project:

```bash
# Backend or core app work
cd <project-root>
agent-cli dev new <branch> --agent codex -m tmux --tmux-session <branch> -P /tmp/<branch>-task.md

# Existing branch, same worktree
agent-cli dev agent <branch> --agent codex -m tmux --tmux-session <branch> -P /tmp/<branch>-followup.md

# Current branch review or fix work
agent-cli dev new <branch> --agent codex -m tmux --tmux-session <branch> --from HEAD -P /tmp/<branch>-task.md
```

Rules:

- always use `--tmux-session <branch>`
- always provide the prompt at launch with `-p` or `-P`
- keep the same implementer alive through fix cycles
- only replace the implementer if it truly exhausted the useful context

### Monitoring

- after spawning, verify the agent actually started
- use `schedule("in 10 minutes check <branch>")`
- inspect progress with `tmux capture-pane -t <session-name> -p | tail -50`
- never use sleep-based polling loops

### Merge Prep

Before merge:

1. read the final diff against the issue brief
2. confirm review approval happened on the current SHA
3. confirm live-test evidence exists
4. confirm there are no stray artifact files in the branch

Prefer squash merges:

```bash
cd <project-root>
git merge --squash <branch>
git commit -m 'fix: <summary> (<ISSUE-REF>)'
```

If you use the included helper, adapt and run:

```bash
skills/project-dev/scripts/safe-squash-merge.sh <branch> 'fix: <summary> (<ISSUE-REF>)'
```

### Cleanup

- remove plan and review artifacts before the final commit
- delete finished worktrees only after the merge is complete
- keep the report and issue tracker updated

## Safety

- ask before destructive commands
- prefer `trash` over `rm` when the environment supports it
- do not restart production services without approval
- do not kill tmux sessions you did not create
- do not send broad room-level updates when the work belongs in a thread

## Git Workflow Pattern

If your local integration branch intentionally diverges from `origin/main`, document that fact in `ARCHITECTURE.md` and honor it consistently:

- compare pull requests against `origin/main`
- do not hard-reset the local integration branch to match upstream
- do not assume the checked-out local branch is the canonical release state

## Thread Etiquette

- keep one issue per thread
- tag and summarize threads early if your platform supports it
- when asked to start a new thread, spawn it and move the work there instead of doing the work in the old thread

