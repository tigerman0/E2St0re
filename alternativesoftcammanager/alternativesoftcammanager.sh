#!/bin/sh

if [ -d /usr/lib/enigma2/python/Plugins/Extensions/AlternativeSoftCamManager ]; then
echo "> removing package please wait..."
sleep 3s 
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/AlternativeSoftCamManager >/dev/null 2>&1
opkg remove enigma2-plugin-extensions-alternativesoftcammanager

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
plugin=alternativesoftcammanager
version=1.0
url=https://gitlab.com/eliesat/extensions/-/raw/main/alternativesoftcammanager/alternativesoftcammanager-1.0.tar.gz
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
echo "> "$plugin"-"$version" Package Installed Successfully"

######### checking Package: libssl & libcrypto ###########
if [ -f /etc/apt/apt.conf ] ; then
    images="OE2.5 IMAGES:"
    lib_files="/var/lib/dpkg/status"
    list_files="/var/lib/dpkg/info"
elif [ -f /etc/opkg/opkg.conf ] ; then
    images="OE2.0 IMAGES:"
    lib_files="/var/lib/opkg/status"
    list_files="/var/lib/opkg/info"
else
    echo "Sorry, your device not have the opkg/dpkg folder :("
fi
usrlibpath="/usr/lib/"
libpath="/lib/"
opkg update > /dev/null 2>&1
############################## libssl ####################
if grep -qs 'Package: libssl3' cat $lib_files ; then
    echo "$images libssl3"
    ln -s libssl.so.3 $usrlibpath/libssl.so.1.1.1 > /dev/null 2>&1
    ln -s libssl.so.3 $usrlibpath/libssl.so.1.0.0 > /dev/null 2>&1
    ln -s libssl.so.3 $usrlibpath/libssl.so.0.9.8 > /dev/null 2>&1
    ln -s libssl.so.3 $usrlibpath/libssl.so.0.9.7 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.3 $libpath/libssl.so.1.0.0 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.3 $libpath/libssl.so.0.9.8 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.3 $libpath/libssl.so.0.9.7 > /dev/null 2>&1
elif grep -qs 'Package: libssl1.1' cat $lib_files ; then
    echo "$images libssl1.1"
    ln -s libssl.so.1.1 $usrlibpath/libssl.so.1.0.0 > /dev/null 2>&1
    ln -s libssl.so.1.1 $usrlibpath/libssl.so.0.9.8 > /dev/null 2>&1
    ln -s libssl.so.1.1 $usrlibpath/libssl.so.0.9.7 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.1.1 $libpath/libssl.so.1.0.0 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.1.1 $libpath/libssl.so.0.9.8 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.1.1 $libpath/libssl.so.0.9.7 > /dev/null 2>&1
elif grep -qs 'Package: libssl1.0.0' cat $lib_files ; then
    echo "$images libssl.1.0.0"
    ln -s libssl.so.1.0.0 $usrlibpath/libssl.so.0.9.8 > /dev/null 2>&1
    ln -s libssl.so.1.0.0 $usrlibpath/libssl.so.0.9.7 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.1.0.0 $libpath/libssl.so.0.9.8 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.1.0.0 $libpath/libssl.so.0.9.7 > /dev/null 2>&1
elif grep -qs 'Package: libssl1.0.2' cat $lib_files ; then
    echo "$images libssl.1.0.2"
    ln -s libssl.so.1.0.2 $usrlibpath/libssl.so.1.0.0 > /dev/null 2>&1
    ln -s libssl.so.1.0.2 $usrlibpath/libssl.so.0.9.8 > /dev/null 2>&1
    ln -s libssl.so.1.0.2 $usrlibpath/libssl.so.0.9.7 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.1.0.2 $libpath/libssl.so.1.0.0 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.1.0.2 $libpath/libssl.so.0.9.8 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.1.0.2 $libpath/libssl.so.0.9.7 > /dev/null 2>&1
elif grep -qs 'Package: libssl0.9.8' cat $lib_files ; then
    echo "$images libssl.0.9.8"
    ln -s libssl.so.0.9.8 $usrlibpath/libssl.so.0.9.7 > /dev/null 2>&1
    ln -s libssl.so.0.9.8 $usrlibpath/libssl.so.1.0.0 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.0.9.8 $libpath/libssl.so.0.9.7 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.0.9.8 $libpath/libssl.so.1.0.0 > /dev/null 2>&1
