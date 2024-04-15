#!/bin/bash

# Determine package manager
package="enigma2-plugin-extensions-e2iplayer"
if command -v dpkg &> /dev/null; then
package_manager="apt"
status_file="/var/lib/dpkg/status"
uninstall_command="apt-get purge --auto-remove -y"
else
package_manager="opkg"
status_file="/var/lib/opkg/status"
uninstall_command="opkg remove --force-depends"
fi

check_and_remove_package() {
if [ -d /usr/lib/enigma2/python/Plugins/Extensions/IPTVPlayer ]; then
echo "> removing package old version please wait..."
sleep 3 
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/IPTVPlayer > /dev/null 2>&1
rm -rf /etc/tsiplayer_xtream.conf > /dev/null 2>&1
rm -rf /iptvplayer_rootfs > /dev/null 2>&1
if grep -q "$package" "$status_file"; then
echo "> Removing existing $package package, please wait..."
$uninstall_command $package
fi
echo "*******************************************"
echo "*             Removed Finished            *"
echo "*            Uploaded By Eliesat          *"
echo "*******************************************"
sleep 3
sed -i "/config.plugins.iptvplayer.*/d" /etc/enigma2/settings

# Restart Enigma2 service or kill enigma2 based on the system
if [ -f /etc/apt/apt.conf ]; then
    sleep 2
    systemctl restart enigma2
else
    sleep 2
    killall -9 enigma2
fi
else
echo " " 
fi  }
check_and_remove_package

# Configuration
TMPDIR='/tmp'
PLUGINPATH='/usr/lib/enigma2/python/Plugins/Extensions/IPTVPlayer'
SETTINGS='/etc/enigma2/settings'
URL='https://gitlab.com/eliesat/extensions/-/raw/main/e2iplayer'
targz_file='e2iplayer-main.tar.gz'
MY_PATH='/media/mmc/iptvplayer.sh'
pyVersion=$(python -c"from sys import version_info; print(version_info[0])")
VERSION=$(wget $URL/lastversion.php -qO- | awk 'NR==1')

#check device architecture
case $(uname -m) in
armv7l*) plarform="armv7" ;;
mips*) plarform="mipsel" ;;
aarch64*) plarform="ARCH64" ;;
sh4*) plarform="sh4" ;;
esac

#check and install dependencies
echo "> checking dependencies please wait ..."
sleep 3
# Check python
pyVersion=$(python -c"from sys import version_info; print(version_info[0])")

deps=( "duktape" "gstplayer" "exteplayer3" "enigma2-plugin-extensions-e2iplayer-deps"  )

if [ "$pyVersion" = 3 ]; then
  deps+=( "python3-e2icjson" "python3-pycurl" "python3-sqlite3" )
else
deps+=( "python-e2icjson" "python-pycurl" "python-sqlite3" "cmdwrap" )
fi

left=">>>>"
right="<<<<"
LINE1="---------------------------------------------------------"
LINE2="-------------------------------------------------------------------------------------"

if [ -f /etc/opkg/opkg.conf ]; then
  STATUS='/var/lib/opkg/status'
  OSTYPE='Opensource'
  OPKG='opkg update'
  OPKGINSTAL='opkg install'
elif [ -f /etc/apt/apt.conf ]; then
  STATUS='/var/lib/dpkg/status'
  OSTYPE='DreamOS'
  OPKG='apt-get update'
  OPKGINSTAL='apt-get install -y'
fi

install() {
  if ! grep -qs "Package: $1" "$STATUS"; then
    $OPKG >/dev/null 2>&1
    rm -rf /run/opkg.lock
    echo -e "> Need to install ${left} $1 ${right} please wait..."
    echo "$LINE2"
    sleep 0.8
    echo
    if [ "$OSTYPE" = "Opensource" ]; then
      $OPKGINSTAL "$1"
      sleep 1
      clear
    elif [ "$OSTYPE" = "DreamOS" ]; then
      $OPKGINSTAL "$1" -y
      sleep 1
      clear
    fi
  fi
}

for i in "${deps[@]}"; do
  install "$i"
done

clear

#remove unnecessary files and folders
if [ -e ${TMPDIR}/$targz_file ]; then
  rm -f ${TMPDIR}/$targz_file
fi

