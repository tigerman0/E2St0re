#!/bin/sh

# Configuration
plugin="translator"
version="1.4r2"
targz_file="$plugin-$version.tar.gz"
python=$(python -c"from sys import version_info; print(version_info[0])")
package="enigma2-plugin-softcams-subssupport"
temp_dir="/tmp"
case $python in 
3)
url="https://gitlab.com/eliesat/extensions/-/raw/main/epgtranslator/py3/translator-1.4r2.tar.gz"
sleep 3
;;
2)
url="https://gitlab.com/eliesat/extensions/-/raw/main/epgtranslator/py2/translator-1.4r2.tar.gz"
sleep 3
;;
*)
echo "> your image python version: $python is not supported"
sleep 3
exit 1
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
if [ -d /usr/lib/enigma2/python/Plugins/Extensions/EPGTranslator ]; then
echo "> removing package old version please wait..."
sleep 3 
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/EPGTranslator > /dev/null 2>&1

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
echo "> $plugin-$version package installed successfully"
sleep 3
echo "> Uploaded By ElieSat"
else
echo "> $plugin-$version package installation failed"
sleep 3
fi
    