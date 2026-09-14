FROM  --platform=$TARGETOS/$TARGETARCH ubuntu:22.04

LABEL author="Daniel Barton" maintainer="danny6167@gmail.com"

ENV   DEBIAN_FRONTEND noninteractive

## add container user
RUN   useradd -m -d /home/container -s /bin/bash container



RUN         dpkg --add-architecture i386 \
            && apt update \
            && apt upgrade -y \
			&& apt install -y libcurl4-gnutls-dev:i386 libssl3:i386 libcurl4:i386 lib32tinfo6 libtinfo6:i386 lib32z1 lib32stdc++6 libncurses5:i386 libcurl3-gnutls:i386 libsdl2-2.0-0:i386 \
 				gcc g++ libgcc1 libc++-dev gdb libc6 curl tar iproute2 net-tools libatomic1 libsdl1.2debian libsdl2-2.0-0 tzdata \
        		libfontconfig locales libcurl3-gnutls libpulse-dev libpulse0 libnss-wrapper gettext libatomic1 libpulse0 libpulse-dev

## configure locale
RUN   update-locale lang=en_US.UTF-8 \
        &&   dpkg-reconfigure --frontend noninteractive locales


ENV         USER=container HOME=/home/container
WORKDIR     /home/container



## Prepare NSS Wrapper for the entrypoint as a workaround for Valheim requiring a valid UID
ENV         NSS_WRAPPER_PASSWD=/tmp/passwd NSS_WRAPPER_GROUP=/tmp/group
RUN         touch ${NSS_WRAPPER_PASSWD} ${NSS_WRAPPER_GROUP} \
            && chgrp 0 ${NSS_WRAPPER_PASSWD} ${NSS_WRAPPER_GROUP} \
            && chmod g+rw ${NSS_WRAPPER_PASSWD} ${NSS_WRAPPER_GROUP}
ADD         passwd.template /passwd.template


COPY        --chmod=755 --chown=root:root ./entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
