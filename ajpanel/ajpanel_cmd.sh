#!/bin/sh

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

espp=$(cat /etc/enigma2/settings | grep config.plugins.AJPanel.backupPath | cut -d '=' -f 2)
pack="ajpanel_cmd"
package=$espp$pack
url=https://gitlab.com/eliesat/extensions/-/raw/main/ajpanel/ajpanel_cmd

echo "> Installing $pack please wait ..."
sleep 3s
#download & install
wget -O $package --no-check-certificate $url
echo "> $pack file installed successfully"
echo "> Uploaded By ElieSat"
sleep 3s

exit
