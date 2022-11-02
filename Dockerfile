FROM golang:1.19.3-alpine3.16 AS gobuild

WORKDIR /go/src

# hadolint ignore=DL3018
RUN apk --no-cache add git

ARG VERSION=v1.32.1

RUN go install tailscale.com/cmd/tailscale@${VERSION} && \
    go install tailscale.com/cmd/tailscaled@${VERSION}

FROM alpine:3.16

# hadolint ignore=DL3018
RUN apk --no-cache add tini iptables bash

COPY --from=gobuild /go/bin /usr/bin
COPY entrypoint.sh /init

RUN chmod +x /init

ENV TAILSCALE_UP_FLAGS "\
    --advertise-exit-node \
"

ENTRYPOINT ["/sbin/tini", "--", "/init"]
