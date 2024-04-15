#!/bin/sh

if [ -d /usr/lib/enigma2/python/Plugins/Extensions/CrondManager ]; then
echo "> removing package please wait..."
sleep 3s 
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/CrondManager > /dev/null 2>&1

status='/var/lib/opkg/status'
package='enigma2-plugin-extensions-crondmanager'

if grep -q $package $status; then
opkg remove $package > /dev/null 2>&1
fi

if [ ! -f /usr/script/crond_script.sh ]; then
   /etc/rc3.d/S99cron stop
else
   /usr/script/crond_script.sh stop
fi
rm /etc/rc3.d/S99cron > /dev/null 2>&1
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
plugin=crondmanager
version=1.3
url=https://gitlab.com/eliesat/extensions/-/raw/main/crondmanager/crondmanager-1.3.tar.gz
package=/var/volatile/tmp/$plugin-$version.tar.gz

#download & install
echo "> Downloading $plugin-$version package  please wait ..."
sleep 3s

wget -O $package --no-check-certificate $url
tar -xzf $package -C /
extract=$?
rm -rf $package >/dev/null 2>&1

rm -r /etc/cron/Cronmanager  > /dev/null 2>&1
rm /etc/cron/readme.txt  > /dev/null 2>&1
cp /etc/cron/busybox-cron /etc/init.d > /dev/null 2>&1
if [ ! -f /usr/script/crond_script.sh ]; then
   ln -sfn /etc/init.d/busybox-cron /etc/rc3.d/S99cron
fi

if [ `grep /var/spool/cron /etc/init.d/bootup | wc -l` -eq 0 ]; then
   echo "if [ ! -e /var/spool/cron ]; then"  >> /etc/init.d/bootup
   echo "   mkdir -p /var/spool"  >> /etc/init.d/bootup
   echo "   ln -sfn /etc/cron /var/spool/cron"  >> /etc/init.d/bootup
   echo "fi"  >> /etc/init.d/bootup
fi
if [ ! -e /var/spool/cron ]; then
   mkdir -p /var/spool  
   ln -sfn /etc/cron /var/spool/cron
fi

if [ ! -f /usr/script/crond_script.sh ]; then
   /etc/rc3.d/S99cron restart
else
   /usr/script/crond_script.sh restart
fi


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
