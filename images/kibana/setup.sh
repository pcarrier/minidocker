#!/bin/sh -ex

version=4.4.1
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

wget https://download.elastic.co/kibana/kibana/kibana-${version}-linux-x64.tar.gz
tar xzvf kibana-${version}-linux-x64.tar.gz
mv kibana-${version}-linux-x64/* .
rm -r kibana-${version}-linux-x64

sed -i 's_^NODE=.*_NODE=/usr/bin/node_' bin/kibana
rm -r node
