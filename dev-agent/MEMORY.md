# MEMORY.md

Curated long-term rules and durable facts. Keep this file under **200 lines** and change it rarely — it is preloaded into every thread's system prompt, so frequent edits invalidate prompt caches across parallel threads.

Put per-thread status notes (worktrees, job IDs, review rounds, next steps) in `memory/threads-YYYY-MM.md`, and deeper topical notes in `memory/<topic>.md` (searched on demand via `memory_backend: file`).

## Shell, Git, and Tools

- **Never `git stash` in shared worktrees:** `refs/stash` is shared across every worktree of the same repository. Use a temporary commit or patch file instead, and tell subagents the same.
- **Never dump the environment:** if live tokens or broker credentials exist in shell env vars, never run `env`, `printenv`, `set`, or `env | grep` — include that rule in every subagent brief.
- **Protect the runtime venv:** if the agent shell inherits `VIRTUAL_ENV` from the MindRoom runtime, always `unset VIRTUAL_ENV` or target the worktree's virtualenv explicitly before installing packages so you never mutate the host runtime.
- **File edits:** use `edit_file` (or single-match checks when running in minimal bash-only mode) and review `git diff` afterwards.
- **Shell scripts:** under `set -e`, a failing non-final `&&` command does not abort; put each step on its own line. Guards must fail closed (empty checker output = stop).
- **Config edits:** back up live config before editing, write via temp file + atomic `mv` (never truncate in place), and validate before saving.
- **Timeouts:** set explicit timeouts on slow or hang-prone commands; never sleep-poll in repeated turns.

## Subagents

- **Isolate reviewers from implementers:** reviewers must inspect the diff read-only — never check out branches in the implementer's worktree, and never call `use_worktree` or `link_pull_request` (which re-ties the parent thread).
- **Check output on completion:** if a subagent finishes with empty or truncated text after heavy reasoning, follow up with `continue_subagent` asking for shorter thinking and smaller chunks.
- **Keep history intact:** cancelling a running subagent job before `continue_subagent` can drop turn context; let a short turn finish or start a fresh `run_subagent` with the full brief.
- **Background shell limits:** always set `timeout` in subagent shell briefs and tell children never to search `/`.

## Engineering & Review Lessons

- **One cohesive PR per feature, not a stack of tiny PRs:** group related phases as commits on one branch and review the whole diff at milestones.
- **Confirm the cause before designing:** reproduce bugs with a real trace, log, or screenshot before writing a plan or fix. When a derived status is wrong, audit every writer of that state and establish one source of truth instead of bolting on another layer.
- **Stop at no-regression vs `main`:** state in Round 1 review briefs that parity-with-`main` edge cases are non-blocking comments; decline pre-existing edge cases in a 1-line PR note instead of adding defensive machinery.
- **Re-check scope when a "small" change grows:** soft size targets are fine to exceed slightly (~10–15%), but if a small fix balloons well past its estimate or triggers repeated review rounds, pause and run `stopping-runaway-prs`.
- **Parallel sessions move `main`:** before fixing and again before pushing, `git fetch`, check `git log origin/main -- <touched files>`, and check open PRs for overlapping work.
- **Mocked unit tests miss seam bugs:** when unit tests mock across a module boundary, verify the real integration or end-to-end flow before declaring a change done.

## Project Notes

Add stable, high-value facts specific to your stack here (build quirks, CI timings, known pitfalls), and delete entries once they become obsolete.
