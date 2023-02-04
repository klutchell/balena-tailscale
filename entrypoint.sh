#!/usr/bin/env sh

# exit on any error
set -e

# load the kernel module if it exists
if modprobe wireguard 2>/dev/null
then
    dmesg | grep wireguard
fi

mkdir -p /dev/net
[ ! -c /dev/net/tun ] && mknod /dev/net/tun c 10 200

# https://github.com/tailscale/tailscale/blob/main/cmd/containerboot/main.go
exec /usr/local/bin/containerboot
