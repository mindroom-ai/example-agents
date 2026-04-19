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