elif [ -f /usr/lib/libssl.so.3 ] ; then
    echo "$images libssl3"
    ln -s libssl.so.3 $usrlibpath/libssl.so.1.1.1 > /dev/null 2>&1
    ln -s libssl.so.3 $usrlibpath/libssl.so.1.0.0 > /dev/null 2>&1
    ln -s libssl.so.3 $usrlibpath/libssl.so.0.9.8 > /dev/null 2>&1
    ln -s libssl.so.3 $usrlibpath/libssl.so.0.9.7 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.3 $libpath/libssl.so.1.0.0 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.3 $libpath/libssl.so.0.9.8 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.3 $libpath/libssl.so.0.9.7 > /dev/null 2>&1
elif [ -f /usr/lib/libssl.so.1.1 ] ; then
    echo "$images libssl1.1"
    ln -s libssl.so.1.1 $usrlibpath/libssl.so.1.0.0 > /dev/null 2>&1
    ln -s libssl.so.1.1 $usrlibpath/libssl.so.0.9.8 > /dev/null 2>&1
    ln -s libssl.so.1.1 $usrlibpath/libssl.so.0.9.7 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.1.1 $libpath/libssl.so.1.0.0 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.1.1 $libpath/libssl.so.0.9.8 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.1.1 $libpath/libssl.so.0.9.7 > /dev/null 2>&1
elif [ -f /usr/lib/libssl.so.1.0.0 ] ; then
    echo "$images libssl1.0"
    ln -s libssl.so.1.0.0 $usrlibpath/libssl.so.0.9.8 > /dev/null 2>&1
    ln -s libssl.so.1.0.0 $usrlibpath/libssl.so.0.9.7 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.1.0.0 $libpath/libssl.so.0.9.8 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.1.0.0 $libpath/libssl.so.0.9.7 > /dev/null 2>&1
elif [ -f /usr/lib/libssl.so.1.0.2 ] ; then
    echo "$images libssl.1.0.2"
    ln -s libssl.so.1.0.2 $usrlibpath/libssl.so.1.0.0 > /dev/null 2>&1
    ln -s libssl.so.1.0.2 $usrlibpath/libssl.so.0.9.8 > /dev/null 2>&1
    ln -s libssl.so.1.0.2 $usrlibpath/libssl.so.0.9.7 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.1.0.2 $libpath/libssl.so.1.0.0 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.1.0.2 $libpath/libssl.so.0.9.8 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.1.0.2 $libpath/libssl.so.0.9.7 > /dev/null 2>&1
elif [ -f /usr/lib/libssl.so.0.9.8 ] ; then
    echo "$images libssl.0.9.8"
    ln -s libssl.so.0.9.8 $usrlibpath/libssl.so.0.9.7 > /dev/null 2>&1
    ln -s libssl.so.0.9.8 $usrlibpath/libssl.so.1.0.0 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.0.9.8 $libpath/libssl.so.0.9.7 > /dev/null 2>&1
    ln -s $usrlibpath/libssl.so.0.9.8 $libpath/libssl.so.1.0.0 > /dev/null 2>&1
