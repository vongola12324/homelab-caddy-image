# Homelab Caddy Image

A custom Caddy image built specifically for my homelab.

The official Caddy image only includes the standard modules. Since my homelab relies on additional modules such as Docker service discovery and Cloudflare DNS challenge, this repository builds a custom Caddy binary using `xcaddy` and publishes it as a Docker image.

Although this image is primarily maintained for my own environment, anyone is welcome to use it.

> [!WARNING]
> This project is maintained for personal use. While it is publicly available, no compatibility or stability guarantees are provided. Use it at your own risk.

---

## Included Modules

The image currently includes the following modules:

- caddy-docker-proxy
- Cloudflare DNS
- Layer4

More modules may be added in future releases as my homelab evolves.

---

## Usage

Pull the latest image:

```bash
docker pull ghcr.io/<username>/homelab-caddy:latest
```

Use a specific Caddy release:

```bash
docker pull ghcr.io/<username>/homelab-caddy:2.11
```

Pin to a specific Caddy version:

```bash
docker pull ghcr.io/<username>/homelab-caddy:2.11.4
```

Pin to an immutable build:

```bash
docker pull ghcr.io/<username>/homelab-caddy:2.11.4-r3
```

Available tag types:

| Tag | Description |
|------|-------------|
| `latest` | Latest published image |
| `2` | Latest Caddy 2.x release |
| `2.11` | Latest Caddy 2.11.x release |
| `2.11.4` | Latest rebuild based on Caddy 2.11.4 |
| `2.11.4-r3` | Immutable image for the third rebuild of Caddy 2.11.4 |

---

## Release Policy

Images are automatically rebuilt and published when one of the following occurs:

- A new upstream Caddy release becomes available.
- The build configuration changes.
- The module list changes.
- A scheduled rebuild is triggered to keep bundled modules up to date.

Since Caddy modules are released independently of Caddy itself, scheduled rebuilds ensure the latest compatible module versions are included without requiring a new Caddy release.

---

## Versioning

This repository follows a Caddy-first versioning strategy.

Every image is tagged using the upstream Caddy version, followed by an optional rebuild revision.

For example:

```
2.11.4-r1
2.11.4-r2
2.11.4-r3

2.12.0-r1
```

Revision (`-rN`) increments indicate rebuilds of the same upstream Caddy version, typically due to:

- Module updates
- Build pipeline improvements
- Dependency updates
- Security fixes

In addition to immutable revision tags, mutable convenience tags are also published:

```
latest
2
2.11
2.11.4
```

For reproducible deployments, it is recommended to pin images using immutable revision tags (`2.11.4-r3`) or, for the highest level of reproducibility, the image digest (`@sha256:...`). Mutable tags such as `latest` or `2.11.4` may be updated to point to newer builds over time.

