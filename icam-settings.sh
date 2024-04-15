#!/bin/sh

#config
package=icam-settings
version=1.2

#preinst: Ein Shell Script welches vor Installation des Paketes ausgeführt wird
# type -> 0 = "Ja|Nein" (sinnlos); 1 = Popup; 2 = MessageBox , für Message senden , abfragen typ verwenden
# wenn mit exit 1 abgebrochen wird der installations zustand in var/lib/opkg/status geschrieben , die vorher sichern und zurück schreiben
                                      
set -e

LOGDIR=/tmp
LOGFILE=$LOGDIR/plugin_preinst.log
##########
# Generelles Logging.
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>$LOGFILE 2>&1

## variables ##
BOXIP="http://localhost"
#BOXIP=192.168.178.112
DATE="$(date +%a.%d.%b.%Y-%H:%M)"



#remove old package#

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

wget -O /var/volatile/tmp/"$package"-"$version".tar.gz --no-check-certificate "https://gitlab.com/eliesat/extensions/-/raw/main/"$package"-"$version".tar.gz"

echo "> Installing "$package" "$version" Package  Please Wait ..."
sleep 3s


#extract new package#
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

BOXIP="http://localhost"
TMP=/tmp
DATE="$(date +%a.%d.%b.%Y-%H:%M)"
MESSAGES="message*"





cp -pr /tmp/bouquets/* /etc/enigma2/ 
cp -pr /etc/enigma2/bouquets.tv /tmp/
sleep 5




exec 9>> /tmp/bouquets.tv
echo '#SERVICE 1:7:1:0:0:0:0:0:0:0:FROM BOUQUET "userbouquet.dazn.tv" ORDER BY bouquet' >&9
echo '#SERVICE 1:7:1:0:0:0:0:0:0:0:FROM BOUQUET "userbouquet.skybundesliga.tv" ORDER BY bouquet' >&9
echo '#SERVICE 1:7:1:0:0:0:0:0:0:0:FROM BOUQUET "userbouquet.skydoku.tv" ORDER BY bouquet' >&9
echo '#SERVICE 1:7:1:0:0:0:0:0:0:0:FROM BOUQUET "userbouquet.skysport.tv" ORDER BY bouquet' >&9
echo '#SERVICE 1:7:1:0:0:0:0:0:0:0:FROM BOUQUET "userbouquet.skyeurosport.tv" ORDER BY bouquet' >&9
echo '#SERVICE 1:7:1:0:0:0:0:0:0:0:FROM BOUQUET "userbouquet.skysportaustria.tv" ORDER BY bouquet' >&9
echo '#SERVICE 1:7:1:0:0:0:0:0:0:0:FROM BOUQUET "userbouquet.skyfilm.tv" ORDER BY bouquet' >&9
echo '#SERVICE 1:7:1:0:0:0:0:0:0:0:FROM BOUQUET "userbouquet.skykinder.tv" ORDER BY bouquet' >&9
echo '#SERVICE 1:7:1:0:0:0:0:0:0:0:FROM BOUQUET "userbouquet.skyserien.tv" ORDER BY bouquet' >&9
echo '#SERVICE 1:7:1:0:0:0:0:0:0:0:FROM BOUQUET "userbouquet.skysportaustria.tv" ORDER BY bouquet' >&9
echo '#SERVICE 1:7:1:0:0:0:0:0:0:0:FROM BOUQUET "userbouquet.skymusik.tv" ORDER BY bouquet' >&9




cp -pr /tmp/bouquets.tv /etc/enigma2/bouquets.tv

wget -q -O - http://root%s@127.0.0.1/web/servicelistreload?mode=0 && sleep 2

sleep 5

exit 0