#!/bin/bash

mkdir -p BuildScripts/PurpleI2P/i2pd/pkg/DEBIAN
mkdir -p BuildScripts/PurpleI2P/i2pd/pkg/usr/bin

cp Repos/PurpleI2P/i2pd/i2pd BuildScripts/PurpleI2P/i2pd/pkg/usr/bin/.

export PKGARCH=$(dpkg --print-architecture)

touch BuildScripts$PKGNAME/pkg/DEBIAN/contol

cat <<EOT >> BuildScripts/$PKGNAME/pkg/DEBIAN/contol
Package: i2pd
Version: $PKGVER
Architecture: $PKGARCH
Essential: no
Priority: optional
Depends: libssl-dev;libboost-all-dev
Maintainer Daniel Hejduk
Description: I2P: End-to-End encrypted and anonymous Internet
EOT

dpkg-deb --build BuildScripts/$PKGNAME/pkg/