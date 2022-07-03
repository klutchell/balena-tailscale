# balena-tailscale

Run a [Tailscale](https://tailscale.com/) [subnet router](https://tailscale.com/kb/1019/subnets/) on balena!

## Getting Started

You can one-click-deploy this project to balena using the button below:

[![deploy with balena](https://balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/klutchell/balena-tailscale)

## Manual Deployment

Alternatively, deployment can be carried out by manually creating a [balenaCloud account](https://dashboard.balena-cloud.com) and application, flashing a device, downloading the project and pushing it via the [balena CLI](https://github.com/balena-io/balena-cli).

## Usage

Once your device joins the fleet you'll need to allow some time for it to download the application and start the services.

After a few minutes you should see your device in your [Tailscale admin console](https://login.tailscale.com/admin/machines).

Depending on your configuration, you may need to [enable subnet routes from the admin console](https://tailscale.com/kb/1019/subnets/#step-3-enable-subnet-routes-from-the-admin-console).

## Customization

### Environment Variables

| Name                 | Description                                                                                                                                          |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| `TZ`                 | The timezone in your location. Find a [list of all timezone values here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).              |
| `TAILSCALE_AUTHKEY`  | Provide an [auth key](https://tailscale.com/kb/1085/auth-keys) to automatically authenticate the node as your user account.                          |
| `TAILSCALE_HOSTNAME` | Provide a hostname to use for the device instead of the one provided by the OS. Defaults to the balena device name at init.                          |
| `ADVERTISE_TAGS`     | Give tagged permissions to this device. You must be [listed in "TagOwners"](https://tailscale.com/kb/1018/acls#tag-owners) to be able to apply tags. |
| `ADVERTISE_ROUTES`   | Expose physical [subnet routes](https://tailscale.com/kb/1019/subnets) to your entire Tailscale network. Defaults to `10.0.0.0/24,192.168.1.0/24`.   |
| `SET_HOSTNAME`       | Set a custom device hostname on application start. Defaults to `tailscale`.                                                                          |

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
