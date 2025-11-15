# ---------------------------------------------------------
# MariaDB Yolk for Pterodactyl
#
# MariaDB is a community-developed, commercially supported
# fork of the MySQL relational database management system,
# intended to remain free and open-source software under
# the GNU General Public
#
# ---------------------------------------------------------

FROM mariadb:12.0

LABEL author="Daniel Barton" maintainer="danielb@purpleflaghosting.com"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install -y --no-install-recommends \
  gettext-base \
  libnss-wrapper \
  && rm -rf /var/lib/apt/lists/*

## Prepare NSS Wrapper for the entrypoint
ENV NSS_WRAPPER_PASSWD=/tmp/passwd NSS_WRAPPER_GROUP=/tmp/group
COPY --chown=root:root --chmod=644 nss/passwd.template nss/group.template /

ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY --chown=root:root --chmod=755 ../entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
