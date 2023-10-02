#!/bin/bash

#
# Creating Basic Structure
#
mkdir -p BuildScripts/PurpleI2P/i2pd/pkg/DEBIAN
mkdir -p BuildScripts/PurpleI2P/i2pd/pkg/usr/bin

cp Repos/PurpleI2P/i2pd/build/i2pd BuildScripts/PurpleI2P/i2pd/pkg/usr/bin/.

export PKGARCH=$(dpkg --print-architecture)

#
# Creating Control file
#

touch BuildScripts/PurpleI2P/i2pd/pkg/DEBIAN/control

cat <<EOT > BuildScripts/PurpleI2P/i2pd/pkg/DEBIAN/control
Package: i2pd
Version: $1
Architecture: $PKGARCH
Essential: no
Priority: optional
Pre-Depends: init-system-helpers (>= 1.54~), adduser
Depends: libboost-filesystem1.74.0 (>= 1.74.0), libboost-program-options1.74.0 (>= 1.74.0), libc6 (>= 2.34), libgcc-s1 (>= 3.0), libminiupnpc17 (>= 1.9.20140610), libssl3 (>= 3.0.0), libstdc++6 (>= 12), zlib1g (>= 1:1.1.4)
Section: net
Maintainer: Daniel Hejduk
Description: I2P: End-to-End encrypted and anonymous Internet
EOT

#
# Creating Preinst file
#

touch BuildScripts/PurpleI2P/i2pd/pkg/DEBIAN/preinst

cat <<EOT > BuildScripts/PurpleI2P/i2pd/pkg/DEBIAN/preinst
#!/bin/sh
set -e
# Automatically added by dh_installinit/13.11.4
if [ "$1" = "install" ] && [ -n "$2" ] && [ -e "/etc/init.d/i2pd" ] ; then
        chmod +x "/etc/init.d/i2pd" >/dev/null || true
fi
# End automatically added section
EOT

#
# Creating Postinst file
#

touch BuildScripts/PurpleI2P/i2pd/pkg/DEBIAN/postinst

cat <<EOT > BuildScripts/PurpleI2P/i2pd/pkg/DEBIAN/postinst
#!/bin/sh
set -e

LOGFILE='/var/log/i2pd/i2pd.log'
I2PDHOME='/var/lib/i2pd'
I2PDUSER='i2pd'

case "$1" in
  configure|reconfigure)
    if getent passwd $I2PDUSER > /dev/null 2>&1; then
      groupadd -f $I2PDUSER || true
    else
      adduser --system --quiet --group --home $I2PDHOME $I2PDUSER
    fi

    mkdir -p -m0750 /var/log/i2pd
    chown -f ${I2PDUSER}:adm /var/log/i2pd
    touch $LOGFILE
    chmod 640 $LOGFILE
    chown -f ${I2PDUSER}:adm $LOGFILE
    mkdir -p -m0750 $I2PDHOME
    chown -f -P ${I2PDUSER}:${I2PDUSER} ${I2PDHOME}
  ;;
  abort-upgrade|abort-remove|abort-deconfigure)
    echo "Aborting upgrade"
    exit 0
  ;;
  *)
    echo "postinst called with unknown argument '$1'" >&2
    exit 0
  ;;
esac

# Automatically added by dh_apparmor/3.0.8-2
if [ "$1" = "configure" ]; then
    APP_PROFILE="/etc/apparmor.d/usr.sbin.i2pd"
    if [ -f "$APP_PROFILE" ]; then
        # Add the local/ include
        LOCAL_APP_PROFILE="/etc/apparmor.d/local/usr.sbin.i2pd"

        test -e "$LOCAL_APP_PROFILE" || {
            mkdir -p `dirname "$LOCAL_APP_PROFILE"`
            install --mode 644 /dev/null "$LOCAL_APP_PROFILE"
        }

        # Reload the profile, including any abstraction updates
        if aa-enabled --quiet 2>/dev/null; then
            apparmor_parser -r -T -W "$APP_PROFILE" || true
        fi
    fi
fi
# End automatically added section
# Automatically added by dh_installtmpfiles/13.11.4
if [ "$1" = "configure" ] || [ "$1" = "abort-upgrade" ] || [ "$1" = "abort-deconfigure" ] || [ "$1" = "abort-remove" ] ; then
	if [ -x "$(command -v systemd-tmpfiles)" ]; then
		systemd-tmpfiles ${DPKG_ROOT:+--root="$DPKG_ROOT"} --create i2pd.conf >/dev/null || true
	fi
fi
# End automatically added section
# Automatically added by dh_installinit/13.11.4
if [ "$1" = "configure" ] || [ "$1" = "abort-upgrade" ] || [ "$1" = "abort-deconfigure" ] || [ "$1" = "abort-remove" ] ; then
	if [ -z "${DPKG_ROOT:-}" ] && [ -x "/etc/init.d/i2pd" ]; then
		update-rc.d i2pd defaults >/dev/null
		if [ -n "$2" ]; then
			_dh_action=restart
		else
			_dh_action=start
		fi
		invoke-rc.d --skip-systemd-native i2pd $_dh_action || exit 1
	fi
