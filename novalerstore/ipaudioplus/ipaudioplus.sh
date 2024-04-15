#!/bin/sh
if [ -d /usr/lib/enigma2/python/Plugins/Extensions/IPaudioPlus ]; then
echo "> removing package please wait..."
sleep 3s 
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/IPaudioPlus > /dev/null 2>&1

status='/var/lib/opkg/status'
package='enigma2-plugin-extensions-ipaudioplus'

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

# Check python
py=$(python -c"from sys import version_info; print(version_info[0])")

echo "> checking dependencies please wait..."
sleep 1s

if [ "$py" = 3 ]; then

for i in alsa-plugins enigma2-plugin-systemplugins-serviceapp exteplayer3 ffmpeg libc6 gstreamer1.0-plugins-base gstreamer1.0-plugins-base-apps gstreamer1.0-plugins-good python3-core python3-image python3-json python3-multiprocessing python3-requests python3-cryptography
do
opkg install $i >/dev/null 2>&1
done
else
for i in alsa-plugins enigma2-plugin-systemplugins-serviceapp exteplayer3 ffmpeg libc6 gstreamer1.0-plugins-base gstreamer1.0-plugins-base-apps gstreamer1.0-plugins-good python-core python-image python-json python-multiprocessing python-requests python-cryptography
do
opkg install $i >/dev/null 2>&1
done
fi

#config
pack=ipaudioplus
version=3.0-r0
install="opkg install --force-reinstall"
#check python version
python=$(python -c "import platform; print(platform.python_version())")

case $python in 
2.7.18)
url='https://gitlab.com/eliesat/extensions/-/raw/main/novalerstore/ipaudioplus'
ipk="$pack-py2-$version.ipk"
;;

3.9.7|3.9.9)
url='https://gitlab.com/eliesat/extensions/-/raw/main/novalerstore/ipaudioplus'
ipk="$pack-py3.9-$version.ipk"
;;

3.11.0|3.11.1|3.11.2|3.11.3|3.11.5|3.11.5|3.11.6)
url='https://gitlab.com/eliesat/extensions/-/raw/main/novalerstore/ipaudioplus'
ipk="$pack-py3-$version.ipk"
;;
esac

# Download and install plugin
echo "> Downloading "$pack"-"$version" please wait..."
sleep 3s

cd /tmp
set -e
wget --show-progress "$url/$ipk"
$install $ipk
set +e
install=$?
cd ..
wait
rm -f /tmp/$ipk

echo ''
if [ $install -eq 0 ]; then
echo "> $plugin-$version package installed successfully"
echo "> Uploaded By ElieSat"
sleep 3s

else

echo "> $plugin-$version package installation failed"
sleep 3s
fi

fi
exit
