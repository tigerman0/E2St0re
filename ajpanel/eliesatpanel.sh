#!/bin/sh

cleanup() {
    # Cleanup temporary files
    rm -rf $package $ms/Ajpanel_Eliesatpanel/ajpanel_settings >/dev/null 2>&1
}

trap cleanup EXIT

# Determine the package manager and system type
if [ -f /etc/apt/apt.conf ]; then
    status='/var/lib/dpkg/status'
    it=DreamOs
    apt install wget >/dev/null 2>&1
else
    status='/var/lib/opkg/status'
    it=OpenSource
    opkg install wget >/dev/null 2>&1
fi

# Remove unnecessary files and folders
[ -d "/CONTROL" ] && rm -r /CONTROL >/dev/null 2>&1
rm -rf /control /postinst /preinst /prerm /postrm /tmp/*.ipk /tmp/*.tar.gz >/dev/null 2>&1

echo ""
echo "> Checking mounted storage, please wait..."
sleep 3

# Check for mounted storage
msp=("/data" "/media/hdd" "/media/usb" "/media/usb" "/")
for ms in "${msp[@]}"; do
    if [ -d "$ms" ]; then
        echo "> Mounted storage found at: $ms"
        break
    fi
done

# Create Ajpanel_Eliesatpanel directory if not exists
if [ ! -d "$ms/Ajpanel_Eliesatpanel" ]; then
    mkdir -p $ms/Ajpanel_Eliesatpanel
    for folder in "create-package-files" "downloaded-packages" "exported-picons" "exported-tables"; do
        mkdir -p $ms/Ajpanel_Eliesatpanel/$folder
    done
fi

# Set up update URL
echo "https://raw.githubusercontent.com/biko-73/AjPanel/main/" > $ms/Ajpanel_Eliesatpanel/ajpanel_update_url

echo ""
echo "> Downloading & installing eliesatpanel, For $it images please wait..."
sleep 5

# Download and install ajpanel
plugin=ajpanel
version=9.3.1
url=https://gitlab.com/eliesat/extensions/-/raw/main/ajpanel/$plugin-$version.tar.gz
package=/var/volatile/tmp/$plugin-$version.tar.gz
wget --show-progress -qO $package --no-check-certificate $url
tar -xzf $package -C /
extract=$?
rm -rf $package >/dev/null 2>&1

echo ""
if [ $extract -eq 0 ]; then
    echo "> $plugin-$version package installed successfully"
    sleep 3
else
    echo "> $plugin-$version package installation failed"
    sleep 3
fi

# Download ajpanel_cmd
pack="ajpanel_cmd"
package=$ms/Ajpanel_Eliesatpanel/$pack
url=https://gitlab.com/eliesat/extensions/-/raw/main/ajpanel/ajpanel_cmd
wget --show-progress -qO $package --no-check-certificate $url

# Download and install eliesatpanel
plugin=eliesatpanel
url=https://gitlab.com/eliesat/extensions/-/raw/main/ajpanel/eliesatpanel.tar.gz
package=/var/volatile/tmp/$plugin.tar.gz
wget --show-progress -qO $package --no-check-certificate $url
tar -xzf $package -C /
extract=$?
rm -rf $package >/dev/null 2>&1

if [ $extract -eq 0 ]; then
    # Configure ajpanel_menu.xml
    espp=$(grep config.plugins.AJPanel.backupPath /etc/enigma2/settings | cut -d '=' -f 2)
    ajpanel_menu="ajpanel_menu.xml"
    ajpanel_menu_path="$espp$ajpanel_menu"
    ajpanel_menu_url="https://gitlab.com/eliesat/extensions/-/raw/main/ajpanel/ajpanel_menu.xml?inline=false"
    wget --show-progress -qO $ajpanel_menu_path --no-check-certificate "$ajpanel_menu_url"

    echo ""
    echo "> $plugin package installed successfully"
    echo "> Uploaded By ElieSat"
    sleep 3
else
    echo "> $plugin package installation failed"
    sleep 3
fi

# Get system image version
if [ -f /etc/image-version ]; then
    image=$(grep -iF "creator" /etc/image-version | cut -d "=" -f 2 | xargs)
elif [ -f /etc/issue ]; then
    image=$(awk '{print $1;}' /etc/issue)
else
    image=''
fi

[ ! -z "$image" ] && echo -e "> image: $image"
sleep 3

# Configure Enigma2 settings based on system image
case $image in
    openpli)
        button=config.misc.hotkey.next=Plugins/Extensions/AJPan/8 ;;
    *)
        button=config.misc.ButtonSetup.next=Plugins/Extensions/AJPan/8
        ;;
esac

sleep 1
echo "$button" >> /etc/enigma2/settings

sleep 3
echo "> Setup the plugin..."
# Configure ajpanel_settings
touch "$ms/Ajpanel_Eliesatpanel/ajpanel_settings"
cat <<EOF > "$ms/Ajpanel_Eliesatpanel/ajpanel_settings"
config.plugins.AJPanel.backupPath=$ms/Ajpanel_Eliesatpanel/
config.plugins.AJPanel.browserBookmarks=/usr/lib/enigma2/python/Plugins/Extensions/,/tmp/,/
config.plugins.AJPanel.browserStartPath=/hdd/
config.plugins.AJPanel.checkForUpdateAtStartup=True
config.plugins.AJPanel.downloadedPackagesPath=$ms/Ajpanel_Eliesatpanel/downloaded-packages/
config.plugins.AJPanel.exportedPIconsPath=$ms/Ajpanel_Eliesatpanel/exported-picons/
config.plugins.AJPanel.exportedTablesPath=$ms/Ajpanel_Eliesatpanel/exported-tables/
config.plugins.AJPanel.FileManagerExit=e
config.plugins.AJPanel.hideIptvServerChannPrefix=True
if [ "$it" == DreamOS ]; then
    config.plugins.AJPanel.iptvAddToBouquetRefType=8193
else
    config.plugins.AJPanel.iptvAddToBouquetRefType=5002
fi
config.plugins.AJPanel.lastFeedPkgsDir=/hdd/dreamsatpanel/13-sport/
config.plugins.AJPanel.lastFileManFindSrt=/tmp
config.plugins.AJPanel.lastPkgProjDir=/etc/enigma2/MyMetrixLiteBackup.dat
config.plugins.AJPanel.lastTerminalCustCmdLineNum=307
config.plugins.AJPanel.packageOutputPath=$ms/Ajpanel_Eliesatpanel/create-package-files/
if [ "$it" == DreamOS ]; then
    config.plugins.AJPanel.PIconsPath=$ms/picon/
else
    config.plugins.AJPanel.PIconsPath=/media/hdd/picon/
fi
config.plugins.AJPanel.screenshotFType=png
config.plugins.AJPanel.subtBGTransp=60
config.plugins.AJPanel.subtDelaySec=-1
config.plugins.AJPanel.subtShadowColor=#FF0000
config.plugins.AJPanel.subtTextFg=#FFFF00
EOF

# Update Enigma2 settings
sed -i '/config.plugins.AJPanel../d' /etc/enigma2/settings
grep "config.plugins.AJPanel.*" "$ms/Ajpanel_Eliesatpanel/ajpanel_settings" >> /etc/enigma2/settings
rm -rf "$ms/Ajpanel_Eliesatpanel/ajpanel_settings" >/dev/null 2>&1

sleep 2
echo "> Setup done..., please wait enigma2 restarting..."

# Restart Enigma2 service or kill enigma2 based on the system
if [ "$it" == DreamOS ]; then
    sleep 2
    systemctl restart enigma2
else
    sleep 2
    killall -9 enigma2
fi

#exit 0
