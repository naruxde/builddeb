#!/bin/bash

set -x
set -e

export DEBIAN_FRONTEND=noninteractive

# use eatmydata to prevent excessive sync calls from package install
export LD_PRELOAD=libeatmydata.so
export LD_LIBRARY_PATH=/usr/lib/libeatmydata

WORK='/work'
if [[ ! -d "$WORK/$PACKAGE" ]] ; then
    >&2 echo "Directory '$WORK/$PACKAGE' doesn't exist."
    exit
fi

# create a user with the same name and gid as the calling user
groupadd -g ${BUILD_GID} ${BUILD_GNAME}
useradd -l -m -s /bin/bash -u ${BUILD_UID} -g ${BUILD_GNAME} ${BUILD_UNAME}
cp -r /root/gnupg "/home/${BUILD_UNAME}/.gnupg"
chown -R "${BUILD_UNAME}:${BUILD_GNAME}" "/home/${BUILD_UNAME}/.gnupg"

apt-get update
apt-get -y upgrade

mkdir /tmp/deps
cd /tmp/deps
mk-build-deps --install --tool='apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes' $WORK/$PACKAGE/debian/control
cd "$WORK/$PACKAGE"

su -c "${BUILD_CMD}" "${BUILD_UNAME}"