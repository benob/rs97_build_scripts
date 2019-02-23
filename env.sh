export BUILDROOT=$PWD/buildroot-2018.02.10

export ARCH=mips
export CROSS_COMPILE=mipsel-linux-
export BASE=$BUILDROOT/output/host/bin/$CROSS_COMPILE
export LIBC=uclibc # musl
export SYSROOT="$BUILDROOT/output/host/mipsel-buildroot-linux-$LIBC/sysroot/"
export CC="${BASE}gcc --sysroot=$SYSROOT"
export NM=${BASE}nm
export LD=${BASE}ld
export CXX="${BASE}g++ --sysroot=$SYSROOT"
export RANLIB=${BASE}ranlib
export AR=${BASE}ar

export PATH=$BUILDROOT/output/host/bin/:$BUILDROOT/output/host/mipsel-buildroot-linux-$LIBC/sysroot/usr/bin/:$PATH

export CFLAGS=-DRS97
