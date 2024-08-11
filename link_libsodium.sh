#!/bin/bash

set -e

readonly CWD=$PWD
readonly OS=$(uname)
readonly LIBSODIUM_VERSION="1.0.20"

test -d tmp/libsodium || mkdir -p tmp/libsodium

cd tmp/libsodium

curl --retry 5 --retry-delay 0 -sL https://github.com/jedisct1/libsodium/releases/download/$LIBSODIUM_VERSION-RELEASE/libsodium-$LIBSODIUM_VERSION.tar.gz -o libsodium-$LIBSODIUM_VERSION.tar.gz
tar xfz libsodium-$LIBSODIUM_VERSION.tar.gz --strip-components=1

CONFIGURE_ARGS="--prefix ${PWD}"
if [[ "${OS}" == "SunOS" ]]; then
  # On Illumos / Solaris libssp causes linking issues when building wal-g.
  CONFIGURE_ARGS="${CONFIGURE_ARGS} --disable-ssp"
fi      

./configure ${CONFIGURE_ARGS}

echo "point 4......"

make --debug

echo "point 5......"

make check 

echo "point 6......"

make install

echo "point 7......"

# Remove shared libraries for using static
rm -f lib/*.so lib/*.so.* lib/*.dylib

cd ${CWD}
