#!/bin/bash
# Bash script for compiling tinyDTLS binaries for Linux, Windows, and Android.
#
# Requires android-ndk for compiling the Android binaries and MinGW for the
# Windows binaries.

set -euox pipefail

if [[ "$#" -ne 1 ]]; then
  echo "usage: $0 <path to libopaque>"
  exit 1
fi

# Path variables
OPAQUE_DIRECTORY="$1"
LINUX_DIRECTORY="$PWD/linux"
WINDOWS_DIRECTORY="$PWD/windows"

# Download opaque submodule
git submodule update --init --recursive

# Initialize opaque compilation
cd "$OPAQUE_DIRECTORY"

# Compile Linux binary
make -f ./makefile -k clean
make
mv libopaque.so "$LINUX_DIRECTORY"/libopaque.so

# Compile Windows binary (using MinGW)
export SODIUM_VERSION="1.0.18"
if [[ ! -d win ]]; then
  curl https://download.libsodium.org/libsodium/releases/libsodium-${SODIUM_VERSION}-mingw.tar.gz -o sodium_android.tar.gz
  mkdir -p win
  tar xvf sodium.tar.gz -C win/
fi
make clean
make mingw64
mv libopaque.dll "$WINDOWS_DIRECTORY"/libopaque.dll

# Compile Android binaries
ANDROID_DIRECTORY=$OLDPWD/android/src/main/jniLibs
ndks=( "$ANDROID_HOME"/ndk/* )
NDK="$(printf "%s" "${ndks[0]}")"
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64

# Configure and build.
export AR=$TOOLCHAIN/bin/llvm-ar
export LD=$TOOLCHAIN/bin/ld
export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
export STRIP=$TOOLCHAIN/bin/llvm-strip

# Android architectures and target triples that are used as compile targets
# See https://developer.android.com/ndk/guides/other_build_systems#autoconf
declare -a ANDROID_ARCHITECTURES=("arm64-v8a" "armeabi-v7a" "x86" "x86_64")
declare -a ANDROID_TRIPLES=("aarch64-linux-android" "armv7a-linux-androideabi" "i686-linux-android" "x86_64-linux-android")
declare -a ANDROID_API=("21" "19" "19" "21")

# We need to setup libsodium first
if [[ ! -d android ]]; then
  curl -LJ0 "https://github.com/Skycoder42/libsodium_dart_bindings/releases/download/libsodium-binaries/android/v$SODIUM_VERSION/libsodium-android.tar.gz" -o sodium_android.tar.gz
  mkdir -p android
  tar xzvf sodium_android.tar.gz -C android/
fi

# Compile Android binaries
for (( i=0; i<${#ANDROID_ARCHITECTURES[*]}; ++i));
do
   make clean
   export ARCHITECTURE="${ANDROID_ARCHITECTURES[$i]}"
   export TARGET="${ANDROID_TRIPLES[$i]}${ANDROID_API[$i]}"
   export CC=$TOOLCHAIN/bin/$TARGET-clang
   # We need the headers from somewhere, might as well use the pre-existing win directory.
   export CFLAGS="-g -Iaux_ -Iwin/libsodium-win64/include"
   export LDFLAGS="-g -lsodium -Landroid/$ARCHITECTURE"
   make libopaque.so "CC=$CC" "CFLAGS=$CFLAGS" "LDFLAGS=$LDFLAGS"
   mkdir -p "${ANDROID_DIRECTORY}/$ARCHITECTURE"
   mv libopaque.so "${ANDROID_DIRECTORY}/$ARCHITECTURE"/libopaque.so
done