else ## Try to Download libssl from feed
    if [ -n "$(opkg list | grep libssl1.1)" ]; then
        echo "install libssl1.1"
        if [ -f /etc/apt/apt.conf ] ; then
            apt-get install --reinstall libssl1.1 > /dev/null 2>&1
            ln -s libssl.so.1.1 $usrlibpath/libssl.so.1.0.0 > /dev/null 2>&1
            ln -s libssl.so.1.1 $usrlibpath/libssl.so.0.9.8 > /dev/null 2>&1
            ln -s libssl.so.1.1 $usrlibpath/libssl.so.0.9.7 > /dev/null 2>&1
            ln -s $usrlibpath/libssl.so.1.1 $libpath/libssl.so.1.0.0 > /dev/null 2>&1
            ln -s $usrlibpath/libssl.so.1.1 $libpath/libssl.so.0.9.8 > /dev/null 2>&1
            ln -s $usrlibpath/libssl.so.1.1 $libpath/libssl.so.0.9.7 > /dev/null 2>&1
        elif [ -f /etc/opkg/opkg.conf ] ; then
            opkg install --force-overwrite --force-depends libssl1.1 > /dev/null
            ln -s libssl.so.1.1 $usrlibpath/libssl.so.1.0.0 > /dev/null 2>&1
            ln -s libssl.so.1.1 $usrlibpath/libssl.so.0.9.8 > /dev/null 2>&1
            ln -s libssl.so.1.1 $usrlibpath/libssl.so.0.9.7 > /dev/null 2>&1
            ln -s $usrlibpath/libssl.so.1.1 $libpath/libssl.so.1.0.0 > /dev/null 2>&1
            ln -s $usrlibpath/libssl.so.1.1 $libpath/libssl.so.0.9.8 > /dev/null 2>&1
            ln -s $usrlibpath/libssl.so.1.1 $libpath/libssl.so.0.9.7 > /dev/null 2>&1
        fi
    elif [ -n "$(opkg list | grep libssl1.0.2)" ]; then
        echo "install libssl1.0.2"
        if [ -f /etc/apt/apt.conf ] ; then
            apt-get install --reinstall libssl1.0.2 > /dev/null 2>&1
            ln -s libssl.so.1.0.2 $usrlibpath/libssl.so.1.0.0 > /dev/null 2>&1
            ln -s libssl.so.1.0.2 $usrlibpath/libssl.so.0.9.8 > /dev/null 2>&1
            ln -s libssl.so.1.0.2 $usrlibpath/libssl.so.0.9.7 > /dev/null 2>&1
            ln -s $usrlibpath/libssl.so.1.0.2 $libpath/libssl.so.1.0.0 > /dev/null 2>&1
            ln -s $usrlibpath/libssl.so.1.0.2 $libpath/libssl.so.0.9.8 > /dev/null 2>&1
            ln -s $usrlibpath/libssl.so.1.0.2 $libpath/libssl.so.0.9.7 > /dev/null 2>&1
        elif [ -f /etc/opkg/opkg.conf ] ; then
            opkg install --force-overwrite --force-depends libssl1.0.2 > /dev/null
            ln -s libssl.so.1.0.2 $usrlibpath/libssl.so.1.0.0 > /dev/null 2>&1
            ln -s libssl.so.1.0.2 $usrlibpath/libssl.so.0.9.8 > /dev/null 2>&1
            ln -s libssl.so.1.0.2 $usrlibpath/libssl.so.0.9.7 > /dev/null 2>&1
            ln -s $usrlibpath/libssl.so.1.0.2 $libpath/libssl.so.1.0.0 > /dev/null 2>&1
            ln -s $usrlibpath/libssl.so.1.0.2 $libpath/libssl.so.0.9.8 > /dev/null 2>&1
            ln -s $usrlibpath/libssl.so.1.0.2 $libpath/libssl.so.0.9.7 > /dev/null 2>&1
        fi
    elif [ -n "$(opkg list | grep libssl1.0.0)" ]; then
        echo "install libssl1.0.0"
        if [ -f /etc/apt/apt.conf ] ; then
            apt-get install --reinstall libssl1.0.0 > /dev/null 2>&1
            ln -s libssl.so.1.0.0 $usrlibpath/libssl.so.0.9.8 > /dev/null 2>&1
            ln -s libssl.so.1.0.0 $usrlibpath/libssl.so.0.9.7 > /dev/null 2>&1
            ln -s $usrlibpath/libssl.so.1.0.0 $libpath/libssl.so.0.9.8 > /dev/null 2>&1
            ln -s $usrlibpath/libssl.so.1.0.0 $libpath/libssl.so.0.9.7 > /dev/null 2>&1
        elif [ -f /etc/opkg/opkg.conf ] ; then
            opkg install --force-overwrite --force-depends libssl1.0.0 > /dev/null
            ln -s libssl.so.1.0.0 $usrlibpath/libssl.so.0.9.8 > /dev/null 2>&1
            ln -s libssl.so.1.0.0 $usrlibpath/libssl.so.0.9.7 > /dev/null 2>&1
            ln -s $usrlibpath/libssl.so.1.0.0 $libpath/libssl.so.0.9.8 > /dev/null 2>&1
            ln -s $usrlibpath/libssl.so.1.0.0 $libpath/libssl.so.0.9.7 > /dev/null 2>&1
        fi
    elif [ -n "$(opkg list | grep libssl0.9.8)" ]; then
        echo "install libssl0.9.8"
        if [ -f /etc/apt/apt.conf ] ; then
            apt-get install --reinstall libssl0.9.8 > /dev/null 2>&1
            ln -s libssl.so.0.9.8 $usrlibpath/libssl.so.0.9.7 > /dev/null 2>&1
            ln -s libssl.so.0.9.8 $usrlibpath/libssl.so.1.0.0 > /dev/null 2>&1
            ln -s $usrlibpath/libssl.so.0.9.8 $libpath/libssl.so.0.9.7 > /dev/null 2>&1
            ln -s $usrlibpath/libssl.so.0.9.8 $libpath/libssl.so.1.0.0 > /dev/null 2>&1
        elif [ -f /etc/opkg/opkg.conf ] ; then
            opkg install --force-overwrite --force-depends libssl0.9.8 > /dev/null 2>&1
            ln -s libssl.so.0.9.8 $usrlibpath/libssl.so.0.9.7 > /dev/null 2>&1
            ln -s libssl.so.0.9.8 $usrlibpath/libssl.so.1.0.0 > /dev/null 2>&1
            ln -s $usrlibpath/libssl.so.0.9.8 $libpath/libssl.so.0.9.7 > /dev/null 2>&1
            ln -s $usrlibpath/libssl.so.0.9.8 $libpath/libssl.so.1.0.0 > /dev/null 2>&1
        fi
    else
        echo $LINE
        echo "ERROR: The libsslx.x.x file could not be loaded from the repository."
        echo $LINE
        exit 1
    fi
