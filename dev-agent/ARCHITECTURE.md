# ARCHITECTURE.md — Project Stack Template

This file is meant to be customized. Replace every placeholder with your real paths, services, and constraints.

## Overview

`<project-name>` is the primary codebase this agent helps develop. The agent may also work across a frontend, shared libraries, infrastructure configuration, and deployment automation.

## Components

### Core Application

- **Source:** `<project-root>`
- **Worktrees:** `<worktree-root>`
- **Primary branch:** `<main-branch>`
- **Run command:** `<run-command>`
- **Tests:** `<test-command>`
- **Config:** `<config-path>`
- **Data:** `<data-path>`

### Web Or Client App

- **Source:** `<frontend-root>`
- **Build command:** `<frontend-build-command>`
- **Tests:** `<frontend-test-command>`
- **Service:** `<frontend-service-name>`
- **Live test URL:** `<frontend-url>`

### Infrastructure Or Config Repository

- **Source:** `<infra-root>`
- **Deploy command:** `<deploy-command>`
- **Important modules:** `<infra-modules>`
- **Secrets system:** `<secret-manager>`

### Runtime Services

| Service | Port | Purpose | Notes |
|---------|------|---------|-------|
| `<app-service>` | `<port>` | main runtime | production, handle carefully |
| `<lab-service>` | `<port>` | staging or lab runtime | safe place for live tests |
| `<frontend-service>` | `<port>` | web client | static assets or SPA |
| `<worker-service>` | — | async jobs | queues, scheduled tasks, webhooks |
| `<reverse-proxy>` | `<port>` | TLS / routing | fronts the public services |

### Supporting Platform Services

List anything the runtime depends on but that lives outside the app:

- `<message-or-chat-server>` — transport layer, if the agent talks over one
- `<llm-or-inference-endpoint>` — model access path
- `<speech-or-media-service>` — optional, for transcription or media
- Note explicitly which of these are separate platforms that should not be confused with the app itself.

## Git Structure

- **Canonical remote:** `origin`
- **Optional backup remote:** `<backup-remote-name>`
- **Branching model:** document whether local integration branches can intentionally diverge from upstream
- **Source-of-truth config repo:** if system/infra config lives in its own repo, never edit the generated/deployed copy directly — edit the source repo and re-deploy
- **Credential transport:** prefer HTTPS remotes plus a credential helper when SSH keys are not loaded in non-interactive sessions
- **Pull request diff target:** usually `origin/main`

## Verification Model

- **Unit tests:** fast local correctness checks
- **Integration tests:** cross-service behavior
- **Live tests:** real-environment validation with screenshots or terminal evidence
- **Human approval:** final go/no-go after the agent marks `APPROVAL PENDING`

## Local Notes

Document the facts agents repeatedly need:

- where worktrees live
- which service is safe to restart
- how to run the real app locally
- where browser-based verification happens
- which branches are shared and must not be rewritten

