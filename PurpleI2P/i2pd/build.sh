#!/bin/bash

cd Repos/PurpleI2P/i2pd/build

cmake .

make

mkdir i2pd_2.49.0

cp i2pd i2pd_2.49.0

tar -czf i2pd_2.49.0.tar.gz i2pd_2.49.0

rm -rf i2pd_2.49.0

cd ../../../../
