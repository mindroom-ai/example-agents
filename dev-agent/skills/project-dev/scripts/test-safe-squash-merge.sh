#!/usr/bin/env bash
# Test harness for safe-squash-merge.sh

set -uo pipefail

SCRIPT="${SAFE_MERGE_SCRIPT:?must export SAFE_MERGE_SCRIPT=/path/to/safe-squash-merge.sh}"

if [[ ! -x "$SCRIPT" ]]; then
    echo "FAIL: $SCRIPT not executable" >&2
    exit 1
fi

PASS=0
FAIL=0

fresh_repo() {
    local dir="$1"
    rm -rf "$dir"
    mkdir -p "$dir"
    cd "$dir"
    git init -q -b main
    git config user.email test@example.com
    git config user.name test
    echo "line1" > file.txt
    echo "shared1" > shared.txt
    git add -A
    git commit -q -m 'initial'
}

assert_exit() {
    local label="$1" expected="$2" actual="$3"
    if [[ "$actual" == "$expected" ]]; then
        echo "  PASS: $label (exit $actual)"
        PASS=$((PASS + 1))
    else
        echo "  FAIL: $label (expected $expected, got $actual)"
        FAIL=$((FAIL + 1))
    fi
}

assert_contains() {
    local label="$1" needle="$2" haystack="$3"
    if [[ "$haystack" == *"$needle"* ]]; then
        echo "  PASS: $label (found '$needle')"
        PASS=$((PASS + 1))
    else
        echo "  FAIL: $label (missing '$needle')"
        echo "  --- output ---"
        echo "$haystack"
        echo "  --- end ---"
        FAIL=$((FAIL + 1))
    fi
}

echo "=== test 1: bad usage ==="
out=$("$SCRIPT" 2>&1); rc=$?
assert_exit "no args -> exit 1" 1 "$rc"
assert_contains "usage message" "usage:" "$out"

echo "=== test 2: missing branch ==="
fresh_repo /tmp/ssm-repo-2
export PROJECT_REPO=/tmp/ssm-repo-2
out=$("$SCRIPT" doesnotexist 'feat: x' 2>&1); rc=$?
assert_exit "missing branch -> exit 1" 1 "$rc"
assert_contains "missing branch error" "not found" "$out"

echo "=== test 3: dirty target branch ==="
fresh_repo /tmp/ssm-repo-3
export PROJECT_REPO=/tmp/ssm-repo-3
git checkout -q -b feature
echo "feature change" >> file.txt
git commit -q -am 'feature commit'
git checkout -q main
echo "dirty" >> file.txt
out=$("$SCRIPT" feature 'feat: x' 2>&1); rc=$?
assert_exit "dirty target -> exit 4" 4 "$rc"
assert_contains "dirty error" "uncommitted changes" "$out"
git checkout -q file.txt

echo "=== test 4: clean merge ==="
fresh_repo /tmp/ssm-repo-4
export PROJECT_REPO=/tmp/ssm-repo-4
git checkout -q -b feature
echo "new file content" > newfile.txt
git add newfile.txt
git commit -q -m 'add newfile'
git checkout -q main
out=$("$SCRIPT" feature 'feat: add newfile (TEST-001)' 'body line' 2>&1); rc=$?
assert_exit "clean merge -> exit 0" 0 "$rc"
last_subject=$(git log -1 --format='%s' main)
assert_contains "commit subject" "feat: add newfile (TEST-001)" "$last_subject"
if [[ -f /tmp/ssm-repo-4/newfile.txt ]]; then
    echo "  PASS: newfile.txt present in main"
    PASS=$((PASS + 1))
else
    echo "  FAIL: newfile.txt missing from main"
    FAIL=$((FAIL + 1))
fi

echo "=== test 5: dry-run conflict ==="
fresh_repo /tmp/ssm-repo-5
export PROJECT_REPO=/tmp/ssm-repo-5
git checkout -q -b feature
echo "feature version" > shared.txt
git commit -q -am 'feature edits shared.txt'
git checkout -q main
echo "main version" > shared.txt
git commit -q -am 'main edits shared.txt'
main_before=$(git rev-parse HEAD)
out=$("$SCRIPT" feature 'feat: x' 2>&1); rc=$?
assert_exit "conflict -> exit 2" 2 "$rc"
assert_contains "conflict report" "DRY-RUN FAILED" "$out"
main_after=$(git rev-parse HEAD)
if [[ "$main_before" == "$main_after" ]]; then
    echo "  PASS: target branch unchanged after conflict"
    PASS=$((PASS + 1))
else
    echo "  FAIL: target branch moved after conflict ($main_before -> $main_after)"
    FAIL=$((FAIL + 1))
fi
remaining=$(git worktree list | grep -c project-mergecheck || true)
if [[ "$remaining" == "0" ]]; then
    echo "  PASS: scratch worktree cleaned up"
    PASS=$((PASS + 1))
else
    echo "  FAIL: scratch worktree leaked ($remaining)"
    FAIL=$((FAIL + 1))
fi

echo "=== test 6: resolve and re-run ==="
cd /tmp/ssm-repo-5
git checkout -q feature
git merge main -q -m 'merge main into feature' 2>/dev/null || true
echo "merged version" > shared.txt
git add shared.txt
git commit -q -m 'resolve conflict'
git checkout -q main
out=$("$SCRIPT" feature 'feat: merge after resolution (TEST-002)' 2>&1); rc=$?
assert_exit "post-resolution -> exit 0" 0 "$rc"
last_subject=$(git log -1 --format='%s' main)
assert_contains "commit subject after resolve" "TEST-002" "$last_subject"
content=$(cat /tmp/ssm-repo-5/shared.txt)
assert_contains "shared.txt content" "merged version" "$content"

echo "=== test 7: no body ==="
fresh_repo /tmp/ssm-repo-7
export PROJECT_REPO=/tmp/ssm-repo-7
git checkout -q -b feature
echo "x" > xfile.txt
git add xfile.txt
git commit -q -m 'add xfile'
git checkout -q main
out=$("$SCRIPT" feature 'feat: subject only (TEST-003)' 2>&1); rc=$?
assert_exit "no body -> exit 0" 0 "$rc"
body_count=$(git log -1 --format='%b' main | grep -c . || true)
if [[ "$body_count" == "0" ]]; then
    echo "  PASS: commit has no body"
    PASS=$((PASS + 1))
else
    echo "  FAIL: commit unexpectedly has body lines: $body_count"
    FAIL=$((FAIL + 1))
fi

echo "=== test 8: cleanup on success ==="
cd /tmp/ssm-repo-7
remaining=$(git worktree list | grep -c project-mergecheck || true)
if [[ "$remaining" == "0" ]]; then
    echo "  PASS: no leaked worktrees after success"
    PASS=$((PASS + 1))
else
    echo "  FAIL: scratch worktree leaked ($remaining)"
    FAIL=$((FAIL + 1))
fi

echo
echo "==== SUMMARY ===="
echo "PASSED: $PASS"
echo "FAILED: $FAIL"

rm -rf /tmp/ssm-repo-2 /tmp/ssm-repo-3 /tmp/ssm-repo-4 /tmp/ssm-repo-5 /tmp/ssm-repo-7

[[ "$FAIL" == "0" ]] && exit 0 || exit 1

