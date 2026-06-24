# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo does

Builds a custom Caddy Docker image using `xcaddy`, bundling additional modules not included in the official image. The image is published to GHCR (`ghcr.io/vongola12324/homelab-caddy-image`).

## Key files

- `Dockerfile` — two-stage build: `caddy:*-builder-alpine` runs `xcaddy`, output is copied into `caddy:*-alpine`
- `build.sh` — called inside the builder stage; reads `modules.txt` and assembles `xcaddy build --output /usr/bin/caddy` args
- `modules.txt` — one `github.com/<owner>/<repo>@<version>` per module (comments with `#` are stripped by `build.sh`)

## Adding or updating a module

Edit `modules.txt`. Format: `github.com/<owner>/<repo>[/subpath]@vX.Y.Z`. There is no `go.mod` — versions are pinned directly here.

## Versioning scheme

Tags follow `<caddy-version>-rN` (e.g. `2.11.4-r3`). The `-rN` revision increments on every rebuild of the same Caddy version. Mutable convenience tags (`latest`, `2`, `2.11`, `2.11.4`) always point to the latest revision.

## CI / Workflow architecture

Three jobs run in sequence on push to main:

1. **`prepare`** — parses `ARG CADDY_VERSION` from `Dockerfile`, determines the next `-rN` revision by querying existing GHCR tags
2. **`build` (matrix)** — runs natively on `ubuntu-latest` (amd64) and `ubuntu-24.04-arm` (arm64) in parallel; each pushes a platform-specific tag (e.g. `:2.11.4-r1-amd64`)
3. **`merge`** — assembles a multi-arch manifest via `docker buildx imagetools create`, applies all public tags, creates a GitHub Release

On pull requests the `build` job runs (no push) to validate the image builds on both platforms. The `push` trigger uses path filters; the `pull_request` trigger does not, so the status check always appears on every PR.

### Automated update workflows

- **`update-caddy-version.yml`** (daily at 04:00 UTC) — checks `caddyserver/caddy` latest release, bumps `ARG CADDY_VERSION` in `Dockerfile`, opens a PR with auto-merge enabled
- **`update-caddy-modules.yml`** (daily at 05:00 UTC) — checks each module's latest GitHub tag, bumps versions in `modules.txt`, opens a PR with auto-merge enabled
- **`dependabot-automerge.yml`** — enables squash-merge on Dependabot PRs; uses `pull_request_target` so it has write permissions
- **`dependabot.yml`** — weekly grouped Dependabot updates for all GitHub Actions versions

## Commit style

No `Co-Authored-By` trailers. Keep messages short and direct.
