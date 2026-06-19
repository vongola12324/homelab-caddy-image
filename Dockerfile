ARG CADDY_VERSION=2.11.4

# Step1: Build Caddy
FROM caddy:${CADDY_VERSION}-builder-alpine AS builder
WORKDIR /build
COPY build.sh .
COPY modules.txt .
RUN chmod +x build.sh && ./build.sh

# Step2: Build image with binary
FROM caddy:${CADDY_VERSION}-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
RUN caddy list-modules --packages
CMD ["caddy", "docker-proxy"]
