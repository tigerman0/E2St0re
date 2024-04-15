#!/bin/sh
if [ -d /usr/lib/enigma2/python/Plugins/Extensions/E2m3u2bouquet ]; then
echo "> removing package please wait..."
sleep 3s 
rm -r /usr/lib/enigma2/python/Plugins/Extensions/E2m3u2bouquet > /dev/null 2>&1

status='/var/lib/opkg/status'
package='enigma2-plugin-extensions-e2m3u2bouquet'
if grep -q $package $status; then
opkg remove $package
fi

cat <<_EOS-1
********************************************
Uninstall Engima2 IPTV E2m3u2bouquet plugin
********************************************
_EOS-1
[ "$1" != "upgrade" ] || exit 0

sed -i '/e2m3u2b_/d' /etc/enigma2/bouquets.tv
find /etc/enigma2/ -type f -name "*e2m3u2b_*" -delete
echo "Done"

mpoint=""
backup="/var/tmp"
l="sda mmcblk0 mmcblk1"
ll="hdd usb mmc"
for var in $l; do
    if [ -f "/sys/block/$var/queue/rotational" ]; then
        for var1 in $ll; do
            if mount | grep /media/$var1 > /dev/null; then
                mpoint="/media/$var1"
                break 2
            fi
        done
    fi
done

[ ! -z "$mpoint" ] && backup="$mpoint/tmp" || mpoint="/etc/enigma2"
[ ! -d "$backup" ] && mkdir -p $backup > /dev/null 2>&1
mv -f $mpoint/E2m3u2bouquet $backup > /dev/null 2>&1
 

echo "*******************************************"
echo "*             Removed Finished            *"
echo "*            Uploaded By Eliesat          *"
echo "*******************************************"
sleep 3s

init 4; init 3; exit 0
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
pyVersion=$(python -c"from sys import version_info; print(version_info[0])")

#config
plugin=e2m3u2bouquet
version=1.5.1
package=/var/volatile/tmp/$plugin-$version.tar.gz
url=https://gitlab.com/eliesat/extensions/-/raw/main/e2m3u2bouquet/e2m3u2bouquet-1.5.1.tar.gz

#download & install
echo "> Downloading $plugin-$version package  please wait ..."
sleep 3s

wget -O $package --no-check-certificate $url
tar -xzf $package -C /
extract=$?
rm -rf $package >/dev/null 2>&1

PluginName="E2m3u2bouquet"
pyver=$(python -V 2>&1 | cut -d\  -f2 | awk -F "." '{print $1$2}')
path="/usr/lib/enigma2/python"
destination="$path/Plugins/Extensions/$PluginName"
link="$path/Components/Renderer/_RunningText.py"

cp -a $destination/$pyver/. $destination/ > /dev/null 2>&1
if [ ! -L $link ]; then
    ln -s $destination/_RunningText.py $link > /dev/null 2>&1
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
exit
