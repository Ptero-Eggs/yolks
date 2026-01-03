FROM        --platform=$TARGETOS/$TARGETARCH ghcr.io/ptero-eggs/yolks:debian

LABEL       author="Franck Dechavanne" maintainer="rallymen007@gmail.com"

RUN         apt update \
            && apt -y upgrade
RUN         apt install -y php

# Only install the needed steamcmd packages on the AMD64 build
RUN         if [ "$(uname -m)" = "x86_64" ]; then \
                dpkg --add-architecture i386 && \
                apt update && \
                apt -y install lib32gcc-s1 libsdl2-2.0-0:i386; \
            fi


USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
