#!/bin/bash

. env.sh
set -e -u -o pipefail

DEST=$PWD/ipk
mkdir -p $DEST

which convert 2>/dev/null || (echo "imagemagik is required"; exit 1)
which cmake 2>/dev/null || (echo "cmake is required"; exit 1)

# download source
[ -d rs97_hydracastle ] || git clone https://github.com/benob/rs97_hydracastle.git 
cd rs97_hydracastle

# build
rm -rf build
mkdir build
cd build
cmake .. -DCMAKE_SYSROOT="$SYSROOT" #-DCMAKE_BUILD_TYPE=Release 
make -j 4
cd ..

# make ipk
mkdir -p home/retrofw/games/hydracastle home/retrofw/apps/gmenu2x/sections/games/
cp -r data build/hcl home/retrofw/games/hydracastle
convert icon.png -scale 32x32 home/retrofw/games/hydracastle/hcl.png

cat > home/retrofw/apps/gmenu2x/sections/games/hydracastle <<EOF
title=Hydra
description=platform game
exec=/home/retrofw/games/hydracastle/hcl
EOF
tar --owner=0 --group=0 -zcf data.tar.gz home

cat > control <<EOF
Package: hydracastle
Version: `date +'%Y%m%d'`
Description: platform game
Section: games
Priority: optional
Maintainer: benob
Architecture: mipsel
Homepage: https://hydra-castle-labyrinth.en.uptodown.com
Depends:
Source: https://github.com/benob/rs97_hydracastle
EOF
tar --owner=0 --group=0 -zcf control.tar.gz control

echo 2.0 > debian-binary

rm -f $DEST/hydracastle.ipk
ar -r $DEST/hydracastle.ipk control.tar.gz data.tar.gz debian-binary

cd ..

# cleanup
#rm -rf rs97_hydracastle

echo DONE
