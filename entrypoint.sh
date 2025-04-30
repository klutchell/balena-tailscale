#!/usr/bin/env sh

# https://tailscale.com/kb/1282/docker
# https://tailscale.com/kb/1278/tailscaled
# https://tailscale.com/kb/1241/tailscale-up
# https://tailscale.com/kb/1312/serve
# https://tailscale.com/kb/1223/funnel
# https://tailscale.com/kb/1242/tailscale-serve
# https://tailscale.com/kb/1311/tailscale-funnel
# https://tailscale.com/blog/docker-tailscale-guide

set -eu

truthy() {
    case "${1:-}" in
        [tT][rR][uU][eE] | [yY] | [yY][eE][sS] | [oO][nN] | 1)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# shellcheck disable=SC2310
if truthy "${DISABLE:-}"
then
    echo "DISABLE is truthy, exiting..."
    exit 0
fi

if [ -z "${TS_AUTH_KEY:-}" ] && [ -z "${TS_AUTHKEY:-}" ]; then
    echo "TS_AUTHKEY is unset, exiting..."
    exit 0
fi

# attempt to load required kernel modules
# even if we aren't going to use them
modprobe tun || true
modprobe wireguard || true

# create device node
mkdir -p /dev/net
[ ! -c /dev/net/tun ] && mknod /dev/net/tun c 10 200

# https://github.com/tailscale/tailscale/blob/main/cmd/containerboot/main.go
exec /usr/local/bin/containerboot
