#!/bin/bash

set -xe

cd Repos/PurpleI2P/i2pd/build

cmake -DWITH_STATIC=ON .
make -j $(nproc)