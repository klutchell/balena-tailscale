# balena-tailscale

Add your device to your [Tailscale](https://tailscale.com/) network with this block!

## Usage

To use this block, add a service in your `docker-compose.yml` file as shown below.

```yml
volumes:
  ...
  state: {}

services:
  ...
  tailscale:
    # where <arch> is one of aarch64, armv7hf or amd64
    image: bh.cr/klutchell_blocks/tailscale-<arch>
    network_mode: host
    volumes:
      - state:/var/lib/tailscale
    labels:
      - io.balena.features.kernel-modules=1
    cap_add:
      - net_admin
      - net_raw
      - sys_module
    tmpfs:
      - /tmp
      - /var/run/
```

To pin to a specific version of this block use:

```yml
services:
  ...
  tailscale:
    # where <version> is the release semver or release commit ID
    image: bh.cr/klutchell_blocks/tailscale-<arch>/<version>
    network_mode: host
    volumes:
      - state:/var/lib/tailscale
    labels:
      - io.balena.features.kernel-modules=1
    cap_add:
      - net_admin
      - net_raw
      - sys_module
    tmpfs:
      - /tmp
      - /var/run/
```

## Customization

### Environment Variables

The supported environment variables are listed on the [official DockerHub repo](https://hub.docker.com/r/tailscale/tailscale).

- `TS_AUTH_KEY`: The [authkey]((https://tailscale.com/kb/1085/auth-keys/)) to use for login.
- `TS_KUBE_SECRET`: The name of the Kubernetes secret in which to store tailscaled state.
- `TS_DEST_IP`: Proxy all incoming Tailscale traffic to the given destination.
- `TS_ROUTES`: Subnet routes to advertise.
- `TS_ACCEPT_DNS`: Whether to use the tailnet's DNS configuration.
- `TS_SOCKET`: The path where the tailscaled LocalAPI socket should be created.
- `TS_EXTRA_ARGS`: Extra arguments to 'tailscale up'.
- `TS_USERSPACE`: Run with userspace networking (the default) instead of kernel networking.
- `TS_STATE_DIR`: The directory in which to store tailscaled state. The data should persist across container restarts.
- `TS_SOCKS5_SERVER`: The address on which to listen for SOCKS5 proxying into the tailnet.
- `TS_OUTBOUND_HTTP_PROXY_LISTEN`: The address on which to listen for HTTP proxying into the tailnet.
- `TS_TAILSCALED_EXTRA_ARGS`: Extra arguments to 'tailscaled'.

For reference, see also the [documentation on Tailscale CLI commands](https://tailscale.com/kb/1080/cli/).

## Contributing

Please open an issue or submit a pull request with any features, fixes, or changes.

## Acknowledgements

[Tailscale](https://tailscale.com/) is primarily developed by the
people at <https://github.com/orgs/tailscale/people>.
For other contributors, see:

- <https://github.com/tailscale/tailscale/graphs/contributors>
- <https://github.com/tailscale/tailscale-android/graphs/contributors>

These related projects were also used for reference:

- <https://github.com/klutchell/balena-wireguard>
- <https://github.com/kazazes/balena-tailscale>
- <https://github.com/hslatman/tailscale-balena-rpi>

## Legal

WireGuard is a registered trademark of Jason A. Donenfeld.
