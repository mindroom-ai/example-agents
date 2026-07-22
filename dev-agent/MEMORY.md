# MEMORY.md — Long-Term Memory Template

This file is for facts that should survive across sessions. Keep it curated. If something is only useful today, put it in `memory/YYYY-MM-DD.md` instead.

## Operator Preferences

- builder-first
- evidence over intuition
- clear diffs over elaborate explanations
- minimalism over speculative flexibility
- direct communication over soft framing
- if it matters later, write it to a file

## Project Rules Worth Remembering

- live test is a hard gate before merge
- plan first, then implementation
- use `schedule()` instead of sleep-polling
- never force-push shared branches
- never hard-reset shared integration branches
- final approval needs a fresh review pass on the final SHA
- if a backup remote exists, push the approved review branch there before merge

## Architecture Notes

Document only stable facts here:

- repo roots and worktree roots
- safe vs unsafe services to restart
- branch model and merge rules
- recurring failure modes
- benchmarks or measurements that changed decisions

## Review And Performance Heuristics

- performance work requires a preserved before-and-after benchmark, not theoretical claims alone
- if multiple review rounds keep finding the same bug class, stop patching symptoms and question the abstraction
- when several reports exist, synthesize them into one recommendation instead of asking the operator to arbitrate raw reviewer output
- filter reviewer feedback: forward real correctness bugs and missing tests, drop speculative hardening and hypothetical edge cases

## Boundary Patterns

- if the repo uses interface-enforcement tooling, keep the declared public surface and the package export surface in sync
- once a boundary exists, route cross-domain imports through the package root instead of private internals

## Live Test Is A Hard Gate — No Exceptions

- reviewer approvals only confirm "the code does what the plan says" — they say nothing about whether the plan solves the user's actual problem
- never bypass the live test because approvals look sufficient; the orchestrator runs the live test and attaches evidence before merge
- reproduction-first: before planning a bug fix, capture a real repro of the reported symptom (recording, trace, screenshot) and make all planners and reviewers work against that repro, not a written description
- include the original bug report verbatim in the reviewer prompt so reviewers can check spec-vs-bug, not just code-vs-spec
- if you cannot personally observe the reported symptom in a repro, stop and ask for one — do not let theoretical planning fill the evidence gap

## Inspect The Real Artifact, Not A Stale Copy

- when a system edits records in place (message edits, versioned documents, cached snapshots), the first thing you fetch is often the original, not what the user actually sees
- always resolve to the latest version before analyzing a rendering or content bug; a fix built on the pre-edit artifact investigates the wrong data
- self-check before any content/rendering investigation: "am I looking at the exact bytes the user sees right now?"

## Tool-Call Discipline

- set an explicit generous timeout up front for known-slow commands (test suites, builds, full-tree searches, first-time dependency installs); the default timeout wastes a turn and backgrounds the process
- run ad-hoc scripts through the project's environment/venv, not a bare interpreter, or you hit missing-dependency errors
- if a known tool reports "command not found" or an env var is missing, fix it structurally in config (PATH/env passthrough) rather than working around it every call
- silent failures (a call returns success while the body carries an error) usually outnumber hard failures by a wide margin — inspect result bodies, don't trust the status flag alone

## Spawn From The Right Directory, With Distinct Session Names

- worktree/agent spawn tools resolve the source repo from the current working directory — `cd` into the actual project root first, or you create a worktree of the wrong repo
- give the implementer session a distinct name from reviewer sessions (e.g. `<branch>-impl` vs `<branch>-rev-*`); overlapping names let a new agent hijack the running one

## Skills In This Workspace

### agent-cli-dev

Spawning and managing coding agents in git worktrees.

### project-dev

Full lifecycle issue handling: plan, debate, implement, review, live test, merge, report.

### parallel-review-loop

Large review-fix loops with one persistent implementer and multiple reviewers.

### transcribe

Audio transcription through a local or self-hosted speech-to-text endpoint with a cloud fallback.

## How To Maintain This File

- promote stable lessons from daily notes into this file
- rewrite war stories into reusable rules
- delete stale facts instead of accumulating them forever

