#!/bin/sh
if [ -d /usr/lib/enigma2/python/Plugins/Extensions/xtraEvent ]; then
echo "> removing package please wait..."
sleep 3s 
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/xtraEvent > /dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Components/Converter/xtra* > /dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Components/Renderer/xtra* > /dev/null 2>&1

status='/var/lib/opkg/status'
package='enigma2-plugin-extensions-xtraevent'
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
 
#check install deps
# Check python
pyVersion=$(python -c"from sys import version_info; print(version_info[0])")

deps=( "wget" )

if [ "$pyVersion" = 3 ]; then
  deps+=( "python3-imaging" "python3-requests" )
else

python-imaging, python-requests
  
deps+=( "python-imaging" "python-requests" )
fi

left=">>>>"
right="<<<<"
LINE1="---------------------------------------------------------"
LINE2="-------------------------------------------------------------------------------------"

if [ -f /etc/opkg/opkg.conf ]; then
  STATUS='/var/lib/opkg/status'
  OSTYPE='Opensource'
  OPKG='opkg update'
  OPKGINSTAL='opkg install'
elif [ -f /etc/apt/apt.conf ]; then
  STATUS='/var/lib/dpkg/status'
  OSTYPE='DreamOS'
  OPKG='apt-get update'
  OPKGINSTAL='apt-get install -y'
fi

install() {
  if ! grep -qs "Package: $1" "$STATUS"; then
    $OPKG >/dev/null 2>&1
    rm -rf /run/opkg.lock
    echo -e "> Need to install ${left} $1 ${right} please wait..."
    echo "$LINE2"
    sleep 0.8
    echo
    if [ "$OSTYPE" = "Opensource" ]; then
      $OPKGINSTAL "$1"
      sleep 1
      clear
    elif [ "$OSTYPE" = "DreamOS" ]; then
      $OPKGINSTAL "$1" -y
      sleep 1
      clear
    fi
  fi
}

for i in "${deps[@]}"; do
  install "$i"
done

#check install deps
# Check python
pyVersion=$(python -c"from sys import version_info; print(version_info[0])")

#config
plugin=xtraevent
version=4.2

if [ "$pyVersion" = 3 ]; then
url=https://gitlab.com/eliesat/extensions/-/raw/main/xtraevent/xtraevent-py3-4.2.tar.gz
package=/var/volatile/tmp/$plugin-py3-$version.tar.gz
else
url=https://gitlab.com/eliesat/extensions/-/raw/main/xtraevent/xtraevent-py2-4.2.tar.gz
package=/var/volatile/tmp/$plugin-py2-$version.tar.gz
fi

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
