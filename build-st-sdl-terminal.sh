#!/bin/bash

. env.sh
set -e -u -o pipefail

DEST=$PWD/ipk
mkdir -p $DEST

# download source
#wget https://github.com/benob/rs97_st-sdl/archive/master.zip -O rs97_st-sdl-master.zip
#unzip rs97_st-sdl-master.zip
#cd rs97_st-sdl-master
[ -d rs97_st-sdl ] || git clone https://github.com/benob/rs97_st-sdl
cd rs97_st-sdl

# build
make -B

# make ipk
mkdir -p home/retrofw/apps/st-sdl home/retrofw/apps/gmenu2x/sections/applications/
cp /usr/share/icons/Adwaita/32x32/apps/utilities-terminal.png home/retrofw/apps/st-sdl/st.png
cp st libst-preload.so sdl_test home/retrofw/apps/st-sdl

cat > home/retrofw/apps/gmenu2x/sections/applications/st-sdl <<EOF
title=Terminal
description=terminal emulator
exec=/home/retrofw/apps/st-sdl/st
EOF
tar --owner=0 --group=0 -zcf data.tar.gz home

cat > control <<EOF
Package: st-sdl-terminal
Version: `date +'%Y%m%d'`
Description: terminal emulator
Section: applications
Priority: optional
Maintainer: benob
Architecture: mipsel
Homepage: https://github.com/benob/rs97_st-sdl
Depends:
Source: https://github.com/benob/rs97_st-sdl
EOF
tar --owner=0 --group=0 -zcf control.tar.gz control

echo 2.0 > debian-binary

rm -f $DEST/st-sdl-terminal.ipk
ar -r $DEST/st-sdl-terminal.ipk control.tar.gz data.tar.gz debian-binary

cd ..

# cleanup
rm -rf rs97_st-sdl-master.zip rs97_st-sdl-master

echo DONE
