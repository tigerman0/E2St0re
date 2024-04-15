#!/bin/sh
if [ -d /usr/lib/enigma2/python/Plugins/Extensions/MultiStalker ]; then
echo "> removing package please wait..."
sleep 3s 
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/MultiStalker > /dev/null 2>&1

status='/var/lib/opkg/status'
package='enigma2-plugin-extensions-multistalker'

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
pack='python3-imaging'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='python3-six'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
else
pack='python-imaging'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
pack='python-six'
if grep -q $pack $status; then
rm -rf /run/opkg.lock
opkg install $pack > /dev/null 2>&1
fi
fi

arch=$(uname -m)
#check python version
python=$(python -c "import platform; print(platform.python_version())")

sleep 1;
if [ "$arch" == "mips" ]; then
case $python in 
2.7.18)
url='https://gitlab.com/eliesat/extensions/-/raw/main/multistalker/multistalker-1.5-mips-2.7.tar.gz'
package='/var/volatile/tmp/multistalker-1.5-mips-2.7.tar.gz'
;;
3.8.5)
url='https://gitlab.com/eliesat/extensions/-/raw/main/multistalker/multistalker-1.5-mips-3.8.5.tar.gz'
package='/var/volatile/tmp/multistalker-1.5-mips-3.8.5.tar.gz'
;;
3.9.7|3.9.9)
url='https://gitlab.com/eliesat/extensions/-/raw/main/multistalker/multistalker-1.5-mips-3.9.tar.gz'
package='/var/volatile/tmp/multistalker-1.5-mips-3.9.tar.gz'
;;
3.10.4)
url='https://gitlab.com/eliesat/extensions/-/raw/main/multistalker/multistalker-1.5-mips-3.10.tar.gz'
package='/var/volatile/tmp/multistalker-1.5-mips-3.10.tar.gz'
;;
3.11.0|3.11.1|3.11.2)
url='https://gitlab.com/eliesat/extensions/-/raw/main/multistalker/multistalker-1.5-mips-3.11.tar.gz'
package='/var/volatile/tmp/multistalker-1.5-mips-3.11.tar.gz'
;;
*)
echo "> your image python version: $python is not supported"
sleep 3
exit 1
;;
esac

elif [ "$arch" == "armv7l" ]; then
case $python in 
2.7.18)
url='https://gitlab.com/eliesat/extensions/-/raw/main/multistalker/multistalker-1.5-arm-2.7.tar.gz'
package='/var/volatile/tmp/multistalker-1.5-arm-2.7.tar.gz'
;;
3.8.5)
url='https://gitlab.com/eliesat/extensions/-/raw/main/multistalker/multistalker-1.5-arm-3.8.5.tar.gz'
package='/var/volatile/tmp/multistalker-1.5-arm-3.8.5.tar.gz'
;;
3.9.7|3.9.9)
url='https://gitlab.com/eliesat/extensions/-/raw/main/multistalker/multistalker-1.5-arm-3.9.tar.gz'
package='/var/volatile/tmp/multistalker-1.5-arm-3.9.tar.gz'
;;
3.10.4)
url='https://gitlab.com/eliesat/extensions/-/raw/main/multistalker/multistalker-1.5-arm-3.10.tar.gz'
package='/var/volatile/tmp/multistalker-1.5-arm-3.10.tar.gz'
;;
3.11.0|3.11.1|3.11.2|3.11.3|3.11.4|3.11.5|3.11.6)
url='https://gitlab.com/eliesat/extensions/-/raw/main/multistalker/multistalker-1.5-arm-3.11.tar.gz'
package='/var/volatile/tmp/multistalker-1.5-arm-3.11.tar.gz'
;;

3.12.0|3.12.1|3.12.2|3.12.3|3.12.4|3.12.5|3.12.6)
url='https://gitlab.com/eliesat/extensions/-/raw/main/multistalker/multistalker-1.5-arm-3.12.tar.gz'
package='/var/volatile/tmp/multistalker-1.5-arm-3.12.tar.gz'
;;
*)
echo "> your image python version: $python is not supported"
sleep 3
exit 1
;;
esac
rm -rf $proc > /dev/null 2>&1
fi



#config
plugin=multistalker
version=1.5

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
exit
