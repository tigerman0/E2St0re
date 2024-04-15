#!/bin/sh

if [ -d /usr/lib/enigma2/python/Plugins/Extensions/VisualWeather ]; then
echo "> removing package please wait..."
sleep 3s 
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/VisualWeather > /dev/null 2>&1

status='/var/lib/opkg/status'
package='enigma2-plugin-extensions-visualweather'

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

#config
plugin=visualweather
version=1.08
url=https://gitlab.com/eliesat/extensions/-/raw/main/visualweather/visualweather-1.08.tar.gz
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
