#!/bin/bash

set -xe

cd Repos/PurpleI2P/i2pd

make -j $(nproc)
