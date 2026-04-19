# Git History Cleanup

Use this when a branch collected too many commits or agent artifacts and you want to produce one clean commit per issue before merging.

## Goals

- one clear squashed commit per issue or feature
- no temporary plan or review artifacts in the final history
- no accidental secret leakage

## Common Artifact Files To Remove

- `PLAN.md`
- `PLAN-*.md`
- `DEBATE.md`
- `DEBATE-*.md`
- `REPORT.md`
- `REPORT-*.md`
- `REVIEW-*.md`
- `REREVIEW-*.md`
- `.claude/TASK.md`
- `.claude/REPORT.md`
- `.claude/PLAN.md`
- `.beads/`

## Procedure

### 1. Identify The Squash Groups

```bash
cd <project-root>
git log --oneline --reverse <target-branch> --not origin/<target-branch>
```

Group commits by issue reference.

### 2. Build A Clean Branch

```bash
git checkout -b <target-branch>-clean origin/<target-branch>
```

Cherry-pick commits in chronological order and squash same-issue groups.

### 3. Strip Artifacts

Before the final commit, remove temporary files from both the tree and the commit.

### 4. Verify

Checks worth running:

```bash
# no artifact files in the tree
git ls-tree -r HEAD --name-only | grep -E '^(PLAN|DEBATE|REPORT|REVIEW)|^\\.beads|^\\.claude/(TASK|REPORT|PLAN)\\.md$'

# secret scan on the diff
git diff $(git merge-base origin/<target-branch> HEAD)..HEAD | grep -iE '(api.?key|token|password|secret)'
```

Both commands should be empty or manually reviewed.

### 5. Pre-Swap Safety Check

Immediately before replacing a shared integration branch:

```bash
git log <target-branch> --not <target-branch>-clean --oneline
```

If new commits appeared while cleanup was in progress, cherry-pick them first and re-run verification.

### 6. Swap Only With Approval

If your team treats the local integration branch as shared state, get approval before replacing it.

## Commit Message Format

```text
<type>: <summary> (<ISSUE-REF>)
```

Examples:

- `fix: preserve thread focus on refresh (ISSUE-014)`
- `feat: add schedule retry backoff (ISSUE-021)`

