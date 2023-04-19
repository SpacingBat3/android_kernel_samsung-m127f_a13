#!/bin/sh
#
# shellcheck shell=sh

if [ -z "$ANDROID_TOOLCHAINS" ]; then
	# physwizz toolchain path
	ANDROID_TOOLCHAINS="./toolchains"
fi

export PLATFORM_VERSION=13
export ANDROID_MAJOR_VERSION=t
export ARCH=arm64

export CROSS_COMPILE="$ANDROID_TOOLCHAINS/aarch64-linux-android-4.9/bin/aarch64-linux-android-"
export CLANG_PATH="$ANDROID_TOOLCHAINS/android_prebuilts_clang_host_linux-x86_clang-5484270-9.0/bin/"
export CLANG_TRIPLE="$ANDROID_TOOLCHAINS/proton-clang-13-clang/bin/aarch64-linux-gnu-"

unset ANDROID_TOOLCHAINS

if [ "$1" = "make" ] && [ -n "$2" ]; then
  shift
	make ARCH=arm64 "$@"
	exit "$?"
fi

if [ "$1" = "variants" ]; then
	[ -f arch/arm64/configs/exynos850-m12nsxx_defconfig ] && echo '<default>'
  echo arch/arm64/configs/exynos850-m12nsxx-*_defconfig | tr ' ' '\n' | sed 's~.*exynos850-m12nsxx-\(.*\)_defconfig$~\1~g'
	exit 1;
fi

operator=''
if [ -n "$1" ]; then
	operator='-'
fi
echo
echo Configuring with defconfig: exynos850-m12nsxx$operator$1_defconfig
echo ==================================================================
make ARCH=arm64 exynos850-m12nsxx$operator$1_defconfig
echo
echo Building the kernel:
echo ====================
make ARCH=arm64 -j"$(nproc)"