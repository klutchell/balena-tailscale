# balena-tailscale

Add your device to your [Tailscale](https://tailscale.com/) network with this
block!

## Usage

To use this block, add a service in your `docker-compose.yml` file as shown
below.

```yml
volumes:
  ...
  ts-state: {}

services:
  ...
  tailscale:
    # where <arch> is one of aarch64, armv7hf or amd64
    image: bh.cr/gh_klutchell/tailscale-<arch>
    network_mode: host
    restart: on-failure
    volumes:
      - ts-state:/var/lib/tailscale
    labels:
      - io.balena.features.kernel-modules=1
    cap_add:
      - net_admin
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
    image: bh.cr/gh_klutchell/tailscale-<arch>/<version>
    network_mode: host
    restart: on-failure
    volumes:
      - ts-state:/var/lib/tailscale
    labels:
      - io.balena.features.kernel-modules=1
    cap_add:
      - net_admin
      - sys_module
    tmpfs:
      - /tmp
      - /var/run/
```

## Customization

### Environment Variables

The supported environment variables are detailed on the
[official DockerHub repo](https://hub.docker.com/r/tailscale/tailscale) and on
the [Using Tailscale with Docker KB](https://tailscale.com/kb/1282/docker).

### Serve Config

To expose services via [Tailscale Serve](https://tailscale.com/kb/1312/serve) or
[Tailscale Funnel](https://tailscale.com/kb/1223/funnel), you can load a custom
`serve.json` file.

```Dockerfile
FROM bh.cr/gh_klutchell/tailscale-aarch64

COPY serve.json /config/serve.json
# Accepts a JSON file to programmatically configure Serve and Funnel functionality.
# Use tailscale serve status --json to export your current configuration in the correct format.
# https://tailscale.com/kb/1282/docker#ts_serve_config
ENV TS_SERVE_CONFIG "/config/serve.json"
```

## Contributing

Please open an issue or submit a pull request with any features, fixes, or
changes.

## Acknowledgements

[Tailscale](https://tailscale.com/) is primarily developed by the people at
<https://github.com/orgs/tailscale/people>. For other contributors, see:

- <https://github.com/tailscale/tailscale/graphs/contributors>
- <https://github.com/tailscale/tailscale-android/graphs/contributors>

These related projects were also used for reference:

- <https://github.com/klutchell/balena-wireguard>
- <https://github.com/kazazes/balena-tailscale>
- <https://github.com/hslatman/tailscale-balena-rpi>

## Legal

WireGuard is a registered trademark of Jason A. Donenfeld.
