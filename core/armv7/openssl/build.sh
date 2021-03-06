#!/bin/bash

set -e

mkdir -p /tmp/openssl
cd /tmp/openssl
wget https://www.openssl.org/source/openssl-1.0.2o.tar.gz
gpg --import /builder/openssl/openssl.caswell.gpg.pub
gpg --import /builder/openssl/openssl.levitte.gpg.pub
gpg --verify /builder/openssl/openssl-1.0.2o.tar.gz.sig ./openssl-1.0.2o.tar.gz
tar -xvf openssl-1.0.2o.tar.gz
cd openssl-1.0.2o

TARGET=android
BUILD=armv7-linux-android

export ANDROID_DEV=/opt/gcc-armv7-android
export PATH=$PATH:/opt/gcc-armv7-android/bin

./Configure \
	${TARGET} \
	no-shared \
	no-ssl2 \
	no-ssl3 \
	no-engine \
	no-dso \
	no-asm \
	no-hw \
	no-comp \
	-D__ANDROID_API__=21 \
	-funroll-loops -ffast-math -O3 \
	-fPIC \
	-DOPENSSL_PIC \
	--cross-compile-prefix="/opt/gcc-armv7-android/bin/arm-linux-androideabi-" \
	--prefix=/opt/openssl/${BUILD}
make depend
make
make install

