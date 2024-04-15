#!/bin/bash
#config
espp=$(cat /etc/enigma2/settings | grep config.plugins.AJPanel.backupPath | cut -d '=' -f 2)


pack="ajpanel_menu.xml"
package=$espp$pack
url=https://gitlab.com/eliesat/extensions/-/raw/main/ajpanel/ajpanel_menu.xml
if [ "$espp" == "/media/hdd/AJPanel_Backup/" ]; then
pack="ajpanel_menu_Elie.xml"
package=$espp$pack
fi

#download & install
echo "> installing Eliesatpanel latest update please wait ..."
sleep 3s
wget -O $package --no-check-certificate $url

if [ ! -d /usr/lib/enigma2/python/Plugins/Extensions/AJPan/eliesat-panel ]; then
#config
plugin=eliesatpanel
url=https://gitlab.com/eliesat/extensions/-/raw/main/ajpanel/eliesatpanel.tar.gz
package=/var/volatile/tmp/$plugin.tar.gz
wget -O $package --no-check-certificate $url
tar -xzf $package -C /
rm -rf $package >/dev/null 2>&1
fi

echo "> done"
sleep 3s
exit 0

