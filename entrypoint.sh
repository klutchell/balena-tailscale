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

# https://tailscale.com/kb/1019/subnets/
tailscale up \
    -authkey "${TAILSCALE_AUTHKEY}" \
    -hostname "${TAILSCALE_HOSTNAME}" \
    -advertise-tags "${ADVERTISE_TAGS}" \
    -advertise-routes "${ADVERTISE_ROUTES}" "$@"

# iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

fg
