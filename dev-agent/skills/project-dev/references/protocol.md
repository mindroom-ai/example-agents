# Project Development Protocol

This protocol is opinionated on purpose. It exists to keep development work deterministic, reviewable, and recoverable across long-running threads.

## Code Style Mandate

- no backward-compat shim unless there is a concrete requirement for it
- no new options nobody asked for
- no speculative abstractions
- no defensive code for impossible callers
- prefer deleting complexity over wrapping it
- prefer shorter, clearer diffs over "future-proof" structure

The working question is:

> What is the smallest, clearest version of this change that solves the real problem?

## Inline-Work Latitude

The orchestrator may read code and diffs aggressively.

The orchestrator may only implement inline when the change is truly trivial:

- typo
- one obviously wrong default
- one dead line removal

Anything larger should be delegated to a coding agent.

## Refactor Sanity Check

Run this whenever a proposed refactor goes beyond the immediate issue.

### Auto-accept conditions

A refactor can be approved directly if all of the following are true:

1. net diff is shorter
2. behavior is preserved except for the bug removal or dead-code deletion
3. existing tests still pass
4. the result is plainly simpler

Document the evidence in the issue report.

### Two-advisor gate

If the refactor is net-additive or structurally broader:

1. write a neutral brief in `references/refactors/<ISSUE-REF>-<slug>.md`
2. ask two independent advisors in fresh contexts
3. proceed only if they converge on approval or on the same smaller alternative
4. otherwise, do not refactor

## Test Commands

Document your project's real commands in `ARCHITECTURE.md`. Typical placeholders:

```bash
cd <project-root>
<unit-test-command>

cd <frontend-root>
<frontend-test-command>
```

If your environment requires a wrapper shell, container, or virtualenv, document that once and keep using it consistently.

## Agent Types

Typical setup:

- `--agent codex` for implementation and most reviews
- `--agent claude` as a second planning or review voice

Use your configured defaults. The protocol matters more than the brand mix.

## Flow

Plan -> plan debate -> finalized plan -> implement -> review loop -> live test -> squash merge -> human approval

## Scheduled Follow-Ups, Not Sleep Polling

After spawning agents:

1. verify they started
2. schedule a follow-up check
3. end the turn

Example:

```bash
agent-cli dev new <branch> --tmux-session <branch> --agent codex -P /tmp/<branch>.md
schedule("in 10 minutes check progress on <branch>")
```

Monitoring rule:

- if the agent is still running, schedule another check
- if it finished, process the result and move to the next phase

## Phase 0: Dual-Agent Planning

Create the living report immediately.

### Planner A

```bash
agent-cli dev new <branch> --tmux-session <branch> --agent codex -P /tmp/<branch>-plan-a.md
```

Prompt summary:

- read the issue
- inspect the relevant code
- write `PLAN.md`
- do not implement

### Planner B

```bash
agent-cli dev agent <branch> --tmux-session <branch> --agent claude -P /tmp/<branch>-plan-b.md
```

Prompt summary:

- same task
- independent plan
- write `PLAN-B.md`

### Plan Debate

Spawn two debate agents or one debate agent, whichever fits your setup. Their only job is to compare `PLAN.md` and `PLAN-B.md`, identify the stronger direction, and write `PLAN-DEBATE.md`.

### Finalize Plan

Feed the debate result back to Planner A and have it produce the final `PLAN.md`.

The first commit on the branch should usually be the final plan.

## Phase 1: Implement

Keep Planner A alive as the implementer if possible.

Implementation prompt must include:

- implement only the agreed plan
- write tests
- update the issue report
- produce `REPORT.md`
- include live-test instructions so the agent knows this gate exists from the start

Commit before review. Uncommitted work is invisible to diff-based reviewers.

## Phase 2: Review

Run reviewers against an explicit SHA.

Rules:

- reviewers should not know the round number
- reviewers should not read each other's files
- reviewers should distinguish real bugs from tooling noise
- reviewers should write to unique output files

Use `parallel-review-loop` for larger or riskier changes.

## Phase 3: Fix

If reviewers request changes:

1. dedupe and filter the findings
2. send only the valid ones to the persistent implementer
3. have the implementer fix, test, and commit
4. run another review round on the new SHA

If the implementer is truly exhausted, spawn a fresh one with the plan, diff, and findings attached.

## Phase 4: Live Test

This is a hard gate.

Live testing means:

1. exercising the changed behavior in a real environment
2. capturing evidence with screenshots or terminal output
3. attaching or recording that evidence in the report or thread

Read `browser-testing.md` for web or client flows.

If live testing cannot be run because the environment is unavailable, a human must explicitly waive the gate.

## Phase 5: Merge

Before merge:

- verify the final diff matches the approved plan
- verify fresh-context review approval on the final SHA
- verify live-test evidence exists
- remove artifact files from the branch

Preferred merge:

```bash
cd <project-root>
git merge --squash <branch>
git commit -m 'fix: <summary> (<ISSUE-REF>)'
```

If you use a backup remote, push the reviewed branch there before the squash merge.

After merge:

- clean up the worktree
- update the issue to `APPROVAL PENDING`
- keep the report intact

## Final Approval Rule

Intermediate re-reviews may happen in continuing sessions.

Final approval does not count until reviewers inspect the final SHA in fresh contexts. This avoids approval bias from stale memory.

