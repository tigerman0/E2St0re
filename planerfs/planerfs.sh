#!/bin/sh

if [ -d /usr/lib/enigma2/python/Plugins/Extensions/PlanerFS ]; then
echo "> removing package please wait..."
sleep 3s 
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/PlanerFS > /dev/null 2>&1

status='/var/lib/opkg/status'
package='enigma2-plugin-extensions-planerfs'

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

echo "install planerFS"
dst=/usr/lib/enigma2/python/Plugins/Extensions/PlanerFS/
if [ -d /tmp ]; then
    tmp_verz=/tmp/planer
else
    tmp_verz=/var/volatile/tmp/planer
fi
if [ -f /usr/bin/python ]; then
PYTHON=/usr/bin/python
elif [ -f /usr/local/bin/python ]; then
PYTHON=/usr/local/bin/python
fi
# Make sure python is 2.6 or later
PYTHON_new=`$PYTHON -c 'import sys
print (sys.version_info >= (2, 7) and "1" or "0")'`

if [ "$PYTHON_new" = '0' ]; then
	Python_version="OE 1.6"
    src=$tmp_verz/oe16/
else
    Python_version="OE 2.0"
    src=$tmp_verz/oe20/
fi

echo "planerFS-install: copy pyo-files for "$Python_version
for i in $(ls $src); 
do
   cp -f ${src}$i $dst

done

if [ ! -d /etc/ConfFS ]; then
    echo "planerFS-install: make dir ConfFS"
    mkdir -p /etc/ConfFS
fi
if [ ! -f /etc/ConfFS/PlanerFS.ics ]; then	
     echo "planerFS-install: copy sample calendar-file"
	 cp -f $tmp_verz/PlanerFS.ics /etc/ConfFS/
fi
if [ ! -f /etc/ConfFS/PlanerFS_online.txt ]; then	
     echo "planerFS-install: copy PlanerFS-online-file"
	 cp -f $tmp_verz/PlanerFS_online.txt /etc/ConfFS/
fi
if [ -f /etc/ConfFS/PlanerFS.conf ]; then	
#     echo "planerFS-install: copy PlanerFS-config-file"
#	 cp -f $tmp_verz/PlanerFS.conf /etc/ConfFS/
#else 
     if ( ! grep -q 'settings' /etc/ConfFS/PlanerFS.conf) 
         then 
	        echo "[settings]" >> $tmp_verz/PlanerFS2.conf
                while read line
                  do
                     echo $line >> $tmp_verz/PlanerFS2.conf
                done < /etc/ConfFS/PlanerFS.conf
	        cp -f $tmp_verz/PlanerFS2.conf /etc/ConfFS/PlanerFS.conf

     fi
fi


#echo "planerFS-install: copy list-file to "$(dirname $0) #/opkg/info...
#cp -f $tmp_verz/enigma2-plugin-extensions-planerfs.list $(dirname $0)
echo "planerFS-install: del install-files in tmp"
rm -r $tmp_verz/ >/dev/null 2>&1

#config
plugin=planerfs
version=9.77
url=https://gitlab.com/eliesat/extensions/-/raw/main/planerfs/planerfs-9.77.tar.gz
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
