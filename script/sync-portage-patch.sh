#!/bin/sh

if [ "${UID}" != "0" ]; then
    SCRIPT_NAME=$(basename $0)
    echo "${SCRIPT_NAME}: must run this as root"
    exit 1
fi

SCRIPT_DIR=$(dirname $0)

# 此处目录后面的 / 不能少
SOURCE_DIR="${SCRIPT_DIR}/../gentoo_portage/patches/"
DEST_DIR="/etc/portage/patches/"

rsync -r --delete --mkpath $SOURCE_DIR $DEST_DIR
