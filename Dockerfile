FROM tailscale/tailscale:v1.82.0@sha256:d26fc9bb035b0559900cc6f23506f6b1ddab61a690ffab4f5d84feceb3de811e

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x entrypoint.sh

CMD ["/entrypoint.sh"]

# Directory where the state of tailscaled is stored.
# This needs to persist across container restarts. This will be passed to tailscaled --statedir=.
# When running on Kubernetes, state is stored by default in the Kubernetes secret with name:tailscale.
# To store state on local disk instead, set TS_KUBE_SECRET="" and TS_STATE_DIR=/path/to/storage/dir.
# https://tailscale.com/kb/1282/docker#ts_state_dir
ENV TS_STATE_DIR "/var/lib/tailscale"

# Unix socket path used by the Tailscale binary, where the tailscaled LocalAPI socket is created.
# The default is /var/run/tailscale/tailscaled.sock. This is equivalent to tailscaled tailscale --socket=.
# https://tailscale.com/kb/1282/docker#ts_socket
ENV TS_SOCKET "/var/run/tailscale/tailscaled.sock"

# Attempt to log in only if not already logged in.
# False by default, to forcibly log in every time the container starts.
# https://tailscale.com/kb/1282/docker#ts_auth_once
ENV TS_AUTH_ONCE "false"

# Accepts a JSON file to programmatically configure Serve and Funnel functionality.
# Use tailscale serve status --json to export your current configuration in the correct format.
# https://tailscale.com/kb/1282/docker#ts_serve_config
# ENV TS_SERVE_CONFIG "/config/serve.json"

# Enable userspace networking, instead of kernel networking.
# Enabled by default. This is equivalent to tailscaled --tun=userspace-networking.
# https://tailscale.com/kb/1282/docker#ts_userspace
ENV TS_USERSPACE "false"

# Additional arguments to pass to tailscaled.
# https://tailscale.com/kb/1282/docker#ts_extra_args
ENV TS_EXTRA_ARGS "--reset --advertise-tags=tag:container"
