# syntax=docker/dockerfile:1.4
FROM  --platform=$TARGETOS/$TARGETARCH ubuntu:24.04

LABEL author="Michael Parker" maintainer="parker@pterodactyl.io"

ENV DEBIAN_FRONTEND=noninteractive

## add container user
RUN   useradd -m -d /home/container -s /bin/bash container

# Setup apt
RUN apt update && apt upgrade -y


# Install dependencies
RUN	apt install -y \
    apt-transport-https \
    binutils \
    bzip2 \
    cabextract \
    curl \
    ffmpeg \
    g++ \
    gcc \
    gdb \
    git \
    icu-devtools \
    init-system-helpers \
    iproute2 \
    libatomic1 \
    libc++-dev \
    libc6 \
    libcurl3t64-gnutls \
    libduktape207 \
    libevent-dev \
    libfluidsynth-dev \
    libfontconfig1 \
    libgcc-s1 \
    libicu-dev \
    libjsoncpp-dev \
    libleveldb1d \
    liblzo2-2 \
    liblua5.1-0 \
    libluajit-5.1-2 \
    libmariadb-dev \
    libmariadb-dev-compat \
    libncurses6 \
    libncursesw6 \
    libsdl1.2debian \
    libsdl2-2.0-0 \
    libsqlite3-0 \
    libsqlite3-dev \
    libssl-dev \
    libssl3t64 \
    libunwind8 \
    libzip4t64 \
    locales \
    net-tools \
    netcat-traditional \
    sqlite3 \
    tar \
    telnet \
    tini \
    unzip \
    wget \
    xz-utils \
    zip \
    zlib1g


# Generate locale
RUN          sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
	&& locale-gen \
	&& update-locale LANG=en_US.UTF-8

WORKDIR /home/container

STOPSIGNAL SIGINT

COPY        --chmod=755 --chown=root:root ../entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh
ENTRYPOINT    ["/usr/bin/tini", "-g", "--"]
CMD         ["/entrypoint.sh"]
