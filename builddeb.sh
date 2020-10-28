#!/bin/bash
set -x

SNAME=$0
DEFAULT_BUILDCMD='dpkg-buildpackage -us -uc'

function print_usage() {
    echo "$SNAME [\"BUILDCMD\"] [PKGSRC]" >&2
    echo ""
    echo "    PKGSRC:   The Debian package source directory." >&2
    echo "              If not specified \$PWD will be used." >&2
    echo "    BUILDCMD: The command which should be used to build the package." >&2
    echo "              If not spacified \"$DEFAULT_BUILDCMD\" will be used." >&2
    echo "              If you want to add arguments to your BUILDCMD use \"\"." >&2
}
# builddeb.sh PKG_SRC_DIR
# builddeb.sh BUILD_CMD PKG_SRC_DIR
# builddeb.sh BUILD_CMD BUILD_OPTS PKG_SRC_DIR

if [[ ("$1" == "-h")||("$1" == "--help")||("$1" == "-?") ]]; then
    print_usage
    exit 0
fi

if [ $# -gt 2 ]; then
    print_usage
    exit 1
fi

if [ $# -lt 1 ]; then
    WORK="$(realpath "$PWD/..")"
    PACKAGE="$(basename "$PWD")"
else
    WORK="$(realpath "${@: -1}/..")"
    PACKAGE="$(basename "$(realpath "${@: -1}")")"
fi

if [ $# -lt 2 ]; then
    BUILD_CMD="$DEFAULT_BUILDCMD"
else
    BUILD_CMD="$1"
fi

if [ -z ${FLAVOUR} ]; then
    CONTAINER="builddeb";
else
    CONTAINER="builddeb-${FLAVOUR}";
fi

exec docker run \
    --rm \
    --cpu-shares 512 \
    -v "$WORK:/work" \
    -v "$HOME/.gnupg:/root/gnupg:ro" \
    -v "$HOME/.gitconfig:/etc/skel/.gitconfig:ro" \
    -e PACKAGE="$PACKAGE" \
    -e BUILD_CMD="$BUILD_CMD" \
    -e BUILD_UNAME="$USER" \
    -e BUILD_UID="$UID" \
    -e BUILD_GNAME="$(id -g -n)" \
    -e BUILD_GID="$(id -g)" \
    "${CONTAINER}"