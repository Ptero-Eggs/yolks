# ---------------------------------------
# Astroneer dedicated server, run under Wine via AstroTuxLauncher
# ---------------------------------------
FROM            --platform=$TARGETOS/$TARGETARCH ghcr.io/ptero-eggs/yolks:wine_latest

LABEL           author="Dxrty369" maintainer="mr_drake@icloud.com"
LABEL           org.opencontainers.image.source="https://github.com/Dxrty369/astroneer-tux"

ARG             LAUNCHER_VERSION=1.1.13
ARG             LAUNCHER_SHA256=1bdcf19c5970c2d759e798d13a93c83b1b3b387b16a34c067a6e69b18d1ad803

## AstroTuxLauncher drives the dedicated server over RCON and handles saves,
## so the launcher binary replaces the stock Wine entrypoint.
RUN             curl -fsSL -o /usr/local/bin/astrotux-launcher \
                "https://github.com/JoeJoeTV/AstroTuxLauncher/releases/download/${LAUNCHER_VERSION}/AstroTuxLauncher" \
    &&         echo "${LAUNCHER_SHA256}  /usr/local/bin/astrotux-launcher" | sha256sum -c - \
    &&         chmod +x /usr/local/bin/astrotux-launcher

## Wine and wineserver must both resolve before the launcher aborts on start.
RUN             command -v wine && command -v wineserver

## WINEDEBUG=-all silences the Wine loader chatter that otherwise floods the console.
ENV             WINEDEBUG=-all

COPY            --chmod=755 --chown=root:root ./entrypoint.sh /entrypoint.sh
RUN             chmod +x /entrypoint.sh
ENTRYPOINT      [ "/entrypoint.sh" ]
