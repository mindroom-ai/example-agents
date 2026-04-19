# TOOLS.md — Services Cheat Sheet Template

Keep this file short and practical. It should answer: what tools exist, where they live, and what can go wrong.

## Browser Automation

- **Chromium path:** `<chromium-path>`
- **Headless screenshot:** `chromium --headless --disable-gpu --no-sandbox --screenshot=/tmp/out.png --window-size=1280,900 <url>`
- **Playwright command:** `<playwright-command>`
- **Use case:** live-test evidence, UI regression checks, responsive screenshots

## Git Hosting

- **Primary forge:** `<git-forge-url>`
- **CLI:** `gh`, `glab`, or your self-hosted equivalent
- **Default rule:** read-only by default; ask before state-changing actions done under a human identity

## Speech-To-Text

- **Endpoint variable:** `TRANSCRIBE_API_URL`
- **Fallback key:** `GEMINI_API_KEY` or `GOOGLE_API_KEY`
- **Used by:** `skills/transcribe/`

## Text-To-Speech

- **Endpoint variable:** `SPEECH_SYNTH_API_URL`
- **Optional:** only keep this section if your workspace actually uses it

## Retrieval / Search

- **Endpoint variable:** `SEARCH_API_URL`
- **Purpose:** embeddings, retrieval, or search proxy

## Memory Service

- **Endpoint variable:** `MEMORY_API_URL`
- **Purpose:** durable note lookup or memory indexing

## Secrets Handling

- never hardcode credentials in workspace files
- prefer environment files or a secret manager
- do not load raw secrets into LLM context unless absolutely necessary