fi
############################## libcrypto ####################
if grep -qs 'Package: libcrypto3' cat $lib_files ; then
    echo "$images libcrypto3"
    ln -s libcrypto.so.3 $usrlibpath/libcrypto.so.1.1.1 > /dev/null 2>&1
    ln -s libcrypto.so.3 $usrlibpath/libcrypto.so.1.0.0 > /dev/null 2>&1
    ln -s libcrypto.so.3 $usrlibpath/libcrypto.so.0.9.8 > /dev/null 2>&1
    ln -s libcrypto.so.3 $usrlibpath/libcrypto.so.0.9.7 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.3 $libpath/libcrypto.so.1.0.0 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.3 $libpath/libcrypto.so.0.9.8 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.3 $libpath/libcrypto.so.0.9.7 > /dev/null 2>&1
elif grep -qs 'Package: libcrypto1.1' cat $lib_files ; then
    echo "$images libcrypto1.1"
    ln -s libcrypto.so.1.1 $usrlibpath/libcrypto.so.1.0.0 > /dev/null 2>&1
    ln -s libcrypto.so.1.1 $usrlibpath/libcrypto.so.0.9.8 > /dev/null 2>&1
    ln -s libcrypto.so.1.1 $usrlibpath/libcrypto.so.0.9.7 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.1.1 $libpath/libcrypto.so.1.0.0 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.1.1 $libpath/libcrypto.so.0.9.8 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.1.1 $libpath/libcrypto.so.0.9.7 > /dev/null 2>&1
elif grep -qs 'Package: libcrypto1.0.0' cat $lib_files ; then
    echo "$images libcrypto.1.0.0"
    ln -s libcrypto.so.1.0.0 $usrlibpath/libcrypto.so.0.9.8 > /dev/null 2>&1
    ln -s libcrypto.so.1.0.0 $usrlibpath/libcrypto.so.0.9.7 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.1.0.0 $libpath/libcrypto.so.0.9.8 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.1.0.0 $libpath/libcrypto.so.0.9.7 > /dev/null 2>&1
