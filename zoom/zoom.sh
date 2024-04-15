#!/bin/sh

# Configuration
plugin="zoom"
version="1.1.2"
targz_file="$plugin-$version.tar.gz"
package="zoom.ipk"
temp_dir="/tmp"
python=$(python -c "import platform; print(platform.python_version())")
case $python in 
2.7.18)
echo "> your image python version: $python is not supported"
sleep 3
exit 1
;;
*)
url="https://gitlab.com/eliesat/extensions/-/raw/main/zoom/zoom-1.1.2.tar.gz"
sleep 3
;;
esac

# Determine package manager
if command -v dpkg &> /dev/null; then
package_manager="apt"
status_file="/var/lib/dpkg/status"
uninstall_command="apt-get purge --auto-remove -y"
else
package_manager="opkg"
status_file="/var/lib/opkg/status"
uninstall_command="opkg remove --force-depends"
fi

check_and_remove_package() {
if [ -d /usr/lib/enigma2/python/Plugins/Extensions/Zoom ]; then
echo "> removing package old version please wait..."
sleep 3
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/Zoom > /dev/null 2>&1

if grep -q "$package" "$status_file"; then
echo "> Removing existing $package package, please wait..."
$uninstall_command $package
fi
echo "*******************************************"
echo "*             Removed Finished            *"
echo "*            Uploaded By Eliesat          *"
echo "*******************************************"
sleep 3
exit 1
else
echo " " 
fi  }
check_and_remove_package

#download & install package
echo "> Downloading $plugin-$version package  please wait ..."
sleep 3
wget -O $temp_dir/$targz_file --no-check-certificate $url
tar -xzf $temp_dir/$targz_file -C /
extract=$?
rm -rf $temp_dir/$targz_file >/dev/null 2>&1

echo ''
if [ $extract -eq 0 ]; then
chmod -R 755 /usr/script/server/
chmod -R 755 /usr/script/addons/
chmod -R 755 /usr/script/ZOOM_CAM/

if command -v dpkg &> /dev/null; then
apt install curl > /dev/null 2>&1
else
opkg install curl > /dev/null 2>&1
fi
cd
rm -rf /CCcam*
rm -rf /etc/CCcam
if [ ! -e "/etc/CCcamDATAx.cfg" ]; then
> /etc/CCcamDATAx.cfg
else
echo ''
fi
if [ ! -e "/etc/OscamDATAx.cfg" ]; then
> /etc/OscamDATAx.cfg
else
echo ''
fi
sleep 2

echo "> $plugin-$version package installed successfully"
echo "> Uploaded By ElieSat"
else
echo "> $plugin-$version package installation failed"
sleep 3
fi
    