# TOOLS.md — Services Cheat Sheet Template

Keep this file short and practical. It should answer: what tools exist, where they live, and what can go wrong.

## System Configuration

- if system or infra config is managed from a source-of-truth repo, never edit the generated/deployed copy directly — edit the source and re-deploy
- record the exact rebuild/redeploy command here so it is never guessed
- note any tool that lives outside the default `PATH` and needs an explicit `<runner-or-absolute-path>` prefix to invoke

## Browser Automation

- **Chromium path:** `<chromium-path>`
- **Headless screenshot:** `chromium --headless --disable-gpu --no-sandbox --screenshot=/tmp/out.png --window-size=1280,900 <url>`
- **Playwright command:** `<playwright-command>`
- **Use case:** live-test evidence, UI regression checks, responsive screenshots

## Git Hosting

- **Primary forge:** `<git-forge-url>`
- **CLI:** `gh`, `glab`, or your self-hosted equivalent
- **Transport:** prefer HTTPS remotes plus a credential helper when SSH keys are not loaded in non-interactive sessions
- **Brokered identity (optional):** if your setup routes API calls through a broker so the agent can act as a human's real account without holding the token, document exactly which command form is brokered (e.g. only `<forge> api ...`) vs. which falls back to a limited service account, and treat brokered write calls with extra caution — they are the real account
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

