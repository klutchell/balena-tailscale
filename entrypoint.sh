#!/usr/bin/env sh

# exit on any error
set -e

mkdir -p /dev/net
[ ! -c /dev/net/tun ] && mknod /dev/net/tun c 10 200

# https://github.com/tailscale/tailscale/blob/main/cmd/containerboot/main.go
exec /usr/local/bin/containerboot
