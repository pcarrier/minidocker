#!/bin/sh
set -ex

UID=${UID:-1000}
USER=${USER:-user}
adduser -u $UID -h /$USER -D $USER
exec "$@"
