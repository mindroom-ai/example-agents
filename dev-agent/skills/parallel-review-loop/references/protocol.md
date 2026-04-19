# Parallel Review-Fix Loop Protocol

## Philosophy

The goal is not to maximize reviewer volume. The goal is to extract high-signal findings, fix them cleanly, and prove the final SHA is ready.

## Roles

### Orchestrator

- freezes the SHA under review
- writes or requests reviewer prompts
- keeps the issue ledger
- filters out noise before forwarding findings
- runs the authoritative verification pass

### Implementer

- owns the code changes
- stays alive through the review-fix loop
- receives deduped findings
- makes focused fixes
- runs targeted verification before re-review

### Reviewers

- review the assigned SHA
- write findings to unique files
- do not implement fixes
- do not read each other's reports

## Phase 1: Spawn Or Reuse The Implementer

If the implementing agent already exists, keep it. Otherwise:

```bash
agent-cli dev agent <branch> --tmux-session <branch> --agent codex -P /tmp/implementer.md
```

## Phase 2: Generate Reviewer Prompts

Default mode is diverse-focus review. Give each reviewer a distinct lens:

- architecture
- duplication
- regression patterns
- edge cases
- tests
- security and correctness
- API contracts
- long-term maintainability

Uniform review is also valid when you want pure redundancy.

## Phase 3: Review A Frozen SHA

Spawn reviewers against the exact commit under review.

```bash
agent-cli dev agent <branch> --tmux-session <branch> --agent codex -P /tmp/review-a.md
agent-cli dev agent <branch> --tmux-session <branch> --agent codex -P /tmp/review-b.md
agent-cli dev agent <branch> --tmux-session <branch> --agent claude -P /tmp/review-h.md
```

Monitor them, then collect `REVIEW-*.md`.

## Phase 4: Triage Findings

The orchestrator filters before forwarding:

- forward real correctness bugs
- forward concrete test gaps for shipped behavior
- forward clear build or deployment regressions
- drop speculative hardening and abstract style wars

Maintain a simple ledger:

- finding ID
- category
- first seen on SHA
- fixed in SHA
- rechecked by
- status

## Phase 5: Fix

Send the deduped findings to the persistent implementer.

The implementer:

1. triages each finding
2. fixes the valid ones
3. runs targeted tests
4. commits the result

## Phase 6: Re-Review

All approvals must be from the current round.

- broad re-review rounds should use fresh reviewer contexts
- targeted rechecks may reuse the reviewer who raised the issue
- if in doubt, prefer fresh reviewers

## Phase 7: Merge Gate

Merge only when:

- the final SHA is approved in the current round
- the authoritative verification pass is green
- live-test evidence exists if the change needs it

## Heavy Verification Rule

Coverage-heavy or artifact-writing commands should not run in parallel in a shared worktree. Use isolated worktrees if multiple reviewers need heavy verification.

