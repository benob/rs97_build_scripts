#!/bin/bash

. env.sh
set -e -u -o pipefail

DEST=$PWD/ipk
mkdir -p $DEST

# download source
git clone https://github.com/benob/rs97_prince.git 
cd rs97_prince

# build
make

# make ipk
mkdir -p home/retrofw/apps/prince home/retrofw/apps/gmenu2x/sections/games/
cp -r prince data home/retrofw/apps/prince
cp data/KID.DAT/res608.png home/retrofw/apps/prince/prince.png

cat > home/retrofw/apps/gmenu2x/sections/games/prince <<EOF
title=Prince
description=Prince of Persia
exec=/home/retrofw/apps/prince/prince
EOF
tar --owner=0 --group=0 -zcf data.tar.gz home

cat > control <<EOF
Package: prince
Version: 1
Description: platform game
Section: games
Priority: optional
Maintainer: benob
Architecture: mipsel
Homepage: https://github.com/NagyD/SDLPoP
Depends:
Source: https://github.com/benob/rs97_prince
EOF
tar --owner=0 --group=0 -zcf control.tar.gz control

echo 2.0 > debian-binary

ar -r $DEST/prince.ipk control.tar.gz data.tar.gz debian-binary

cd ..

# cleanup
rm -rf rs97_prince 
