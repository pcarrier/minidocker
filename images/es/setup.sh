#!/bin/sh
set -ex

version=2.2.0

# Initial setup as root
if [ es != "$USER" ]; then
	apk --no-cache add openjdk8-jre-base openssl

	adduser -S -h /es es
	su -s /bin/sh es /setup.sh

	rm /setup.sh
	exit 0
fi

cd /es

wget https://download.elasticsearch.org/elasticsearch/\
release/org/elasticsearch/distribution/tar/elasticsearch/\
${version}/elasticsearch-${version}.tar.gz

tar xzvf elasticsearch-${version}.tar.gz
rm elasticsearch-${version}.tar.gz

mv elasticsearch-${version}/* .
rm -r elasticsearch-${version}

sed -i 's_# network.host: .*_network.host: 0.0.0.0_' config/elasticsearch.yml