fi
# End automatically added section
# Automatically added by dh_installsystemd/13.11.4
if [ "$1" = "configure" ] || [ "$1" = "abort-upgrade" ] || [ "$1" = "abort-deconfigure" ] || [ "$1" = "abort-remove" ] ; then
	# The following line should be removed in trixie or trixie+1
	deb-systemd-helper unmask 'i2pd.service' >/dev/null || true

	# was-enabled defaults to true, so new installations run enable.
	if deb-systemd-helper --quiet was-enabled 'i2pd.service'; then
		# Enables the unit on first installation, creates new
		# symlinks on upgrades if the unit file has changed.
		deb-systemd-helper enable 'i2pd.service' >/dev/null || true
	else
		# Update the statefile to add new symlinks (if any), which need to be
		# cleaned up on purge. Also remove old symlinks.
		deb-systemd-helper update-state 'i2pd.service' >/dev/null || true
	fi
fi
# End automatically added section
# Automatically added by dh_installsystemd/13.11.4
if [ "$1" = "configure" ] || [ "$1" = "abort-upgrade" ] || [ "$1" = "abort-deconfigure" ] || [ "$1" = "abort-remove" ] ; then
	if [ -d /run/systemd/system ]; then
		systemctl --system daemon-reload >/dev/null || true
		if [ -n "$2" ]; then
			_dh_action=restart
		else
			_dh_action=start
		fi
		deb-systemd-invoke $_dh_action 'i2pd.service' >/dev/null || true
	fi
fi
# End automatically added section


exit 0
EOT

#
# Creating Prerm file
#

touch BuildScripts/PurpleI2P/i2pd/pkg/DEBIAN/prerm

cat <<EOT > BuildScripts/PurpleI2P/i2pd/pkg/DEBIAN/prerm
#!/bin/sh
set -e
# Automatically added by dh_installsystemd/13.11.4
if [ -z "${DPKG_ROOT:-}" ] && [ "$1" = remove ] && [ -d /run/systemd/system ] ; then
	deb-systemd-invoke stop 'i2pd.service' >/dev/null || true
fi
# End automatically added section
# Automatically added by dh_installinit/13.11.4
if [ -z "${DPKG_ROOT:-}" ] && [ "$1" = remove ] && [ -x "/etc/init.d/i2pd" ] ; then
	invoke-rc.d --skip-systemd-native i2pd stop || exit 1
fi
# End automatically added section
EOT

#
# Creating Postrm file
#

touch BuildScripts/PurpleI2P/i2pd/pkg/DEBIAN/postrm

cat <<EOT > BuildScripts/PurpleI2P/i2pd/pkg/DEBIAN/postrm
#!/bin/sh
set -e

if [ "$1" = "purge" ]; then
	rm -f /etc/default/i2pd
	rm -rf /etc/i2pd
	rm -rf /var/lib/i2pd
	rm -rf /var/log/i2pd
	rm -rf /run/i2pd
fi

# Automatically added by dh_installinit/13.11.4
if [ "$1" = "remove" ] && [ -x "/etc/init.d/i2pd" ] ; then
	chmod -x "/etc/init.d/i2pd" >/dev/null || true
fi
if [ -z "${DPKG_ROOT:-}" ] && [ "$1" = "purge" ] ; then
	update-rc.d i2pd remove >/dev/null
fi
# End automatically added section
# Automatically added by dh_installsystemd/13.11.4
if [ "$1" = remove ] && [ -d /run/systemd/system ] ; then
	systemctl --system daemon-reload >/dev/null || true
fi
# End automatically added section
# Automatically added by dh_installsystemd/13.11.4
if [ "$1" = "purge" ]; then
	if [ -x "/usr/bin/deb-systemd-helper" ]; then
		deb-systemd-helper purge 'i2pd.service' >/dev/null || true
	fi
fi
# End automatically added section
# Automatically added by dh_apparmor/3.0.8-2
if [ "$1" = "purge" ] && ! [ -e "/etc/apparmor.d/usr.sbin.i2pd" ] ; then
    rm -f "/etc/apparmor.d/disable/usr.sbin.i2pd" || true
    rm -f "/etc/apparmor.d/force-complain/usr.sbin.i2pd" || true
    rm -f "/etc/apparmor.d/local/usr.sbin.i2pd" || true
    rm -f /var/cache/apparmor/*/"usr.sbin.i2pd" || true
    rmdir /etc/apparmor.d/disable 2>/dev/null || true
    rmdir /etc/apparmor.d/local   2>/dev/null || true
    rmdir /etc/apparmor.d         2>/dev/null || true
fi
# End automatically added section


exit 0
EOT

chmod -R 0775 BuildScripts/PurpleI2P/i2pd/pkg/DEBIAN

dpkg-deb --build BuildScripts/PurpleI2P/i2pd/pkg/ BuildScripts/PurpleI2P/i2pd/i2pd.deb