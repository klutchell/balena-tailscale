FROM tailscale/tailscale:v1.74.1@sha256:a013ce5266e5c796efe31c7cf9562deb21423f8586361d7faadaf675fa4296ac

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x entrypoint.sh

CMD ["/entrypoint.sh"]

ENV TS_STATE_DIR "/var/lib/tailscale"
ENV TS_SOCKET "/var/run/tailscale/tailscaled.sock"
ENV TS_EXTRA_ARGS "--reset"
ENV TS_AUTH_ONCE "true"

ENV REQUIRE_AUTH_KEY "false"
