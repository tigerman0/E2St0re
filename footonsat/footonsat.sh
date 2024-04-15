#!/bin/sh

# remove old version #
if [ -d /usr/lib/enigma2/python/Plugins/Extensions/FootOnSat ]; then
echo "> removing package please wait..."
sleep 3s 
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/FootOnSat >/dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Components/Converter/FootNext* >/dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Components/Renderer/FootPicon* >/dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Components/FootMenu* >/dev/null 2>&1
opkg remove enigma2-plugin-extensions-footonsat >/dev/null 2>&1

echo "*******************************************"
echo "*             Removed Finished            *"
echo "*            Uploaded By Eliesat          *"
echo "*******************************************"
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
package=footonsat
version=1.9

#check install deps
# Check python
pyVersion=$(python -c"from sys import version_info; print(version_info[0])")

deps=("alsa-utils-aplay")

if [ "$pyVersion" = 3 ]; then
  deps+=( "python3-six" "python3-sqlite3" )

else
  
deps+=( "python-six" "python-sqlite3" )
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

#download package
echo "> Downloading "$package" "$version" Package  Please Wait ..."
sleep 3s

wget -O /var/volatile/tmp/"$package"-"$version".tar.gz --no-check-certificate "https://gitlab.com/eliesat/extensions/-/raw/main/footonsat/"$package"-"$version".tar.gz"

echo "> Installing "$package" "$version" Package  Please Wait ..."
sleep 3s

#extract new package#
tar -xf /var/volatile/tmp/"$package"-"$version".tar.gz -C /
extract=$?


#remove files from tmp#
rm -f /var/volatile/tmp/"$package"-"$version".tar.gz > /dev/null 2>&1

echo ''
if [ $extract -eq 0 ]; then 
echo "> "$package" "$version" Package Installed Successfully"

else
echo "> "$package"-"$version" Package Installation Failed"
fi

fi
exit 0