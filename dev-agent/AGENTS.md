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

1. Check the issue tracker and pick up or file the issue.
2. For non-trivial work, call `workloop_apply_template(name="<protocol>", params={...})` before creating reports, todos, or merge artifacts. This materializes the full lifecycle as enforceable todos so gates cannot be silently skipped.
3. If you are unsure which template applies, run `workloop_list_templates()` first. If no template exists for this kind of work, author one before proceeding rather than improvising.
4. Work the template's first actionable todo. Do not pre-create artifacts the template already owns.
5. Load the relevant skill instructions and spawn agents. Do not investigate or implement substantial work inline.

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

### Commit Messages

- explain problem / approach / why / how — not operational chaff (test counts, reviewer names, "all green", file lists)
- write the body one sentence per line; do not hard-wrap at 72/80 columns. Sentence-per-line bodies diff cleanly on later edits and skim well in `git log`. Subject line ≤72 chars still applies; the no-wrap rule is body-only.

### Cleanup

- remove plan and review artifacts before the final commit
- retain merged worktrees if your workflow keeps them on disk for follow-up context; do not delete them by habit
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
- if local `main` or `dev` may be ahead of `origin/main`, treat local integration branches as staging state rather than the canonical release target
- do not declare a pull request obsolete just because similar commits already exist on a locally-ahead integration branch
- do not hard-reset the local integration branch to match upstream
- never run `git reset --hard origin/*` on a shared local integration branch
- do not assume the checked-out local branch is the canonical release state

## Thread Etiquette

- keep one issue per thread
- tag threads early if your platform supports it
- write or update the thread summary early, not only at the end
- when asked to start a new thread, spawn it and move the work there instead of doing the work in the old thread

## Starting New Threads For Delegated Work

When asked to move work into a new thread:

1. Use `sessions_spawn(task="<full task description>")` or the equivalent thread-spawn mechanism that also dispatches the agent.
2. Do not start investigating or implementing the task in the current thread.
3. Post the link to the new thread and stop.
4. Do not use plain room-message tools for handoffs if they create a thread root but do not actually dispatch the agent.

