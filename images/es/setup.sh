#!/bin/sh
set -ex

version=5.2.2

# Initial setup as root
if [ es != "$USER" ]; then
	apk --no-cache add openjdk8-jre-base openssl

	adduser -S -h /es es
	su -s /bin/sh es /setup.sh

	rm /setup.sh
	exit 0
fi

cd /es
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${version}.tar.gz

tar xzf elasticsearch-${version}.tar.gz
rm elasticsearch-${version}.tar.gz

mv elasticsearch-${version}/* .
rm -r elasticsearch-${version}

sed -i 's_# network.host: .*_network.host: 0.0.0.0_' config/elasticsearch.yml
