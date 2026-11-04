#!/bin/bash
# Entrypoint for the Astroneer dedicated server, driven by AstroTuxLauncher.
#
# Replaces the stock Wine entrypoint from the wine yolk. The stock one runs its
# own steamcmd pass, which collides with the launcher's DepotDownloader updater,
# so the update step is skipped here and handed to the launcher instead.

set -euo pipefail

CONTAINER_DIR=/home/container
CONFIG="${CONTAINER_DIR}/launcher.toml"

cd "${CONTAINER_DIR}"
export HOME="${CONTAINER_DIR}"

# The base image ships no TERM, and the launcher's RCON prompt needs a tty.
export TERM=xterm

to_bool() {
    # Lowercased via tr rather than ${1,,} so the script also runs on bash 3.
    case "$(echo "${1}" | tr '[:upper:]' '[:lower:]')" in
        1|true|yes|on) echo true ;;
        *) echo false ;;
    esac
}

METHOD="$(echo "${NOTIFY_METHOD:-}" | tr '[:upper:]' '[:lower:]')"

cat > "${CONFIG}" <<EOF
[launcher]
AutoUpdateServer = $(to_bool "${SERVER_AUTO_UPDATE:-1}")
CheckNetwork = $(to_bool "${CHECK_NETWORK:-0}")
OverwritePublicIP = $(to_bool "${OVERWRITE_IP:-0}")
LogDebugMessages = $(to_bool "${LOG_DEBUG:-1}")
DisableEncryption = true
AstroServerPath = "${CONTAINER_DIR}/AstroneerServer"
WinePrefixPath = "${CONTAINER_DIR}/winepfx"
LogPath = "${CONTAINER_DIR}/logs"

[launcher.notifications]
method = "${METHOD}"
name = "${SERVER_NAME:-Astroneer Dedicated Server}"

[launcher.notifications.discord]
webhookURL = "${DISCORD_WEBHOOK:-}"

[launcher.notifications.ntfy]
topic = "${NTFY_TOPIC:-}"
serverURL = "https://ntfy.sh"

[launcher.status]
SendStatus = $([ -n "${UPTIME_KUMA_URL:-}" ] && echo true || echo false)
EndpointURL = "${UPTIME_KUMA_URL:-}"
EOF

# Install on the first boot, start on every boot after that.
if [ -f "${CONTAINER_DIR}/AstroneerServer/AstroServer.exe" ]; then
    COMMAND=start
else
    COMMAND=install
fi

exec astrotux-launcher -c "${CONFIG}" "${COMMAND}"
