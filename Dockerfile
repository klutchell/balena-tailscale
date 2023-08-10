FROM tailscale/tailscale:v1.46.1@sha256:8abcbcfe179c454ab4c3b583626c4e5b2edcb7c0851fe09ba3313d4ca02aacdc

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x entrypoint.sh

CMD ["/entrypoint.sh"]

ENV TS_STATE_DIR "/var/lib/tailscale"
ENV TS_SOCKET "/var/run/tailscale/tailscaled.sock"
ENV TS_EXTRA_ARGS "--reset"
ENV TS_AUTH_ONCE "true"

ENV REQUIRE_AUTH_KEY "false"
