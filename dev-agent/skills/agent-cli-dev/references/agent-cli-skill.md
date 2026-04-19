# agent-cli dev — Operational Cheatsheet

## Common Commands

| Task | Command |
|------|---------|
| New branch | `agent-cli dev new <branch> --tmux-session <branch> -p "..."` |
| New branch from current HEAD | `agent-cli dev new <branch> --tmux-session <branch> --from HEAD -p "..."` |
| Existing worktree | `agent-cli dev agent <branch> --tmux-session <branch> -P /tmp/task.md` |
| Resume a stopped agent | `agent-cli dev agent <branch> --tmux-session <branch> --agent codex` |
| Status | `agent-cli dev status` |
| Read report | `agent-cli dev run <branch> cat .claude/REPORT.md` |
| Open editor | `agent-cli dev editor <branch>` |

## Non-Negotiables

- always use `--tmux-session`
- always deliver the prompt at launch with `-p` or `-P`
- do not treat context percentage as a blocker
- keep implementers alive through follow-up rounds when possible

## Tracking

Use session names for stable monitoring:

```bash
tmux capture-pane -t <session-name> -p | tail -20
tmux list-panes -s -t <session-name> -F '#{pane_id}:#{window_index}:#{window_name}'
```

Pane IDs are useful for low-level tmux actions. Session names are what keep the overall workflow legible.

## Shared Worktree Gotchas

- `.claude/TASK.md` is shared scratch state
- report files should be unique per agent
- read-only work is easy to parallelize
- overlapping edits in the same worktree are where confusion starts

## Capacity

Parallelism is usually limited by:

- CPU and memory
- the number of simultaneous builds or test suites
- git conflicts on shared files

Not by the raw existence of the agent processes themselves.

