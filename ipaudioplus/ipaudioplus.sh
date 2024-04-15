#!/bin/sh
if [ -d /usr/lib/enigma2/python/Plugins/Extensions/IPaudioPlus ]; then
echo "> removing package please wait..."
sleep 3s 
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/IPaudioPlus > /dev/null 2>&1

status='/var/lib/opkg/status'
package='enigma2-plugin-weblinks-novaler-ipaudioplus'

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

#check install deps
# Check python
status='/var/lib/opkg/status'
pyt=$(python -c"import sys; print(sys.version_info.major)")
if [ "$pyt" -eq 3 ]; then

pack='alsa-plugins'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='enigma2-plugin-systemplugins-serviceapp'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='ffmpeg'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='gstreamer1.0-plugins-base'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='gstreamer1.0-plugins-base-apps'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='gstreamer1.0-plugins-good'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='libc6'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='python3-core'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='python3-cryptography'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='python3-json'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='python3-requests'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi

else

pack='alsa-plugins'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='enigma2-plugin-systemplugins-serviceapp'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='ffmpeg'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='gstreamer1.0-plugins-base'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='gstreamer1.0-plugins-base-apps'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='gstreamer1.0-plugins-good'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='libc6'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='python-core'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='python-cryptography'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='python-json'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='python-requests'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi


fi

#config
plugin=ipaudioplus
version=3.0-r0

#check python version
python=$(python -c "import platform; print(platform.python_version())")

case $python in 
2.7.18)
url='https://gitlab.com/eliesat/extensions/-/raw/main/ipaudioplus/ipaudioplus-py2-3.0-r0.tar.gz';;
3.9.7|3.9.9)
url='https://gitlab.com/eliesat/extensions/-/raw/main/ipaudioplus/ipaudioplus-py3.9-3.0-r0.tar.gz';;
3.11.0|3.11.1|3.11.2)
url='https://gitlab.com/eliesat/extensions/-/raw/main/ipaudioplus/ipaudioplus-py3.11-3.0-r0.tar.gz';;
esac


case $python in 
2.7.18)
package='/var/volatile/tmp/$plugin-py2-$version.tar.gz';;
3.9.7|3.9.9)
package='/var/volatile/tmp/$plugin-py3.9-$version.tar.gz';;
3.11.0|3.11.1|3.11.2)
package='/var/volatile/tmp/$plugin-py3.11-$version.tar.gz';;
esac

#download & install
echo "> Downloading $plugin-$version package  please wait ..."
sleep 3s

wget -O $package --no-check-certificate $url
tar -xzf $package -C /
extract=$?
rm -rf $package >/dev/null 2>&1

echo "pass" >/usr/lib/enigma2/python/Plugins/Extensions/IPaudioPlus/plugin.py

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
