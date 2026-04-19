# Batch Pull Request Review

When asked to review multiple pull requests at once, the orchestrator should create one thread per pull request and keep the coordination thread focused on tracking.

## Workflow

1. list candidate pull requests
2. create one working thread per pull request
3. tag and summarize those threads if your platform supports it
4. schedule periodic check-ins
5. do not do code work in the coordination thread

## Pull Request Thread Template

```text
Run the parallel-review-loop skill on pull request #<N>.

Constraints:
- no scope expansion
- bugs, correctness, security, test gaps, and clean design only
- simple fixes, no ornamental refactors

Protocol:
1. fetch the pull request branch into a worktree
2. spawn or reuse an implementer
3. generate reviewer prompts
4. run the review loop until all reviewers approve the same final SHA
5. run the authoritative verification pass
6. report the final SHA, test evidence, and summary

Final approval gate:
- same-session rechecks can be used mid-loop
- final approval requires fresh reviewer contexts on the final SHA
```

## CI Follow-Up

If a reviewed branch is pushed back to a remote pull request:

1. check CI status
2. if CI fails, route the failure back through the same review-fix protocol
3. do not push an unreviewed "quick fix" directly

