#!/usr/bin/env bash
set -me

if [ -z "${TAILSCALE_AUTHKEY}" ]
then
    echo "TAILSCALE_AUTHKEY is required!"
    exit 1
fi

if [ -z "${TAILSCALE_HOSTNAME}" ]
then
    TAILSCALE_HOSTNAME="${BALENA_DEVICE_NAME_AT_INIT}"
fi

mkdir -p /dev/net
[ ! -c /dev/net/tun ] && mknod /dev/net/tun c 10 200

tailscaled &

sleep 5

# https://tailscale.com/kb/1080/cli/#up
# shellcheck disable=SC2086
tailscale up \
    -authkey "${TAILSCALE_AUTHKEY}" \
    -hostname "${TAILSCALE_HOSTNAME}" \
    ${TAILSCALE_UP_FLAGS}

fg
