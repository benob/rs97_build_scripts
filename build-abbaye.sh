#!/bin/bash

. env.sh
set -e -u -o pipefail

DEST=$PWD/ipk
mkdir -p $DEST

which convert 2>/dev/null || (echo "imagemagik is required"; exit 1)

# download source
wget https://github.com/benob/rs97_abbaye/archive/master.zip -O rs97_abbaye-master.zip
unzip rs97_abbaye-master.zip
cd rs97_abbaye-master

# build
make

# make ipk
mkdir -p home/retrofw/games/abbaye home/retrofw/apps/gmenu2x/sections/games/
cp -r data graphics sounds abbayev2 abbayev2.png home/retrofw/games/abbaye

cat > home/retrofw/apps/gmenu2x/sections/games/abbaye <<EOF
title=Abbaye
description=platform game
exec=/home/retrofw/games/abbaye/abbayev2
EOF
tar --owner=0 --group=0 -zcf data.tar.gz home

cat > control <<EOF
Package: abbaye
Version: `date +'%Y%m%d'`
Description: platform game
Section: games
Priority: optional
Maintainer: benob
Architecture: mipsel
Homepage: https://locomalito.com/abbaye_des_morts.php
Depends:
Source: https://github.com/benob/rs97_abbaye
EOF
tar --owner=0 --group=0 -zcf control.tar.gz control

echo 2.0 > debian-binary

rm -f $DEST/abbaye.ipk
ar -r $DEST/abbaye.ipk control.tar.gz data.tar.gz debian-binary

cd ..

# cleanup
rm -rf rs97_abbaye-master.zip rs97_abbaye-master

echo DONE