if [ -e ${TMPDIR}/e2iplayer-main ]; then
  rm -fr ${TMPDIR}/e2iplayer-main
fi

cleanup() {
    [ -d "/CONTROL" ] && rm -rf /CONTROL >/dev/null 2>&1
    rm -rf /control /postinst /preinst /prerm /postrm /tmp/*.ipk /tmp/*.tar.gz >/dev/null 2>&1
    echo "> Cleanup completed."
}
cleanup

echo -e "> Downloading e2iplayer-$VERSION mod mohamed_os Please Wait ..."
wget --show-progress $URL/$targz_file -qP $TMPDIR
if [ $? -gt 0 ]; then
  echo -e "> error downloading archive, end"
  exit 1
else
  echo -e ""
fi

tar -xzf $TMPDIR/$targz_file -C $TMPDIR
if [ $? -gt 0 ]; then
  echo -e "> error extracting archive, end"
else
  echo -e ""
  rm -f ${TMPDIR}/$targz_file
fi

cp -rf $TMPDIR/e2iplayer-main/tsiplayer_xtream.conf /etc
cp -rf $TMPDIR/e2iplayer-main/IPTVPlayer /usr/lib/enigma2/python/Plugins/Extensions/

if [ $? -gt 0 ]; then
  echo -e "> error installing E2Iplayer, end" 
  exit 1
else
  echo -e "> E2iplayer-$VERSION mod_mohamed installed successfully "
  rm -fr ${TMPDIR}/e2iplayer-main
fi
sleep 0.8
echo -e "> Setup the plugin..."

sleep 3
#########################
if [ -d $PLUGINPATH ]; then

    echo -e "> Your Device IS $(uname -m) processor ..."
    echo "> your Device will restart now please wait..."
    init 4
    sleep 5
    sed -e s/config.plugins.iptvplayer.*//g -i ${SETTINGS}
    sleep 2
    {
      echo "config.plugins.iptvplayer.AktualizacjaWmenu=true"
      echo "config.plugins.iptvplayer.SciezkaCache=/etc/IPTVCache/"
      echo "config.plugins.iptvplayer.alternative${plarform^^}MoviePlayer=extgstplayer"
      echo "config.plugins.iptvplayer.alternative${plarform^^}MoviePlayer0=extgstplayer"
      echo "config.plugins.iptvplayer.buforowanie_m3u8=false"
      echo "config.plugins.iptvplayer.cmdwrappath=/usr/bin/cmdwrap"
      echo "config.plugins.iptvplayer.debugprint=/tmp/iptv.dbg"
      echo "config.plugins.iptvplayer.default${plarform^^}MoviePlayer=exteplayer"
      echo "config.plugins.iptvplayer.default${plarform^^}MoviePlayer0=exteplayer"
      echo "config.plugins.iptvplayer.dukpath=/usr/bin/duk"
      echo "config.plugins.iptvplayer.extplayer_infobanner_clockformat=24"
      echo "config.plugins.iptvplayer.extplayer_skin=line"
      echo "config.plugins.iptvplayer.f4mdumppath=/usr/bin/f4mdump"
      echo "config.plugins.iptvplayer.gstplayerpath=/usr/bin/gstplayer"
      echo "config.plugins.iptvplayer.hlsdlpath=/usr/bin/hlsdl"
      echo "config.plugins.iptvplayer.opensuborg_login=MOHAMED_OS"
      echo "config.plugins.iptvplayer.opensuborg_password=&ghost@mcee2017&"
      echo "config.plugins.iptvplayer.osk_type=system"
      echo "config.plugins.iptvplayer.plarform=${plarform}"
      echo "config.plugins.iptvplayer.remember_last_position=true"
      echo "config.plugins.iptvplayer.rtmpdumppath=/usr/bin/rtmpdump"
      echo "config.plugins.iptvplayer.uchardetpath=/usr/bin/uchardet"
      echo "config.plugins.iptvplayer.updateLastCheckedVersion=${VERSION}"
      echo "config.plugins.iptvplayer.wgetpath=wget"
    } >>${SETTINGS}
  
fi

if [ "$OSTYPE" = "DreamOS" ]; then
  sleep 2
  systemctl restart enigma2
else
  init 4
  sleep 2
  init 3
fi

