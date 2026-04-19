#!/usr/bin/env bash
# safe-squash-merge.sh
#
# Verifies a squash merge in an isolated scratch worktree before touching the
# live target branch. If the dry-run conflicts, the real branch is left alone.
#
# Usage:
#   safe-squash-merge.sh <feature-branch> <commit-subject> [<commit-body>]

set -euo pipefail

if [[ $# -lt 2 || $# -gt 3 ]]; then
    echo "usage: $0 <feature-branch> <commit-subject> [<commit-body>]" >&2
    exit 1
fi

FEATURE_BRANCH="$1"
SUBJECT="$2"
BODY="${3:-}"

REPO="${PROJECT_REPO:-$(pwd)}"
TARGET_BRANCH="${TARGET_BRANCH:-main}"

if [[ ! -d "$REPO/.git" ]]; then
    echo "error: $REPO is not a git repo (set PROJECT_REPO to override)" >&2
    exit 1
fi

cd "$REPO"

if ! git rev-parse --verify --quiet "refs/heads/$FEATURE_BRANCH" >/dev/null \
   && ! git rev-parse --verify --quiet "refs/remotes/origin/$FEATURE_BRANCH" >/dev/null; then
    echo "error: branch '$FEATURE_BRANCH' not found locally or on origin" >&2
    exit 1
fi

git checkout "$TARGET_BRANCH" >/dev/null
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "error: target branch has uncommitted changes; refusing to merge" >&2
    git status --short >&2
    exit 4
fi

TARGET_SHA_BEFORE="$(git rev-parse HEAD)"
echo "[safe-squash-merge] target branch HEAD: $TARGET_SHA_BEFORE"

SCRATCH="$(mktemp -d -t project-mergecheck-"$FEATURE_BRANCH"-XXXXXX)"
cleanup() {
    git worktree remove --force "$SCRATCH" >/dev/null 2>&1 || true
    rm -rf "$SCRATCH" 2>/dev/null || true
}
trap cleanup EXIT

echo "[safe-squash-merge] creating scratch worktree at $SCRATCH"
git worktree add --detach "$SCRATCH" "$TARGET_BRANCH" >/dev/null

(
    cd "$SCRATCH"
    if ! git merge --squash "$FEATURE_BRANCH" --no-commit >/tmp/safe-squash-merge.dryrun.log 2>&1; then
        echo "[safe-squash-merge] DRY-RUN FAILED — conflicts detected:" >&2
        cat /tmp/safe-squash-merge.dryrun.log >&2
        echo >&2
        echo "Conflicting paths:" >&2
        git diff --name-only --diff-filter=U >&2 || true
        exit 2
    fi
    UNMERGED="$(git diff --name-only --diff-filter=U)"
    if [[ -n "$UNMERGED" ]]; then
        echo "[safe-squash-merge] DRY-RUN FAILED — unmerged paths:" >&2
        echo "$UNMERGED" >&2
        exit 2
    fi
    echo "[safe-squash-merge] dry-run clean."
)

TARGET_SHA_NOW="$(git rev-parse HEAD)"
if [[ "$TARGET_SHA_NOW" != "$TARGET_SHA_BEFORE" ]]; then
    echo "error: target branch moved during dry-run ($TARGET_SHA_BEFORE -> $TARGET_SHA_NOW); aborting" >&2
    exit 3
fi

echo "[safe-squash-merge] performing real squash merge on $TARGET_BRANCH"
if ! git merge --squash "$FEATURE_BRANCH" >/tmp/safe-squash-merge.real.log 2>&1; then
    echo "error: real merge unexpectedly conflicted" >&2
    cat /tmp/safe-squash-merge.real.log >&2
    git merge --abort 2>/dev/null || git reset --hard "$TARGET_SHA_BEFORE"
    exit 3
fi

UNMERGED="$(git diff --name-only --diff-filter=U)"
if [[ -n "$UNMERGED" ]]; then
    echo "error: real merge produced unmerged paths despite clean dry-run" >&2
    echo "$UNMERGED" >&2
    git merge --abort 2>/dev/null || git reset --hard "$TARGET_SHA_BEFORE"
    exit 3
fi

if [[ -n "$BODY" ]]; then
    git commit -m "$SUBJECT" -m "$BODY"
else
    git commit -m "$SUBJECT"
fi

NEW_SHA="$(git rev-parse HEAD)"
echo "[safe-squash-merge] merged cleanly: $NEW_SHA"
echo "[safe-squash-merge] subject: $SUBJECT"

