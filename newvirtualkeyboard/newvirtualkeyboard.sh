#!/bin/sh

#wget -q "--no-check-certificate" https://gitlab.com/eliesat/systemplugins/-/raw/main/newvirtualkeyboard-12.7.tar.gz -O - | /bin/sh 

#config
package=newvirtualkeyboard
version=12.7


#remove old skin#
cp -r /usr/lib/enigma2/python/Plugins/SystemPlugins/NewVirtualKeyBoard/skins/kle /tmp/ >/dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Plugins/SystemPlugins/NewVirtualKeyboard >/dev/null 2>&1

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

#download package

echo "> Downloading "$package" "$version" Package  Please Wait ..."
sleep 3s

wget -O /var/volatile/tmp/"$package"-"$version".tar.gz --no-check-certificate "https://gitlab.com/eliesat/systemplugins/-/raw/main/"$package"-"$version".tar.gz"

echo "> Installing "$package" "$version" Package  Please Wait ..."
sleep 3s


#extract new skin#
tar -xf /var/volatile/tmp/"$package"-"$version".tar.gz -C /
MY_RESULT=$?

#remove files from tmp#
rm -f /var/volatile/tmp/"$package"-"$version".tar.gz > /dev/null 2>&1

echo ''
if [ $MY_RESULT -eq 0 ]; then 
echo "> "$package" "$version" Package Installed Successfully"

else
echo "> "$package"-"$version" Package Installation Failed"
fi
exit 0