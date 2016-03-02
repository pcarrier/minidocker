#!/bin/sh
set -ex

version=4.8.271.20
builddeps='bash binutils-gold g++ git linux-headers ninja python'

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

sed -i -e /-Wshorten-64-to-32/d -e /-fcolor-diagnostics/d v8/build/standalone.gypi

CC=`which gcc` CXX=`which g++` \
  ./v8/build/gyp_v8 \
  -Dv8_use_external_startup_data=0 \
  -Dv8_enable_i18n_support=0 \
  -Dcomponent=shared_library \
  -f ninja

/usr/bin/ninja -C v8/out/Release v8

mkdir -p /v8/lib
ar -M <<EOF
create /v8/lib/libv8.a
addlib v8/out/Release/obj/tools/gyp/libv8_snapshot.a
addlib v8/out/Release/obj/tools/gyp/libv8_libbase.a
addlib v8/out/Release/obj/tools/gyp/libv8_libplatform.a
addlib v8/out/Release/obj/tools/gyp/libv8_base.a
save
end
EOF
mv v8/out/Release/lib/libv8.so /v8/lib/
mv v8/include /v8/include

apk del $builddeps
cd /
rm -r build etc/ssl setup.sh
