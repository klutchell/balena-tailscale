FROM tailscale/tailscale:v1.52.0@sha256:b102f468a2f1b0b6e9717cf728c43886c136e808010547eebe9ebd80aedd34c3

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x entrypoint.sh

CMD ["/entrypoint.sh"]

ENV TS_STATE_DIR "/var/lib/tailscale"
ENV TS_SOCKET "/var/run/tailscale/tailscaled.sock"
ENV TS_EXTRA_ARGS "--reset"
ENV TS_AUTH_ONCE "true"

ENV REQUIRE_AUTH_KEY "false"
