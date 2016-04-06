#!/bin/sh

## If security wasn't a concern,
# we could grab apk.static ourselves and use --allow-untrusted.
# curl -s ${mirror}/${version}/main/x86_64/apk-tools-static-${apkversion}.apk | \
# tar xzO sbin/apk.static > ${tmp}/apk.static
# chmod +x ${tmp}/apk.static
cat > ${tmp}/Dockerfile <<EOF
FROM scratch

ADD \
bootstrap/apk.static \
bootstrap/alpine-devel@lists.alpinelinux.org-4a6a0840.rsa.pub \
bootstrap/alpine-devel@lists.alpinelinux.org-4d07755e.rsa.pub \
bootstrap/alpine-devel@lists.alpinelinux.org-5243ef4b.rsa.pub \
bootstrap/alpine-devel@lists.alpinelinux.org-524d27bb.rsa.pub \
bootstrap/alpine-devel@lists.alpinelinux.org-5261cecb.rsa.pub \
/

RUN ["/apk.static", "-X", "${mirror}/${version}/main", "--initdb", "--no-cache", "--update-cache", "--keys-dir", "/", "add", "alpine-baselayout", "alpine-keys", "apk-tools", "musl-utils"]

RUN rm /apk.static /*.pub && printf '%s\n%s\n@edge %s\n@edge %s\n@testing %s\n' ${mirror}/${version}/main ${mirror}/${version}/community ${mirror}/edge/main ${mirror}/edge/community ${mirror}/edge/testing > /etc/apk/repositories
EOF

docker build -t toflatten.img -f ${tmp}/Dockerfile .

docker rm flattened.container || true
docker run --name flattened.container toflatten.img /bin/true

docker export flattened.container > ${tmp}/flattened.tar
docker rm flattened.container || true

docker import ${tmp}/flattened.tar ${repo}:${ts}

docker tag  ${repo}:${ts} ${repo}:latest

if [ -n "$push" ]; then
	docker push ${repo}
fi
