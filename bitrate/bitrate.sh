#!/bin/sh

if [ -d /usr/lib/enigma2/python/Plugins/Extensions/Bitrate ]; then
echo "> removing package please wait..."
sleep 3s 
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/Bitrate > /dev/null 2>&1

status='/var/lib/opkg/status'
package='enigma2-plugin-extensions-bitrate'

if grep -q $package $status; then
opkg remove $package > /dev/null 2>&1
fi

echo "*******************************************"
echo "*             Removed Finished            *"
echo "*            Uploaded By Eliesat          *"
echo "*******************************************"
sleep 3s

else

#remove unnecessary files and folders
if [  -d "/CONTROL" ]; then
rm -r  /CONTROL >/dev/null 2>&1
fi
rm -rf /control >/dev/null 2>&1
rm -rf /postinst >/dev/null 2>&1
rm -rf /preinst >/dev/null 2>&1
rm -rf /prerm >/dev/null 2>&1
rm -rf /postrm >/dev/null 2>&1
rm -rf /tmp/*.ipk >/dev/null 2>&1
rm -rf /tmp/*.tar.gz >/dev/null 2>&1

#check install deps
# Check python
status='/var/lib/opkg/status'


package='libc6'
if grep -q $package $status; then
rm -rf /run/opkg.lock
opkg install $package > /dev/null 2>&1
fi
package='libgcc1'
if grep -q $package $status; then
rm -rf /run/opkg.lock
opkg install $package > /dev/null 2>&1
fi
package='libstdc++6'
rm -rf /run/opkg.lock
if grep -q $package $status; then
opkg install $package > /dev/null 2>&1
fi


#config
plugin=bitrate
version=2.0
url=https://gitlab.com/eliesat/extensions/-/raw/main/bitrate/bitrate-2.0.tar.gz
package=/var/volatile/tmp/$plugin-$version.tar.gz


#download & install
echo "> Downloading $plugin-$version package  please wait ..."
sleep 3s

wget -O $package --no-check-certificate $url
tar -xzf $package -C /
extract=$?
rm -rf $package >/dev/null 2>&1

echo ''
if [ $extract -eq 0 ]; then
echo "> $plugin-$version package installed successfully"
echo "> Uploaded By ElieSat"
sleep 3s

else

echo "> $plugin-$version package installation failed"
sleep 3s
fi

fi
exit 0
