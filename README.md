# balena-tailscale

Run a [Tailscale](https://tailscale.com/) [subnet router](https://tailscale.com/kb/1019/subnets/) on balena!

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
    image: bh.cr/gh_klutchell/tailscale-<arch>
    network_mode: host
    volumes:
      - state:/var/lib/tailscale
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
      - net.ipv4.ip_forward=1
      - net.ipv6.conf.all.forwarding=1
    labels:
      - io.balena.features.kernel-modules=1
    cap_add:
      - net_admin
      - sys_module
```

To pin to a specific version of this block use:

```yml
services:
  ...
  tailscale:
    # where <version> is the release semver or release commit ID
    image: bh.cr/gh_klutchell/tailscale-<arch>/<version>
    ...
```

## Customization

### Environment Variables

| Name                 | Description                                                                                                                 |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| `TAILSCALE_AUTHKEY`  | Provide an [auth key](https://tailscale.com/kb/1085/auth-keys) to automatically authenticate the node as your user account. |
| `TAILSCALE_HOSTNAME` | Provide a hostname to use for the device instead of the one provided by the OS. Defaults to the balena device name at init. |
| `TAILSCALE_UP_FLAGS` | Additional space-separated flags to pass to the [Tailscale up command](https://tailscale.com/kb/1080/cli/#up).              |

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
