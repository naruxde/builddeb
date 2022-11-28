#!/bin/bash

set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

export FLAVOR="revpi-buster"

( cd "${DIR}/${FLAVOR}" && docker build -t "builddeb-$FLAVOR" . )

exec "$DIR/builddeb.sh" "$@"
