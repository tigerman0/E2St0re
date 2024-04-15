#!/bin/sh

if [ -d /usr/lib/enigma2/python/Plugins/Extensions/ArabicSavior ]; then
echo "> removing package please wait..."
sleep 3s 
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/ArabicSavior >/dev/null 2>&1
opkg remove enigma2-plugin-extensions-arabicsavior
opkg remove enigma2-plugin-extensions-arabic-savior

echo "*******************************************"
echo "*             Removed Finished            *"
echo "*            Uploaded By Eliesat          *"
echo "*******************************************"
sleep 3s

else

#config
plugin=arabicsavior
version=2.1
url=https://gitlab.com/eliesat/extensions/-/raw/main/arabic-savior/arabicsavior-2.1.tar.gz
package=/var/volatile/tmp/$plugin-$version.tar.gz

echo "> Downloading $plugin-$version package  please wait ..."
sleep 3s

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
