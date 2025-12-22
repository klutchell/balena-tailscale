# Based on https://github.com/tailscale/tailscale/blob/main/Dockerfile
FROM golang:1.25-alpine@sha256:ac09a5f469f307e5da71e766b0bd59c9c49ea460a528cc3e6686513d64a6f1fb AS build-env

WORKDIR /go/src/tailscale

# Install git for cloning the repository
# hadolint ignore=DL3018
RUN apk add --no-cache git

# renovate: datasource=github-releases depName=tailscale/tailscale
ARG TAILSCALE_VERSION=v1.92.3

# Clone the Tailscale repository
RUN git clone --depth 1 -c advice.detachedHead=false \
    https://github.com/tailscale/tailscale.git -b ${TAILSCALE_VERSION} .

# hadolint ignore=DL3059
RUN go mod download

# Copy patches
COPY patches/*.patch /patches/

# Apply patches if they exist
RUN for patch in /patches/*.patch; do \
        [ -f "$patch" ] && git apply --verbose "$patch"; \
    done

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN VERSION_SHORT=$(git describe --tags --abbrev=0 | sed 's/^v//') && \
    VERSION_LONG=$(git describe --tags --long | sed 's/^v//') && \
    VERSION_GIT_HASH=$(git rev-parse --short HEAD) && \
    go install -ldflags="\
      -X tailscale.com/version.longStamp=$VERSION_LONG \
      -X tailscale.com/version.shortStamp=$VERSION_SHORT \
      -X tailscale.com/version.gitCommitStamp=$VERSION_GIT_HASH" \
      -v ./cmd/tailscale ./cmd/tailscaled ./cmd/containerboot

# https://hub.docker.com/r/tailscale/tailscale
# https://github.com/tailscale/tailscale
# FROM tailscale/tailscale:v1.82.0@sha256:d26fc9bb035b0559900cc6f23506f6b1ddab61a690ffab4f5d84feceb3de811e

# Start from alpine base since we aren't using the binaries from the tailscale image
FROM alpine:3.23@sha256:865b95f46d98cf867a156fe4a135ad3fe50d2056aa3f25ed31662dff6da4eb62

# hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates iptables iproute2 ip6tables iptables-legacy

# Alpine 3.19 replaces legacy iptables with nftables based implementation.  We
# can't be certain that all hosts that run Tailscale containers currently
# suppport nftables, so link back to legacy for backwards compatibility reasons.
RUN rm /usr/sbin/iptables && ln -s /usr/sbin/iptables-legacy /usr/sbin/iptables
RUN rm /usr/sbin/ip6tables && ln -s /usr/sbin/ip6tables-legacy /usr/sbin/ip6tables

# Copy the built binaries from the build stage
COPY --from=build-env /go/bin/* /usr/local/bin/
RUN tailscale version

# Setup our entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh
CMD ["/entrypoint.sh"]

# Directory where the state of tailscaled is stored.
# This needs to persist across container restarts. This will be passed to tailscaled --statedir=.
# When running on Kubernetes, state is stored by default in the Kubernetes secret with name:tailscale.
# To store state on local disk instead, set TS_KUBE_SECRET="" and TS_STATE_DIR=/path/to/storage/dir.
# https://tailscale.com/kb/1282/docker#ts_state_dir
ENV TS_STATE_DIR="/var/lib/tailscale"

# Unix socket path used by the Tailscale binary, where the tailscaled LocalAPI socket is created.
# The default is /var/run/tailscale/tailscaled.sock. This is equivalent to tailscaled tailscale --socket=.
# https://tailscale.com/kb/1282/docker#ts_socket
ENV TS_SOCKET="/var/run/tailscale/tailscaled.sock"

# Exclude resin-vpn and resin-dns interfaces from Tailscale interface selection.
# See https://github.com/tailscale/tailscale/issues/1552#issuecomment-2177995310
ENV TS_EXCLUDED_INTERFACES="resin-vpn resin-dns"

# Attempt to log in only if not already logged in.
# False by default, to forcibly log in every time the container starts.
# https://tailscale.com/kb/1282/docker#ts_auth_once
# ENV TS_AUTH_ONCE="false"

# Accepts a JSON file to programmatically configure Serve and Funnel functionality.
# Use tailscale serve status --json to export your current configuration in the correct format.
# https://tailscale.com/kb/1282/docker#ts_serve_config
# ENV TS_SERVE_CONFIG="/config/serve.json"

# Enable userspace networking, instead of kernel networking.
# Enabled by default. This is equivalent to tailscaled --tun=userspace-networking.
# https://tailscale.com/kb/1282/docker#ts_userspace
ENV TS_USERSPACE="false"

# Additional arguments to pass to tailscaled.
# https://tailscale.com/kb/1282/docker#ts_extra_args
ENV TS_EXTRA_ARGS="--reset --advertise-tags=tag:container"
