FROM        --platform=$TARGETOS/$TARGETARCH erlang:27-alpine

LABEL       author="Frozenbloo" maintainer="tomwbloomer@gmail.com"

LABEL       org.opencontainers.image.source="https://github.com/pterodactyl/yolks"
LABEL       org.opencontainers.image.licenses=MIT

RUN         apk add --update --no-cache ca-certificates curl git openssl sqlite tar tzdata iproute2 \
				&& adduser -D -h /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./../entrypoint.sh /entrypoint.sh
CMD         [ "/bin/ash", "/entrypoint.sh" ]
