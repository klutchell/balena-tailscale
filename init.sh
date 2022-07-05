#!/usr/bin/env bash
set -e

if [ -z "${TAILSCALE_AUTHKEY}" ]
then
    echo "TAILSCALE_AUTHKEY is required!"
    exit 1
fi

if [ -z "${TAILSCALE_HOSTNAME}" ]
then
    export TAILSCALE_HOSTNAME="${BALENA_DEVICE_NAME_AT_INIT}"
fi

mkdir -p /dev/net
[ ! -c /dev/net/tun ] && mknod /dev/net/tun c 10 200

exec /usr/bin/supervisord -c /supervisord.conf
