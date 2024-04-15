#!/bin/sh

if [ -d /usr/lib/enigma2/python/Plugins/Extensions/GioppyGio ]; then
echo "> removing package please wait..."
sleep 3s 
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/GioppyGio > /dev/null 2>&1

status='/var/lib/opkg/status'
package='enigma2-plugin-extensions-gioppygio'

if grep -q $package $status; then
opkg remove $package
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
plugin=gioppygio
version=12.1
url=https://gitlab.com/eliesat/extensions/-/raw/main/gioppygio/gioppygio-12.1.tar.gz
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
sleep 5
if [ -f /tmp/Date ];then
  cp "/tmp/Date" /usr/lib/enigma2/python/Plugins/Extensions/GioppyGio/Moduli/Settings/ > /dev/null 2>&1
fi
if [ -f /tmp/Select ];then
  cp "/tmp/Select" /usr/lib/enigma2/python/Plugins/Extensions/GioppyGio/Moduli/Settings/ > /dev/null 2>&1
fi
if [ -f /tmp/send_settings ];then
  cp "/tmp/send_settings" /etc/enigma2/ > /dev/null 2>&1
fi
if [ -f /tmp/gioppygio_picons ];then
  cp "/tmp/gioppygio_picons" /etc/enigma2/ > /dev/null 2>&1
fi
rm -rf /tmp/gioppygio.ipk > /dev/null 2>&1
echo "config.plugins.epgimport.enabled=true" >> /etc/enigma2/settings;
echo "config.plugins.epgimport.longDescDays=5" >> /etc/enigma2/settings;
echo "config.plugins.epgimport.wakeup=6:0" >> /etc/enigma2/settings;

echo "> $plugin-$version package installed successfully"
echo "> Uploaded By ElieSat"
sleep 3s

else

echo "> $plugin-$version package installation failed"
sleep 3s
fi

fi
exit 0
