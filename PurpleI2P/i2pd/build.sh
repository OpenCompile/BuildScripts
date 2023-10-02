#!/bin/bash

set -xe

cd Repos/PurpleI2P/i2pd/build

cmake -DCMAKE_BUILD_TYPE=Release .
make -j $(nproc)