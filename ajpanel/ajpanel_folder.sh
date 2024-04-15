#!/bin/bash

#check mounted storage
echo "> checking mounted storage please wait..."
sleep 3s
msp=("/media/hdd" "/media/usb" "/media/usb" "/")

for ms in "${msp[@]}"; do
if [ -d "$ms" ]; then
echo 
break
fi
done

echo "> creating ajpanel folders in "$ms"/Ajpanel_Eliesatpanel path please wait..."
sleep 3s
if [ -d "$ms/Ajpanel_Eliesatpanel" ]; then
echo ""
else
mkdir $ms/Ajpanel_Eliesatpanel >/dev/null 2>&1
for folder in "create-package-files" "downloaded-packages" "exported-picons" "exported-tables"
do
mkdir $ms/Ajpanel_Eliesatpanel/$folder >/dev/null 2>&1
done
fi

echo "> creating ajpanel update file in "$ms"/Ajpanel_Eliesatpanel path please wait..."
sleep 3s
touch $ms/Ajpanel_Eliesatpanel/ajpanel_update_url
echo "https://raw.githubusercontent.com/biko-73/AjPanel/main/" > $ms/Ajpanel_Eliesatpanel/ajpanel_update_url




exit 0