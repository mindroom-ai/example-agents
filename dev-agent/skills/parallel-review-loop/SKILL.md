# parallel-review-loop

Massive parallel code review with one persistent implementer and a rotating set of reviewer agents.

## When To Use It

- hardening an implementation before merge
- stress-testing a risky change
- narrowing down real bugs versus noisy review comments

## Core Model

- one persistent implementer agent
- N reviewer agents per round
- an orchestrator that owns the issue ledger, the reviewed SHA, and the final verification run

## Critical Rules

### Freeze The Reviewed Commit

Every review round targets an explicit SHA.

- reviewers must be told which SHA they are reviewing
- reports must name that SHA
- findings from different SHAs must not be mixed together

### Keep The Implementer Alive

The implementer should stay alive through the full loop unless it truly loses the thread.

### Fresh Reviewers For Broad Rounds

Broad rounds should usually use fresh reviewers so they are not anchored by previous output. Targeted rechecks may reuse the reviewer who raised the finding.

### Shared Worktree Review Is Read-Mostly

Reviewers sharing a worktree may:

- inspect code
- run diffs
- run lightweight read-only commands

They should not:

- overwrite shared artifact files
- run heavy coverage jobs in parallel
- mutate tracked files during review

### One Authoritative Verification Pass

The orchestrator runs the authoritative build, test, or live-test pass after fixes land. Reviewer test output is advisory.

## Recommended Loop

1. freeze SHA `sha1`
2. spawn reviewers
3. collect and dedupe findings
4. classify them by category and severity
5. send valid findings to the implementer
6. implementer fixes and commits `sha2`
7. orchestrator runs verification on `sha2`
8. all reviewers re-review `sha2`
9. repeat until all reviewers approve in the same round

## Categories To Track Separately

- runtime correctness
- security
- build or packaging regression
- broken or missing tests
- architecture smell
- stale or environment-induced noise

## Escalation Signals

Escalate from "more review rounds" to "architecture rethink" when:

- the same bug class appears across 3 or more SHAs
- fixes keep growing the code without simplifying it
- reviewers converge on the abstraction being wrong rather than the implementation details

