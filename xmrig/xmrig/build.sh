#!/bin/bash

cd Repos/xmrig/xmrig

mkdir -p build
cd build/
cmake .. -DCMAKE_BUILD_TYPE=Release -DWITH_CN_LITE=OFF -DWITH_CN_HEAVY=OFF -DWITH_CN_PICO=OFF -DWITH_CN_FEMTO=OFF -DWITH_ARGON2=OFF -DWITH_KAWPOW=OFF -DWITH_GHOSTRIDER=OFF
make -j $(nproc)

cd ../../../../

mkdir Repos/xmrig/xmrig/build/xmrig-opencompile/
echo "Some Text" > xmrig-opencompile/test && rm -rf xmrig-opencompile

cp Repos/xmrig/xmrig/build/xmrig Repos/xmrig/xmrig/build/xmrig-opencompile/xmrig
tar -czvf Repos/xmrig/xmrig/build/xmrig.tar.gz Repos/xmrig/xmrig/build/xmrig-opencompile

mkdir -p TarRepo/tmp/

cp Repos/xmrig/xmrig/build/xmrig.tar.gz TarRepo/tmp/xmrig.tar.gz

