#!/bin/sh -ex

version=v4.4.0
builddeps='openssl'

# Initial setup as root
if [ kibana != "$USER" ]; then
	apk --no-cache add nodejs $builddeps

	adduser -S -h /kibana kibana
	su -s /bin/sh kibana /setup.sh

	apk del $builddeps
	rm /setup.sh
	exit 0
fi

cd /kibana

wget https://download.elastic.co/kibana/kibana/kibana-4.4.0-linux-x64.tar.gz
tar xzvf kibana-4.4.0-linux-x64.tar.gz
mv kibana-4.4.0-linux-x64/* .
rm -r kibana-4.4.0-linux-x64

sed -i 's_^NODE=.*_NODE=/usr/bin/node_' bin/kibana
rm -r node
