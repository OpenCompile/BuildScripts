#!/bin/bash

cd Repos/xmrig/xmrig

mkdir -p build
cd build/
cmake .. -DCMAKE_BUILD_TYPE=Release -DWITH_CN_LITE=OFF -DWITH_CN_HEAVY=OFF -DWITH_CN_PICO=OFF -DWITH_CN_FEMTO=OFF -DWITH_ARGON2=OFF -DWITH_KAWPOW=OFF -DWITH_GHOSTRIDER=OFF
make -j $(nproc)

cd ../../../../

cp Repos/xmrig/xmrig/build/xmrig .

tar -csvf Repos/xmrig/xmrig/build/xmrig.tar.gz xmrig

rm xmrig

mkdir -p TarRepo/tmp/

cp Repos/xmrig/xmrig/build/xmrig.tar.gz TarRepo/tmp/xmrig.tar.gz
