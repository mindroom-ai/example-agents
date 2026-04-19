# agent-cli dev skill

Spawn AI coding agents in isolated git worktrees for parallel development.

## Commands

**New branch from the default base:**

```bash
agent-cli dev new <branch-name> --tmux-session <branch-name> -p "short task"
```

**Work on the current branch state:**

```bash
agent-cli dev new <branch-name> --tmux-session <branch-name> --from HEAD -p "review or fix task"
```

**Preferred for multi-line prompts:**

```bash
agent-cli dev new <branch-name> --tmux-session <branch-name> -P /tmp/<branch-name>-task.md
```

Always use `--tmux-session <name>`.

- same branch or thread: same session name
- different branches: different session names
- keep names simple; avoid punctuation that tmux dislikes

## Key Rules

- spawn is not complete unless the prompt was delivered at launch
- prefer `-P` for multi-line prompts and `-p` for short prompts
- prompts must be self-contained because the agent works in isolation
- ask the agent to write conclusions to a file such as `.claude/REPORT.md`
- do not worry about agent context percentage; compacting is normal

## Same-Branch Multi-Agent Workflow

```bash
# Create the worktree once
agent-cli dev new review-auth --tmux-session review-auth --from HEAD

# Launch more agents into the same worktree
agent-cli dev agent review-auth --tmux-session review-auth -P /tmp/review-security.md
agent-cli dev agent review-auth --tmux-session review-auth -P /tmp/review-performance.md
```

Rules for shared worktrees:

- use `dev agent`, not `dev new`, once the worktree exists
- use separate report filenames per agent
- assume `.claude/TASK.md` is shared scratch state and can be overwritten
- avoid editing the same tracked files from multiple agents at once

## Useful Options

| Option | Purpose |
|--------|---------|
| `--start-agent` | start without an initial prompt |
| `-p` | short prompt inline |
| `-P` | prompt file |
| `--from HEAD` | base the new worktree on the current branch state |
| `--agent` | choose `codex`, `claude`, or another configured agent |
| `--tmux-session` | stable session name for tracking |

## Operational Notes

### Verify Launch

Check the agent immediately after spawning:

```bash
tmux capture-pane -t <session-name> -p | tail -20
```

Look for:

- trust prompts
- auth errors
- empty output
- a task that never started

### Dead Agent Recovery

If the agent process died but the worktree is still useful:

```bash
agent-cli dev agent <branch-name> --tmux-session <branch-name> --agent codex
```

Do not delete and recreate the worktree unless you are sure nothing valuable is left there.

### Cleanup

- `tmux kill-window` stops the agent but keeps the worktree
- `agent-cli dev rm <branch>` removes the worktree permanently
- `agent-cli dev clean --merged` is useful once branches are merged

## Status And Results

```bash
agent-cli dev status
agent-cli dev run <branch-name> cat .claude/REPORT.md
agent-cli dev editor <branch-name>
```

