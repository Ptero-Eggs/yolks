#!/bin/bash

#
# Copyright (c) 2021 Matthew Penner
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

# Wait for the container to fully initialize
sleep 1

# Default the TZ environment variable to UTC.
TZ=${TZ:-UTC}
export TZ

# Set environment variable that holds the Internal Docker IP of this container
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# Set environment for Steam Proton
if [ -f "/usr/local/bin/proton" ]; then
	if [ -n "${SRCDS_APPID}" ]; then
		mkdir -p "/home/container/.steam/steam/steamapps/compatdata/${SRCDS_APPID}"
		export STEAM_COMPAT_CLIENT_INSTALL_PATH="/home/container/.steam/steam"
		export STEAM_COMPAT_DATA_PATH="/home/container/.steam/steam/steamapps/compatdata/${SRCDS_APPID}"
		# Fix for pipx with protontricks
		export PATH=$PATH:/root/.local/bin
	else
		echo -e "----------------------------------------------------------------------------------"
		echo -e "WARNING!!! SRCDS_APPID is missing and must be set when using Proton"
		echo -e "Server will now terminate"
		echo -e "----------------------------------------------------------------------------------"
		exit 1
	fi
fi

# Switch to the container's working directory
cd /home/container || { echo "Failed to switch to the container's working directory!" ; exit 1; }

# Set default values for steam if not provided
STEAM_USER=${STEAM_USER:-anonymous}
if [ "${STEAM_USER}" == "anonymous" ]; then
	STEAM_PASS=""
	STEAM_AUTH=""
fi


## If AUTO_UPDATE is not set or is set to 1, run steamcmd to update the server
if [ -z "${AUTO_UPDATE}" ] || [ "${AUTO_UPDATE}" == "1" ]; then
	if [ -n "${SRCDS_APPID}" ]; then
			# shellcheck disable=SC2046,SC2086
			./steamcmd/steamcmd.sh +force_install_dir /home/container \
			 +login "${STEAM_USER}" "${STEAM_PASS}" "${STEAM_AUTH}" \
			 $([[ "${WINDOWS_INSTALL}" == "1" ]] && printf %s '+@sSteamCmdForcePlatformType windows') \
			 $([[ -z ${HLDS_GAME} ]] || printf %s "+app_set_config 90 mod ${HLDS_GAME}") \
			 "+app_update ${SRCDS_APPID} $([[ -z ${SRCDS_BETAID} ]] || printf %s "-beta ${SRCDS_BETAID}") $([[ -z ${SRCDS_BETAPASS} ]] || printf %s "-betapassword ${SRCDS_BETAPASS}") ${INSTALL_FLAGS}  $( [[ "${VALIDATE}" == "1" ]] && printf %s 'validate' )" \
			 $([[ "${UPDATE_STEAMWORKS}" == "1" ]] && printf %s '+app_update 1007') \
			 +quit
	fi
fi

# Replace Startup Variables
MODIFIED_STARTUP=$(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo -e ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}
