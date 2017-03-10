#!/bin/sh
set -ex

version=5.2.2
builddeps='openssl'

# Initial setup as root
if [ kibana != "$USER" ]; then
	apk --no-cache add nodejs $builddeps

	adduser -S -h /kibana kibana
	su -s /bin/sh kibana /setup.sh

	apk --no-cache del $builddeps
	rm /setup.sh
	exit 0
fi

cd /kibana

name=kibana-${version}-linux-x86_64
wget https://artifacts.elastic.co/downloads/kibana/${name}.tar.gz
tar xzf ${name}.tar.gz
mv ${name}/* .
rm -r ${name}

sed -i 's_^NODE=.*_NODE=/usr/bin/node_' bin/kibana
rm -r node
