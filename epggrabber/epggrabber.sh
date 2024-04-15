#!/bin/sh

# remove old version #
if [ -d /usr/lib/enigma2/python/Plugins/Extensions/EPGGrabber ]; then
echo "> removing package please wait..."
sleep 3s 

rm -rf /usr/lib/enigma2/python/Plugins/Extensions/EPGGrabber
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/Epg_Plugin
opkg remove enigma2-plugin-extensions-epggrabber

echo "*******************************************"
echo "*             Removed Finished            *"
echo "*            Uploaded By Eliesat          *"
echo "*******************************************"
sleep 3s

else

package=epggrabber
version=22.9

#check install deps
# Check python
pyVersion=$(python -c"from sys import version_info; print(version_info[0])")

deps=( "enigma2-plugin-extensions-epgimport" )

if [ "$pyVersion" = 3 ]; then
  deps+=( "python3-requests" )

else
  
deps+=( "python-requests" )
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

##download package
echo "> Downloading $package-$version Package  Please Wait ..."
sleep 3s

wget -O /var/volatile/tmp/Epg-plugin-master.tar.gz --no-check-certificate "https://gitlab.com/eliesat/extensions/-/raw/main/epggrabber/Epg-plugin-master.tar.gz"

wget -O /var/volatile/tmp/Epg-ch-id.tar.gz --no-check-certificate "https://gitlab.com/eliesat/extensions/-/raw/main/epggrabber/Epg-ch-id.tar.gz"

echo "> Installing $package-$version Package  Please Wait ..."
sleep 3s

tar -xf /var/volatile/tmp/Epg-plugin-master.tar.gz -C /
tar -xf /var/volatile/tmp/Epg-ch-id.tar.gz -C /
mv /Epg-plugin-master/src/EPGGrabber /usr/lib/enigma2/python/Plugins/Extensions/
extract=$?

rm -rf /var/volatile/tmp/Epg-plugin-master.tar.gz > /dev/null 2>&1
rm -rf /var/volatile/tmp/Epg-ch-id.tar.gz > /dev/null 2>&1
rm -rf /Epg-plugin-master > /dev/null 2>&1

echo ''
if [ $extract -eq 0 ]; then 
echo "> $package-$version Package Installed Successfully"
sleep 3s
else
echo "> $package-$version Package Installation Failed"
sleep 3s
fi

fi
exit 0
