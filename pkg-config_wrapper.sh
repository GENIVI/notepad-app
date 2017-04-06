#!/bin/sh
PKG_CONFIG_SYSROOT_DIR=/home/vduong/Genivi/GDP-SDK-RPi3/sysroots/cortexa7hf-neon-vfpv4-poky-linux-gnueabi
export PKG_CONFIG_SYSROOT_DIR
PKG_CONFIG_LIBDIR=/home/vduong/Genivi/GDP-SDK-RPi3/sysroots/cortexa7hf-neon-vfpv4-poky-linux-gnueabi/usr/lib/pkgconfig
export PKG_CONFIG_LIBDIR
exec pkg-config "$@"
