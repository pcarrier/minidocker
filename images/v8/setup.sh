#!/bin/sh
set -euxo pipefail

# Track v8/v8 5.8-lkgr
version=5.8.283.9
builddeps='bash binutils-gold clang@edge clang-dev@edge g++ git linux-headers musl-dev ninja python'

apk --no-cache add $builddeps

mkdir /build
cd /build

git clone --depth=1 https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=$PWD/depot_tools:$PATH
gclient root
gclient config --spec 'solutions = [{
  "name": "v8",
  "url": "https://chromium.googlesource.com/v8/v8.git",
}]'
gclient sync --nohooks --shallow --revision v8@${version}

CC=`which clang` CXX=`which clang++` \
  ./v8/build/gyp_v8 \
  -Dv8_use_external_startup_data=0 \
  -Dv8_enable_i18n_support=0 \
  -Dcomponent=shared_library \
  -f ninja

/usr/bin/ninja -C v8/out/Release v8

ar -M <<EOF
create /usr/lib/libv8.a
addlib v8/out/Release/obj/tools/gyp/libv8_snapshot.a
addlib v8/out/Release/obj/tools/gyp/libv8_libbase.a
addlib v8/out/Release/obj/tools/gyp/libv8_libplatform.a
addlib v8/out/Release/obj/tools/gyp/libv8_base.a
save
end
EOF
mv v8/out/Release/lib/libv8.so /usr/lib

rm v8/include/OWNERS
cp -r v8/include/* /usr/include

apk --no-cache del `echo $builddeps|sed s/@edge//g`
cd /
rm -r build etc/ssl setup.sh
