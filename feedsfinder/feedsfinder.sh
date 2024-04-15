#!/bin/sh
if [ -d /usr/lib/enigma2/python/Plugins/Extensions/FeedsFinder ]; then
echo "> removing package please wait..."
sleep 3s 
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/FeedsFinder > /dev/null 2>&1

status='/var/lib/opkg/status'
package='enigma2-plugin-extensions-feeds-finder'
package1='enigma2-plugin-extensions-feedsfinder'

if grep -q $package $status; then
opkg remove $package
fi
if grep -q $package1 $status; then
opkg remove $package1
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

#config
plugin=feedsfinder
version=3.1

#check python version
python=$(python -c "import platform; print(platform.python_version())")

case $python in 
2.7.18)
url='https://gitlab.com/eliesat/extensions/-/raw/main/feedsfinder/feedsfinder-py2-3.1.tar.gz';;
3.8.5)
url='https://gitlab.com/eliesat/extensions/-/raw/main/feedsfinder/feedsfinder-py3.9-3.1.tar.gz';;
3.9.7|3.9.9)
url='https://gitlab.com/eliesat/extensions/-/raw/main/feedsfinder/feedsfinder-py3.9-3.1.tar.gz';;
3.10.4)
url='https://gitlab.com/eliesat/extensions/-/raw/main/feedsfinder/feedsfinder-py3.10-3.1.tar.gz';;
3.11.0|3.11.1|3.11.2|3.11.4|3.11.5|3.11.6)
url='https://gitlab.com/eliesat/extensions/-/raw/main/feedsfinder/feedsfinder-py3.11-3.1.tar.gz';;
esac


case $python in 
2.7.18)
package='/var/volatile/tmp/$plugin-py2-$version.tar.gz';;
3.8.5)
package='/var/volatile/tmp/$plugin-py3.9-$version.tar.gz';;
3.9.7|3.9.9)
package='/var/volatile/tmp/$plugin-py3.9-$version.tar.gz';;
3.10.4)
package='/var/volatile/tmp/$plugin-py3.10-$version.tar.gz';;
3.11.0|3.11.1|3.11.2|3.11.4|3.11.5|3.11.6)
package='/var/volatile/tmp/$plugin-py3.11-$version.tar.gz';;
esac

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
