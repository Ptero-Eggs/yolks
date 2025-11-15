#!/bin/bash
cd /home/container || { echo "Could not change to /home/container directory! Exiting."; exit 1; }

# Make internal Docker IP address available to processes.
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# Determine correct executables to use
if which mariadbd-safe > /dev/null ; then
	MARIADBD_EXECUTABLE="mariadbd"
	MARIADB_INSTALLDB_EXECUTABLE="mariadb-install-db"
	MARIAAB_UPGRADE_EXECUTABLE="mariadb-upgrade"
	MARIADB_ADMIN_EXECUTABLE="mariadb-admin"
	MARIADB_EXECUTABLE="mariadb"

else
	MARIADBD_EXECUTABLE="mysqld"
	MARIADB_INSTALLDB_EXECUTABLE="mysql_install_db"
	MARIAAB_UPGRADE_EXECUTABLE="mysql_upgrade"
	MARIADB_ADMIN_EXECUTABLE="mysqladmin"
	MARIADB_EXECUTABLE="mysql"
fi

export MARIADB_EXECUTABLE


# Setup NSS Wrapper - Some valiables already set in the Dockerfile
USER_ID=$(id -u)
GROUP_ID=$(id -g)
export USER_ID GROUP_ID
envsubst < /passwd.template > "${NSS_WRAPPER_PASSWD}"
envsubst < /group.template > "${NSS_WRAPPER_GROUP}"
if [ -f  /usr/lib/libnss_wrapper.so ]; then
	export LD_PRELOAD=/usr/lib/libnss_wrapper.so
else
	export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libnss_wrapper.so
fi


# Ensure required folders exist
mkdir -p "$HOME/run/mysqld"
mkdir -p "$HOME/log/mysql"
mkdir -p "$HOME/mysql"


# Only run install db if the database is not setup
if [ ! -f "$HOME/mysql/user.frm" ] ; then
	echo "Database not setup - running initial setup"
	$MARIADB_INSTALLDB_EXECUTABLE --datadir="$HOME/mysql"
fi


echo "Starting MariaDB server..."
$MARIADBD_EXECUTABLE --datadir="$HOME/mysql" &
PID=$!

# Wait for server to start, timeout and fail after 60 seconds
for _ in {1..60}; do
    if $MARIADB_ADMIN_EXECUTABLE ping --silent > /dev/null 2>&1 ; then
        break
    fi
    sleep 1
done
if ! $MARIADB_ADMIN_EXECUTABLE ping --silent ; then
	echo "MariaDB server failed to start within 60 seconds. Exiting."
	exit 1
fi

# Check if an upgrade is needed
if $MARIAAB_UPGRADE_EXECUTABLE -u container --check-if-upgrade-is-needed --silent ; then
	echo "Running database upgrade..."
	$MARIAAB_UPGRADE_EXECUTABLE -u container
	echo "Database upgrade completed."
else
	echo "No database upgrade needed."
fi


# Replace Startup Variables
MODIFIED_STARTUP=$(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}

# Incase we reach here without the server being asked to stop, ask it now
echo "Stopping MariaDB server..."
$MARIADB_ADMIN_EXECUTABLE -u container shutdown --silent

# Wait for the server to stop
wait $PID > /dev/null 2>&1
