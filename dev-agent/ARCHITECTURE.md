# ARCHITECTURE.md — Project Stack Reference (On-Demand)

This file is **not** preloaded every turn. Read it with `read_file` when working on cross-component changes, deployments, or unfamiliar repos. Replace every `<placeholder>` with your real paths, services, and commands.

## Overview

`<project-name>` is the primary codebase this agent develops. Document how the backend, client, shared libraries, and infrastructure repositories relate so neither the main agent nor subagents guess paths.

## Repositories & Commands

### Backend / Core Application

- **Source:** `<repos-root>/<backend-repo>`
- **Worktrees:** `<worktrees-root>/<backend-repo>-<topic>`
- **Primary branch:** `origin/main`
- **Dev run:** `<backend-run-command>`
- **Tests:** `<backend-test-command>`
- **Lint / typecheck:** `<backend-lint-command>`
- **Deploy checkout (do not develop here):** `<backend-deploy-checkout>`

### Web / Client App (Optional)

- **Source:** `<repos-root>/<client-repo>`
- **Worktrees:** `<worktrees-root>/<client-repo>-<topic>`
- **Build:** `<client-build-command>`
- **Unit tests:** `<client-test-command>`
- **E2E / screenshot tests:** `<client-e2e-command>`

### Infrastructure / Deployment Repo (Optional)

- **Source:** `<repos-root>/<infra-repo>`
- **Deploy / rebuild:** `<deploy-command>`
- **Secrets manager:** `<secrets-system>`

## Services

| Service | Port | Environment | Safe for agent to restart? |
|---|---|---|---|
| `<app-prod-service>` | `<port>` | production | No — ask human first |
| `<app-staging-service>` | `<port>` | staging / lab | Yes (if configured) |
| `<frontend-service>` | `<port>` | web client | `<yes/no>` |
| `<reverse-proxy>` | `80/443` | TLS / routing | No — ask human first |

## Verification Model

- **Unit & integration tests:** run in the worktree before opening or updating a PR.
- **Live / end-to-end tests:** run against a fresh, throwaway deployment built from the worktree (never production) and tear it down afterwards.
- **UI changes:** capture before/after screenshots with invented placeholder data and inspect them before opening a PR.
- **Cross-model review:** two independent model families review the full diff against `origin/main`; PR is scored with `scoring-pull-requests` before reporting ready.
