#!/bin/bash

# Check for mounted storage
msp="/media/hdd"
    if [ -d "$msp" ]; then 
    echo "> Mounted storage found at: $msp"
    sleep 3
    
# Functions
print_message() {
echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

cleanup() {
[ -d "/CONTROL" ] && rm -rf /CONTROL >/dev/null 2>&1
rm -rf /control /postinst /preinst /prerm /postrm /tmp/*.ipk /tmp/*.tar.gz /tmp/panels.tar.gz >/dev/null 2>&1
print_message "Cleanup completed."
}

#download and install ajpanel menus and icons
panel_dir="/media/hdd/Ajpanel_Eliesatpanel"

for ajpanel_menu in "ajpanel_menu_HA.xml" "ajpanel_menu_Emil.xml" "ajpanel_menu_Haitham.xml" "ajpanel_menu_biko_73.xml" "ajpanel_menu_Tarek.xml"
do

print_message "> downloading & installing $ajpanel_menu please wait ..."
sleep 3
case $ajpanel_menu in
ajpanel_menu_biko_73.xml) 
url=https://github.com/biko-73/AjPanel/raw/main/ajpanel_menu_biko_73.xml
;;
ajpanel_menu_Emil.xml) 
url=https://gitlab.com/eliesat/extensions/-/raw/main/ajpanel/eliesatpanel/ajpanel_menu_Emil.xml
;;
ajpanel_menu_Haitham.xml) 
url=https://gitlab.com/hmeng80/AjPanel/-/raw/main/ajpanel_menu_Haitham.xml
;;
ajpanel_menu_HA.xml) 
url=https://github.com/Ham-ahmed/Secript-panel/raw/main/ajpanel_menu_HA.xml
;;
ajpanel_menu_Tarek.xml) 
url=https://github.com/tarekzoka/ajpanel/raw/main/ajpanel_menu_Tarek.xml
;;
esac

wget --show-progress -qO $panel_dir/$ajpanel_menu --no-check-certificate $url
done

print_message "> downloading & installing panels icons please wait ..."
sleep 3
url="https://gitlab.com/eliesat/extensions/-/raw/main/ajpanel/eliesatpanel"
temp_dir="/tmp"
targz_file="panels.tar.gz"
wget --show-progress -qO $temp_dir/$targz_file $url/$targz_file
tar -xzf /tmp/panels.tar.gz -C /

if [ $? -eq 0 ]; then
print_message "> panels installed successfully."
else
print_message "> Installation failed."
exit 1
fi

# Main
trap cleanup EXIT
     
     else
     echo "> mount your externel storage to $msp and try again..."
     fi
   
