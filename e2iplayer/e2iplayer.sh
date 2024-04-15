#!/bin/sh

#config 
TMPDIR='/tmp'
PLUGINPATH='/usr/lib/enigma2/python/Plugins/Extensions/IPTVPlayer'
SETTINGS='/etc/enigma2/settings'
URL='https://gitlab.com/eliesat/extensions/-/raw/main/e2iplayer'
PYTHON_VERSION=$(python -c "import platform; print(platform.python_version())")
VERSION=08.02.2024

# remove old version #
if [ -d /usr/lib/enigma2/python/Plugins/Extensions/IPTVPlayer ]; then
echo "> removing package please wait..."
sleep 3s 

rm -rf /usr/lib/enigma2/python/Plugins/Extensions/IPTVPlayer
rm -rf /etc/enigma2/iptvplaye*.json
rm -rf /etc/tsiplayer_xtream.conf
rm -rf /iptvplayer_rootfs
rm -rf /usr/lib/enigma2/python/Components/Input.py
rm -rf /usr/bin/lsdir

echo "*******************************************"
echo "*             Removed Finished            *"
echo "*            Uploaded By Eliesat          *"
echo "*******************************************"
sleep 3s


else

#remove unnecessary files and folders
if [  -d "/CONTROL" ]; then
rm -r  /CONTROL
fi
rm -rf /control
rm -rf /postinst
rm -rf /preinst
rm -rf /prerm
rm -rf /postrm
rm -rf /tmp/*.ipk
rm -rf /tmp/*.tar.gz

#check install deps
# Check python
pyVersion=$(python -c"from sys import version_info; print(version_info[0])")

deps=("enigma2-plugin-systemplugins-serviceapp" "gstplayer" "duktape" "wget" "ffmpeg")

if [ "$pyVersion" = 3 ]; then
  deps+=( "python3-sqlite3" )

else
  
deps+=( "python-sqlite3" "hlsdl" )
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

#check python version
case $PYTHON_VERSION in 
2.7.18)
URL2='iptvplayer-2.7.18.tar.gz';;
3.8.5)
URL2='ipvtplayer-3.8.5.tar.gz';;
3.9.7|3.9.9)
URL2='iptvplayer-3.9.x.tar.gz';;
3.10.4)
URL2='iptvplayer-3.10.4.tar.gz';;
3.11.0|3.11.1|3.11.2|3.11.3|3.11.4|3.11.5|3.11.6|3.12.1)
URL2='iptvplayer-3.11.x.tar.gz';;
esac
rm -rf ${TMPDIR}/"${URL2:?}"

#check platform
case $(uname -m) in
armv7l*) plarform="armv7" ;;
mips*) plarform="mipsel" ;;
aarch64*) plarform="ARCH64" ;;
sh4*) plarform="sh4" ;;
esac

install() {
if grep -qs "Package: $1" $STATUS; then
echo
else
$OPKG >/dev/null 2>&1
echo "   >>>>   Need to install $1   <<<<"
echo
if [ $OSTYPE = "Opensource" ]; then
$OPKGINSTAL "$1"
sleep 1
clear
elif [ $OSTYPE = "DreamOS" ]; then
$OPKGINSTAL "$1" -y
sleep 1
clear
fi
fi
}

#downloading installing
echo "> Downloading e2iPlayer_tsiplayer-$VERSION please wait ..."
sleep 3s
echo
wget --show-progress $URL/$URL2 -qP $TMPDIR
tar -xzf $TMPDIR/$URL2 -C /
wget -q "--no-check-certificate" https://gitlab.com/eliesat/free/-/raw/main/tsiplayer-hosts.sh -O - | /bin/sh
if [ -d $PLUGINPATH ]; then
echo "> e2iplayer tsiplayer installed successfully
you device will restart now please wait..."
sleep 3s
init 4
sleep 1
sed -i '/iptvplayer/d' /etc/enigma2/settings
sed -e s/config.plugins.iptvplayer.*//g -i ${SETTINGS}
sleep 1
{
echo "config.plugins.iptvplayer.AktualizacjaWmenu=false"
echo "config.plugins.iptvplayer.SciezkaCache=/etc/IPTVCache/"
echo "config.plugins.iptvplayer.alternative${PLATFORM^^}MoviePlayer=extgstplayer"
echo "config.plugins.iptvplayer.alternative${PLATFORM^^}MoviePlayer0=extgstplayer"
echo "config.plugins.iptvplayer.buforowanie_m3u8=false"
echo "config.plugins.iptvplayer.default${PLATFORM^^}MoviePlayer=exteplayer"
echo "config.plugins.iptvplayer.default${PLATFORM^^}MoviePlayer0=exteplayer"
echo "config.plugins.iptvplayer.remember_last_position=true"
echo "config.plugins.iptvplayer.extplayer_skin=line"
echo "config.plugins.iptvplayer.extplayer_infobanner_clockformat=24"
echo "config.plugins.iptvplayer.plarform=${PLATFORM}"
echo "config.plugins.iptvplayer.preferredupdateserver="
echo "config.plugins.iptvplayer.dukpath=/usr/bin/duk"
echo "config.plugins.iptvplayer.wgetpath=wget"
} >>${SETTINGS}
fi

#remove from tmp
rm -rf ${TMPDIR}/"${URL2:?}"

if [ $OSTYPE = "DreamOS" ]; then
sleep 2
systemctl restart enigma2
else
init 3
fi

fi
exit 0
