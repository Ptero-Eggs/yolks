# ----------------------------------
# Environment: Postgres DB
# ----------------------------------
FROM --platform=$TARGETOS/$TARGETARCH postgres:18-alpine

LABEL author="Parker" maintainer="parker@pterodactyl.io"

RUN adduser -D -h /home/container container

RUN     apk add --no-cache curl iproute2 ca-certificates fontconfig git openssl sqlite tar tzdata
USER container
ENV HOME /home/container
WORKDIR /home/container


COPY --chmod=755 --chown=root:root ../entrypoint.sh /entrypoint.sh
ENTRYPOINT         ["/entrypoint.sh"]
