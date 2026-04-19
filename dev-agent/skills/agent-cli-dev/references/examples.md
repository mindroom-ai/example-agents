# Parallel Agent Workflows — Examples

## Key Rules

- always provide the prompt at launch with `-p` or `-P`
- always use `--tmux-session <name>`
- use `-P` for multi-line prompts to avoid shell quoting failures

## Prompt Structure

Good prompts usually contain:

1. the exact task
2. the workflow expectations
3. the files or directories to read first
4. the reason the change matters
5. the scope limit
6. the required report output

## Scenarios

### 1. Review The Current Branch

```bash
agent-cli dev new review-changes --tmux-session review-changes --from HEAD -P /tmp/review.md
```

Prompt guidance:

- run `git diff origin/main...HEAD`
- review correctness, tests, clarity, and scope discipline
- write the result to `.claude/REPORT.md`

### 2. Independent Feature Work

```bash
agent-cli dev new auth-feature --tmux-session auth-feature -P /tmp/auth.md
agent-cli dev new payments-feature --tmux-session payments-feature -P /tmp/payments.md
agent-cli dev new email-feature --tmux-session email-feature -P /tmp/email.md
```

Use this when the branches can evolve independently.

### 3. Test-First Two-Step

```bash
agent-cli dev new cache-tests --tmux-session cache-tests -P /tmp/cache-tests.md
agent-cli dev new cache-impl --tmux-session cache-impl --from HEAD -P /tmp/cache-impl.md
```

Agent one writes the tests. Agent two implements against them.

### 4. Large Refactor By Module

```bash
agent-cli dev new refactor-users --tmux-session refactor-users -P /tmp/refactor-users.md
agent-cli dev new refactor-billing --tmux-session refactor-billing -P /tmp/refactor-billing.md
```

Keep file ownership disjoint.

### 5. Docs And Code In Parallel

```bash
agent-cli dev new plugin-system --tmux-session plugin-system -P /tmp/plugin-system.md
agent-cli dev new plugin-docs --tmux-session plugin-docs -P /tmp/plugin-docs.md
```

One agent implements. Another writes the docs against the agreed design.

### 6. Same-Branch Multi-Reviewer Setup

```bash
agent-cli dev new review-auth --tmux-session review-auth --from HEAD
agent-cli dev agent review-auth --tmux-session review-auth -P /tmp/review-security.md
agent-cli dev agent review-auth --tmux-session review-auth -P /tmp/review-performance.md
agent-cli dev agent review-auth --tmux-session review-auth -P /tmp/review-tests.md
```

Same worktree, separate lenses, unique output files.

## Reviewing Results

```bash
agent-cli dev status
agent-cli dev run <name> cat .claude/REPORT.md
agent-cli dev editor <name>
```