elif grep -qs 'Package: libcrypto1.0.2' cat $lib_files ; then
    echo "$images libcrypto.1.0.2"
    ln -s libcrypto.so.1.0.2 $usrlibpath/libcrypto.so.1.0.0 > /dev/null 2>&1
    ln -s libcrypto.so.1.0.2 $usrlibpath/libcrypto.so.0.9.8 > /dev/null 2>&1
    ln -s libcrypto.so.1.0.2 $usrlibpath/libcrypto.so.0.9.7 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.1.0.2 $libpath/libcrypto.so.1.0.0 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.1.0.2 $libpath/libcrypto.so.0.9.8 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.1.0.2 $libpath/libcrypto.so.0.9.7 > /dev/null 2>&1
elif grep -qs 'Package: libcrypto0.9.8' cat $lib_files ; then
    echo "$images libcrypto.0.9.8"
    ln -s libcrypto.so.0.9.8 $usrlibpath/libcrypto.so.0.9.7 > /dev/null 2>&1
    ln -s libcrypto.so.0.9.8 $usrlibpath/libcrypto.so.1.0.0 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.0.9.8 $libpath/libcrypto.so.0.9.7 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.0.9.8 $libpath/libcrypto.so.1.0.0 > /dev/null 2>&1
elif [ -f /usr/lib/libcrypto.so.3 ] ; then
    echo "$images libcrypto3"
    ln -s libcrypto.so.3 $usrlibpath/libcrypto.so.1.1.1 > /dev/null 2>&1
    ln -s libcrypto.so.3 $usrlibpath/libcrypto.so.1.0.0 > /dev/null 2>&1
    ln -s libcrypto.so.3 $usrlibpath/libcrypto.so.0.9.8 > /dev/null 2>&1
    ln -s libcrypto.so.3 $usrlibpath/libcrypto.so.0.9.7 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.3 $libpath/libcrypto.so.1.0.0 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.3 $libpath/libcrypto.so.0.9.8 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.3 $libpath/libcrypto.so.0.9.7 > /dev/null 2>&1
elif [ -f /usr/lib/libcrypto.so.1.1 ] ; then
    echo "$images libcrypto1.1"
    ln -s libcrypto.so.1.1 $usrlibpath/libcrypto.so.1.0.0 > /dev/null 2>&1
    ln -s libcrypto.so.1.1 $usrlibpath/libcrypto.so.0.9.8 > /dev/null 2>&1
    ln -s libcrypto.so.1.1 $usrlibpath/libcrypto.so.0.9.7 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.1.1 $libpath/libcrypto.so.1.0.0 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.1.1 $libpath/libcrypto.so.0.9.8 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.1.1 $libpath/libcrypto.so.0.9.7 > /dev/null 2>&1
elif [ -f /usr/lib/libcrypto.so.1.0.0 ] ; then
    echo "$images libcrypto.1.0.0"
    ln -s libcrypto.so.1.0.0 $usrlibpath/libcrypto.so.0.9.8 > /dev/null 2>&1
    ln -s libcrypto.so.1.0.0 $usrlibpath/libcrypto.so.0.9.7 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.1.0.0 $libpath/libcrypto.so.0.9.8 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.1.0.0 $libpath/libcrypto.so.0.9.7 > /dev/null 2>&1
elif [ -f /usr/lib/libcrypto.so.1.0.2 ] ; then
    echo "$images libcrypto.1.0.2"
    ln -s libcrypto.so.1.0.2 $usrlibpath/libcrypto.so.1.0.0 > /dev/null 2>&1
    ln -s libcrypto.so.1.0.2 $usrlibpath/libcrypto.so.0.9.8 > /dev/null 2>&1
    ln -s libcrypto.so.1.0.2 $usrlibpath/libcrypto.so.0.9.7 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.1.0.2 $libpath/libcrypto.so.1.0.0 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.1.0.2 $libpath/libcrypto.so.0.9.8 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.1.0.2 $libpath/libcrypto.so.0.9.7 > /dev/null 2>&1
