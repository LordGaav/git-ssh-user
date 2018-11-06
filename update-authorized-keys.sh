#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

if [ "$#" -ne 2 ]; then
    echo "Usage: ${0} SOURCE_USER DEST_USER"
    exit 1
fi

SOURCE_USER=${1}
SOURCE_HOME=$(getent passwd $SOURCE_USER | cut -d: -f6)
DEST_USER=${2}
DEST_HOME=$(getent passwd $DEST_USER | cut -d: -f6)

if [ ! -d "$SOURCE_HOME/.ssh" -o ! -f "$SOURCE_HOME/.ssh/authorized_keys" ]; then
    echo "Source user is missing authorized_keys file"
    exit 1
fi

if [ ! -d "$DEST_HOME/.ssh" ]; then
    mkdir -m 600 "$DEST_HOME/.ssh"
    chown $DEST_USER "$DEST_HOME/.ssh"
    chgrp $DEST_USER "$DEST_HOME/.ssh"
fi

cp "$SOURCE_HOME/.ssh/authorized_keys" "$DEST_HOME/.ssh/authorized_keys"
chmod 600 "$DEST_HOME/.ssh/authorized_keys"
chown $DEST_USER "$DEST_HOME/.ssh/authorized_keys"
chgrp $DEST_USER "$DEST_HOME/.ssh/authorized_keys"