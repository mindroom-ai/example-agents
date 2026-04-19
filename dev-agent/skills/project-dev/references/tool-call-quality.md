# Tool Call Quality Protocol

Use this document for recurring analysis of tool-call mistakes so you can improve descriptions, validation, and helper code.

## Purpose

- identify which tool failures are agent misuse versus real bugs
- reduce repeated agent mistakes
- turn noisy anecdotes into concrete fixes

## Data Source

Store structured failures in a file such as:

```text
<runtime-data>/tracking/tool_failures.jsonl
```

Adjust the path to match your runtime.

## Weekly Analysis Workflow

### 1. Extract Recent Failures

```bash
python3 - <<'PY'
import collections
import json
from datetime import datetime, timedelta, timezone
from pathlib import Path

path = Path("<runtime-data>/tracking/tool_failures.jsonl")
cutoff = datetime.now(timezone.utc) - timedelta(days=7)
rows = [json.loads(line) for line in path.read_text().splitlines()] if path.exists() else []
recent = [r for r in rows if r.get("timestamp") and datetime.fromisoformat(r["timestamp"]) >= cutoff]
print(f"failures in last 7 days: {len(recent)}")
counts = collections.Counter((r.get("tool_name"), r.get("error_type")) for r in recent)
for (tool, error), count in counts.most_common(20):
    print(f"{tool:30s} {error:25s} {count}")
PY
```

### 2. Classify

| Category | Meaning | Usual response |
|----------|---------|----------------|
| A | agent misuse | improve docs or normalize inputs |
| B | tool bug | file an issue and fix the code |
| C | stale browser state | improve browser guidance |
| D | environment noise | track, but do not overreact |
| S | soft failure returned as text | add internal retry or logging |

### 3. Analyze Top Patterns

For any pattern with repeated failures:

1. what the agent sent
2. what the tool expected
3. why the model gets confused
4. which agents or prompts trigger it
5. the smallest fix

### 4. Update This File

Record:

- current totals
- newly discovered patterns
- patterns that dropped to zero
- action items

## Known Failure Patterns

Use this section as a template:

### Active

#### P1: Missing empty-object normalization

- **Pattern:** tool rejects missing optional args because `undefined` is forwarded instead of `{}`
- **Impact:** repeated avoidable failures
- **Fix:** normalize missing args before validation

#### P2: JSON string sent where list is expected

- **Pattern:** agent double-serializes array input
- **Fix:** attempt `json.loads()` before strict validation

### Resolved

Move patterns here when they disappear after a code or description fix.

## Action Items

- [ ] file follow-up issues for the highest-volume failures
- [ ] improve tool descriptions where ambiguity caused misuse
- [ ] extend logging to capture soft failures, not just exceptions

