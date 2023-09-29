#!/bin/bash

mkdir -p BuildScripts/PurpleI2P/i2pd/pkg/DEBIAN
mkdir -p BuildScripts/PurpleI2P/i2pd/pkg/usr/bin

cp Repos/PurpleI2P/i2pd/i2pd BuildScripts/PurpleI2P/i2pd/pkg/usr/bin/.

export PKGARCH=$(dpkg --print-architecture)

touch BuildScripts/PurpleI2P/i2pd/pkg/DEBIAN/control

cat <<EOT >> BuildScripts/PurpleI2P/i2pd/pkg/DEBIAN/control
Package: i2pd
Version: $1
Architecture: $PKGARCH
Essential: no
Priority: optional
Depends: libssl-dev, libboost-all-dev
Maintainer: Daniel Hejduk
Description: I2P: End-to-End encrypted and anonymous Internet
EOT

chmod -R 0775 BuildScripts/PurpleI2P/i2pd/pkg/DEBIAN

dpkg-deb --build BuildScripts/PurpleI2P/i2pd/pkg/ BuildScripts/PurpleI2P/i2pd/i2pd.deb
