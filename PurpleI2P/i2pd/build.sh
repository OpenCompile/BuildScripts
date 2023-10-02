#!/bin/bash

set -xe

cd Repos/PurpleI2P/i2pd/build

cmake --build . -DWITH_STATIC=ON
make -j $(nproc)