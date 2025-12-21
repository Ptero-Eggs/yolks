FROM        --platform=$TARGETOS/$TARGETARCH eclipse-temurin:17-jdk-jammy

LABEL       author="Michael Parker" maintainer="parker@pterodactyl.io"

LABEL       org.opencontainers.image.source="https://github.com/pterodactyl/yolks"
LABEL       org.opencontainers.image.licenses=MIT

RUN         apt update -y \
            && apt install -y \
                curl \
                lsof \
                ca-certificates \
                openssl \
                git \
                tar \
                sqlite3 \
                fontconfig \
                tzdata \
                iproute2 \
                libfreetype6 \
                tini \
				zip \
				unzip \
			&& rm -rf /var/lib/apt/lists/*

## Setup working directory and environment
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

STOPSIGNAL SIGINT

COPY        --chown=root:root --chmod=755 ./../entrypoint.sh /entrypoint.sh
ENTRYPOINT    ["/usr/bin/tini", "-g", "--", "/entrypoint.sh"]