elif [ -f /usr/lib/libcrypto.so.0.9.8 ] ; then
    echo "$images libcrypto.0.9.8"
    ln -s libcrypto.so.0.9.8 $usrlibpath/libcrypto.so.0.9.7 > /dev/null 2>&1
    ln -s libcrypto.so.0.9.8 $usrlibpath/libcrypto.so.1.0.0 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.0.9.8 $libpath/libcrypto.so.0.9.7 > /dev/null 2>&1
    ln -s $usrlibpath/libcrypto.so.0.9.8 $libpath/libcrypto.so.1.0.0 > /dev/null 2>&1
else ## Try to Download libcrypto from feed
    opkg update
    if [ -n "$(opkg list | grep libcrypto3)" ]; then
        echo "install libcrypto3"
        if [ -f /etc/apt/apt.conf ] ; then
            apt-get install --reinstall libcrypto3 > /dev/null 2>&1
            ln -s libcrypto.so.3 $usrlibpath/libcrypto.so.1.1.1 > /dev/null 2>&1
            ln -s libcrypto.so.3 $usrlibpath/libcrypto.so.1.0.0 > /dev/null 2>&1
            ln -s libcrypto.so.3 $usrlibpath/libcrypto.so.0.9.8 > /dev/null 2>&1
            ln -s libcrypto.so.3 $usrlibpath/libcrypto.so.0.9.7 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.3 $libpath/libcrypto.so.1.1-1 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.3 $libpath/libcrypto.so.1.0.0 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.3 $libpath/libcrypto.so.0.9.8 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.3 $libpath/libcrypto.so.0.9.7 > /dev/null 2>&1
        elif [ -f /etc/opkg/opkg.conf ] ; then
            opkg install --force-overwrite --force-depends libcrypto3 > /dev/null
            ln -s libcrypto.so.3 $usrlibpath/libcrypto.so.1.1.1 > /dev/null 2>&1
            ln -s libcrypto.so.3 $usrlibpath/libcrypto.so.1.0.0 > /dev/null 2>&1
            ln -s libcrypto.so.3 $usrlibpath/libcrypto.so.0.9.8 > /dev/null 2>&1
            ln -s libcrypto.so.3 $usrlibpath/libcrypto.so.0.9.7 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.3 $libpath/libcrypto.so.1.1.1 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.3 $libpath/libcrypto.so.1.0.0 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.3 $libpath/libcrypto.so.0.9.8 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.3 $libpath/libcrypto.so.0.9.7 > /dev/null 2>&1
        fi        
    elif [ -n "$(opkg list | grep libcrypto1.1)" ]; then
        echo "install libcrypto1.1"
        if [ -f /etc/apt/apt.conf ] ; then
            apt-get install --reinstall libcrypto1.1 > /dev/null 2>&1
            ln -s libcrypto.so.1.1 $usrlibpath/libcrypto.so.1.0.0 > /dev/null 2>&1
            ln -s libcrypto.so.1.1 $usrlibpath/libcrypto.so.0.9.8 > /dev/null 2>&1
            ln -s libcrypto.so.1.1 $usrlibpath/libcrypto.so.0.9.7 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.1.1 $libpath/libcrypto.so.1.0.0 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.1.1 $libpath/libcrypto.so.0.9.8 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.1.1 $libpath/libcrypto.so.0.9.7 > /dev/null 2>&1
        elif [ -f /etc/opkg/opkg.conf ] ; then
            opkg install --force-overwrite --force-depends libcrypto1.1 > /dev/null
            ln -s libcrypto.so.1.1 $usrlibpath/libcrypto.so.1.0.0 > /dev/null 2>&1
            ln -s libcrypto.so.1.1 $usrlibpath/libcrypto.so.0.9.8 > /dev/null 2>&1
            ln -s libcrypto.so.1.1 $usrlibpath/libcrypto.so.0.9.7 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.1.1 $libpath/libcrypto.so.1.0.0 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.1.1 $libpath/libcrypto.so.0.9.8 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.1.1 $libpath/libcrypto.so.0.9.7 > /dev/null 2>&1
        fi
    elif [ -n "$(opkg list | grep libcrypto1.0.2)" ]; then
        echo "install libcrypto1.0.2"
        if [ -f /etc/apt/apt.conf ] ; then
            apt-get install --reinstall libcrypto1.0.2 > /dev/null 2>&1
            ln -s libcrypto.so.1.0.2 $usrlibpath/libcrypto.so.1.0.0 > /dev/null 2>&1
            ln -s libcrypto.so.1.0.2 $usrlibpath/libcrypto.so.0.9.8 > /dev/null 2>&1
            ln -s libcrypto.so.1.0.2 $usrlibpath/libcrypto.so.0.9.7 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.1.0.2 $libpath/libcrypto.so.1.0.0 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.1.0.2 $libpath/libcrypto.so.0.9.8 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.1.0.2 $libpath/libcrypto.so.0.9.7 > /dev/null 2>&1
        elif [ -f /etc/opkg/opkg.conf ] ; then
            opkg install --force-overwrite --force-depends libcrypto1.0.2 > /dev/null
            ln -s libcrypto.so.1.0.2 $usrlibpath/libcrypto.so.1.0.0 > /dev/null 2>&1
            ln -s libcrypto.so.1.0.2 $usrlibpath/libcrypto.so.0.9.8 > /dev/null 2>&1
            ln -s libcrypto.so.1.0.2 $usrlibpath/libcrypto.so.0.9.7 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.1.0.2 $libpath/libcrypto.so.1.0.0 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.1.0.2 $libpath/libcrypto.so.0.9.8 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.1.0.2 $libpath/libcrypto.so.0.9.7 > /dev/null 2>&1
        fi
    elif [ -n "$(opkg list | grep libcrypto1.0.0)" ]; then
        echo "install libcrypto1.0.0"
        if [ -f /etc/apt/apt.conf ] ; then
            apt-get install --reinstall libcrypto1.0.0 > /dev/null 2>&1
            ln -s libcrypto.so.1.0.0 $usrlibpath/libcrypto.so.0.9.8 > /dev/null 2>&1
            ln -s libcrypto.so.1.0.0 $usrlibpath/libcrypto.so.0.9.7 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.1.0.0 $libpath/libcrypto.so.0.9.8 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.1.0.0 $libpath/libcrypto.so.0.9.7 > /dev/null 2>&1
        elif [ -f /etc/opkg/opkg.conf ] ; then
            opkg install --force-overwrite --force-depends libcrypto1.0.0 > /dev/null
            ln -s libcrypto.so.1.0.0 $usrlibpath/libcrypto.so.0.9.8 > /dev/null 2>&1
            ln -s libcrypto.so.1.0.0 $usrlibpath/libcrypto.so.0.9.7 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.1.0.0 $libpath/libcrypto.so.0.9.8 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.1.0.0 $libpath/libcrypto.so.0.9.7 > /dev/null 2>&1
        fi
    elif [ -n "$(opkg list | grep libcrypto0.9.8)" ]; then
        echo "install libcrypto0.9.8"
        if [ -f /etc/apt/apt.conf ] ; then
            apt-get install --reinstall libcrypto0.9.8 > /dev/null 2>&1
            ln -s libcrypto.so.0.9.8 $usrlibpath/libcrypto.so.0.9.7 > /dev/null 2>&1
            ln -s libcrypto.so.0.9.8 $usrlibpath/libcrypto.so.1.0.0 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.0.9.8 $libpath/libcrypto.so.0.9.7 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.0.9.8 $libpath/libcrypto.so.1.0.0 > /dev/null 2>&1
        elif [ -f /etc/opkg/opkg.conf ] ; then
            opkg install --force-overwrite --force-depends libcrypto0.9.8 > /dev/null 2>&1
            ln -s libcrypto.so.0.9.8 $usrlibpath/libcrypto.so.0.9.7 > /dev/null 2>&1
            ln -s libcrypto.so.0.9.8 $usrlibpath/libcrypto.so.1.0.0 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.0.9.8 $libpath/libcrypto.so.0.9.7 > /dev/null 2>&1
            ln -s $usrlibpath/libcrypto.so.0.9.8 $libpath/libcrypto.so.1.0.0 > /dev/null 2>&1
        fi
    else
        echo $LINE
        echo "ERROR: The libcryptox.x.x file could not be loaded from the repository."
        echo $LINE
        exit 1
    fi
fi

else
echo "> "$plugin"-"$version" Package Installation Failed"
fi

fi
exit 0
