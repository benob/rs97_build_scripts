#!/bin/bash

set -e -u -o pipefail

wget https://buildroot.org/downloads/buildroot-2018.02.10.tar.gz -O buildroot-2018.02.10.tar.gz
tar xvf buildroot-2018.02.10.tar.gz
cd buildroot-2018.02.10

make defconfig BR2_DEFCONFIG=../retrofw.buildroot.config
make -j 4

cd ..
