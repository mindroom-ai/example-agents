# Parallel Review Prompt Templates

## Reviewer Prompt

Use one file per reviewer, changing only the focus lens and output filename.

```text
You are reviewing commit <SHA>.

Run:
- git diff <base-branch>...HEAD
- any lightweight read-only checks needed for confidence

Review for:
1. correctness
2. security
3. edge cases
4. test adequacy
5. design and simplicity
6. API contract consistency

For each issue, write:

#### Issue N: <title>
- Severity: BLOCKER / MAJOR / MINOR / NIT
- Category: correctness / security / edge-case / test-gap / design / build
- File: path:line
- Problem: concise explanation
- Suggested fix: smallest fix that would address it

End with:
- Verdict: APPROVE or CHANGES REQUIRED

Write the output to REVIEW-<LETTER>.md.

Rules:
- do not read other review files
- do not implement fixes
- name assumptions and environment limits
```

## Diverse-Focus Lenses

Suggested assignments:

- Reviewer A: architecture and boundaries
- Reviewer B: duplication and reuse
- Reviewer C: regression patterns from recent history
- Reviewer D: edge cases and cleanup paths
- Reviewer E: test quality
- Reviewer F: security and correctness
- Reviewer G: API contracts and integration
- Reviewer H: maintainability

## Re-Review Prompt

For broad fresh-context re-review:

```text
You are reviewing commit <NEW_SHA>.

Run `git diff <base-branch>...HEAD` and review it as a fresh code review.
Do not assume previous rounds were correct.
Write the output to REVIEW-<LETTER>.md.
```

For targeted rechecks:

```text
You are reviewing commit <NEW_SHA>.

Pay special attention to these concerns:
1. <concern>
2. <concern>

Also scan the full diff for any new BLOCKER or MAJOR issues.
Write the output to REVIEW-<LETTER>.md.
```

## Implementer Prompt

```text
You are the implementer for this branch.

Read:
- git log <base-branch>..HEAD --oneline
- git diff <base-branch>...HEAD

When review findings arrive:
1. triage each finding as fix-worthy or noise
2. implement the valid fixes
3. run targeted verification
4. commit the result

Stay alive for follow-up rounds.
```

