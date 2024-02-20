#!/bin/bash

set -x
set -e

export LC_ALL=C.UTF-8
export DEBIAN_FRONTEND=noninteractive

# use eatmydata to prevent excessive sync calls from package install
export LD_PRELOAD=libeatmydata.so
export LD_LIBRARY_PATH=/usr/lib/libeatmydata

WORK='/work'
if [[ ! -d "$WORK/$PACKAGE" ]] ; then
    >&2 echo "Directory '$WORK/$PACKAGE' doesn't exist."
    exit
fi

apt-get update
apt-get -y upgrade

mkdir /tmp/deps
cd /tmp/deps
mk-build-deps --install --tool='apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes' "$WORK/$PACKAGE/debian/control"
cd "$WORK/$PACKAGE"

# Check for argument '--git-export-dir' to copy artifacts to work dir after BUILD_CMD
# The regex will find a pure path or a path in lead characters, which can also contain spaces.
GIT_EXPORT_DIR=$(echo ${BUILD_CMD} | grep -oP -- "(?<=--git-export-dir=)((['\"].+?['\"])+|[^ ]+)")

if [[ "$DOCKER_HOST_OSTYPE" == "darwin"* ]]; then
    ln -s /root/gnupg /root/.gnupg
    
    # On macOS we can just start the build and get the files with macOS owner
    ${BUILD_CMD}
else
    # On 'other' OSes create a user with the same name and gid as the calling user
    groupadd -g "$BUILD_GID" "$BUILD_GNAME"
    useradd -l -m -s /bin/bash -u "$BUILD_UID" -g "$BUILD_GNAME" "$BUILD_UNAME"
    cp -r /root/gnupg "/home/${BUILD_UNAME}/.gnupg"
    chown -R "${BUILD_UNAME}:${BUILD_GNAME}" "/home/${BUILD_UNAME}/.gnupg"

    # And start the package build as the created user
    su -c "${BUILD_CMD}" "${BUILD_UNAME}"
fi

# For visual style, we deactivate the debug output of bash at this point
set +x
if [ -n "${GIT_EXPORT_DIR}" ]; then
    echo "INFO: Found git-export-dir argument, copy package files to ${WORK}"
    find "${GIT_EXPORT_DIR}" -type f -exec cp {} ${WORK} \;
fi
