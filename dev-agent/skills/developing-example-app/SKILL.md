---
name: developing-example-app
description: Use when changing code in the example-app repository
---

# Developing `example-app`

Replace this template with the repo-specific commands, architecture invariants, and verification checks for your own project. Keep generic process rules in `baspowers` skills and `AGENTS.md`.

## Setup

1. Create a fresh worktree from `origin/main`:

   ```bash
   git -C <repos-root>/<project-name> fetch origin
   git -C <repos-root>/<project-name> worktree add <worktrees-root>/<project-name>-<topic> -b <branch> origin/main
   ```

2. Install or sync dependencies inside the worktree's isolated environment (never into the MindRoom runtime's `VIRTUAL_ENV`).

## Checks Before Opening a PR

1. Run the targeted test suite for changed modules:

   ```bash
   <targeted-test-command>
   ```

2. Run lint, formatting, and type checks on changed files:

   ```bash
   <lint-and-typecheck-command>
   ```

3. For UI-visible changes, capture before/after screenshots using invented placeholder data and attach them to the PR.
4. For non-trivial changes, run a throwaway live smoke test before reporting ready.
