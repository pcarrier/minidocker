#!/bin/sh
set -ex

version=0.7.2
builddeps='go git'

apk --no-cache add $builddeps

export GOPATH=/go
mkdir -p /go/src/github.com/nats-io
cd /go/src/github.com/nats-io
git clone --depth=1 --branch=v${version} https://github.com/nats-io/gnatsd
cd gnatsd

go get .

mv /go/bin/gnatsd /usr/bin

apk del $builddeps
cd /
rm -r /go /etc/ssl
