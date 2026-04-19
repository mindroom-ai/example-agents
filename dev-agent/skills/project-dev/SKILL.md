---
name: project-dev
description: Full lifecycle project development with issue tracking, agent-based planning, review loops, live testing, and squash merges. Triggers on "fix issue", "implement feature", "code review", "ISSUE-", and related project work.
---

# Project Development Workflow Skill

Use this skill for real feature work, bug fixes, and pre-merge quality control.

> All substantial development work happens through `agent-cli dev` in git worktrees.

> Every issue gets a living report at `references/reports/<ISSUE-REF>.md`.

## Key Files

- `references/issues.md`: issue tracker and phase tracking
- `references/protocol.md`: plan, review, live-test, merge protocol
- `references/browser-testing.md`: live browser verification patterns
- `references/git-history-cleanup.md`: squash and cleanup procedure
- `references/tool-call-quality.md`: recurring tool-failure analysis template
- `references/reports/`: one living report per issue
- `references/sessions/`: optional session logs
- `references/refactors/`: neutral refactor briefs when the sanity-check gate is needed

## Issue Format

Use `ISSUE-NNN` as the canonical issue reference.

Suggested status values:

- `OPEN`
- `IN PROGRESS`
- `APPROVAL PENDING`
- `CLOSED`

Do not mark an issue fully done until a human verifies it.

## Protocol Flow

1. file or pick up the issue
2. create the living report
3. get two independent plans
4. debate and finalize the plan
5. implement with one persistent implementer
6. run review loops
7. live-test with evidence
8. squash merge
9. mark `APPROVAL PENDING`

## Key Rules

- plan first, code second
- the implementer stays alive through review-fix cycles
- all review claims must point to evidence
- review the final SHA in fresh contexts before final approval
- live test is a hard gate
- push to a backup remote before merge if your workflow uses one

