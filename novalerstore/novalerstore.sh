#!/bin/sh

if [ -d /usr/lib/enigma2/python/Plugins/Extensions/NovalerStore ]; then
echo "> removing package please wait..."
sleep 3s 
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/NovalerStore > /dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Components/Renderer/NovalerStore* > /dev/null 2>&1
rm -rf /etc/enigma2/NovalerStore > /dev/null 2>&1

status='/var/lib/opkg/status'
package='enigma2-plugin-extensions-novalerstore'

if grep -q $package $status; then
opkg remove $package
fi


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

#config
pack=novalerstore
version=2.0-r0
url="https://gitlab.com/eliesat/extensions/-/raw/main/novalerstore/"
ipk="$pack-$version.ipk"
install="opkg install --force-reinstall"

# Download and install plugin
echo "> Downloading "$pack"-"$version" please wait..."
sleep 3s

cd /tmp
set -e
wget --show-progress "$url/$ipk"
$install $ipk
set +e
cd ..
wait
rm -f /tmp/$ipk

if [ $? -eq 0 ]; then
echo "> "$pack"-"$version" installed successfully"
sleep 3s
else
echo " installation failed"
fi

fi
exit 0