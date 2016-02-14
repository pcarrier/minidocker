#!/bin/sh -ex

. ./conf.sh

tmp=$PWD/tmp

mkdir -p ${tmp}

build() {
	name=$1
	(
	  echo "FROM ${repo}:${ts}"
	  cat ${name}/Dockerfile
	) > ${name}/.tmp.Dockerfile
	docker build \
		-t ${org}/${name}:${ts} \
		-f ${name}/.tmp.Dockerfile \
		${name}
	docker tag ${org}/${name}:${ts} ${org}/${name}:latest
}

push() {
	docker push ${org}/$1
}

for name in ${skip}; do
	eval _skip_${name}=1
done

if [ -z "$_skip_alpine" ]; then
	. ./build.base.sh
fi

cd images

if [ -z "${names}" ]; then
	names=*
fi

for name in ${names}; do
	eval skipped=\$_skip_${name}
	if [ -z "${skipped}" ]; then
		build ${name}
		if [ -n "${push}" ]; then
			push ${name}
		fi
	fi
done
