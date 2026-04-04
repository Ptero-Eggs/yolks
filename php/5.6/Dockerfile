FROM        --platform=$TARGETOS/$TARGETARCH ghcr.io/ptero-eggs/yolks:debian

LABEL       author="Franck Dechavanne" maintainer="rallymen007@gmail.com"

RUN         apt update \
            && apt -y upgrade
RUN         apt-get -y install apt-transport-https lsb-release ca-certificates

# setup the sury repository
WORKDIR     /tmp
RUN         wget -q -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN         echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
RUN         apt-get update
RUN         apt-get -y install php5.6 php5.6-common php5.6-gd php5.6-mysql php5.6-imap php5.6-cli php5.6-cgi php-pear php5.6-curl php5.6-intl php5.6-pspell php5.6-sqlite3 php5.6-tidy php5.6-xmlrpc php5.6-xsl

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
