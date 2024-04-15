#!/bin/sh

# Configuration
plugin="subssupport"
version="1.7.0r3"
targz_file="$plugin-$version.tar.gz"
package="enigma2-plugin-softcams-subssupport"
temp_dir="/tmp"
python=$(python -c "import platform; print(platform.python_version())")
case $python in 
3.9.9|3.11.0|3.11.1|3.11.2|3.11.3|3.11.5|3.11.5|3.11.6|3.12.1|3.12.2)
url="https://gitlab.com/eliesat/extensions/-/raw/main/subssupport/subssupport-1.7.0r3.tar.gz"
sleep 3
;;
*)
echo "> your image python version: $python is not supported"
sleep 3
exit 1
;;
esac

# Determine package manager
if command -v dpkg &> /dev/null; then
package_manager="apt"
status_file="/var/lib/dpkg/status"
uninstall_command="apt-get purge --auto-remove -y"
else
package_manager="opkg"
status_file="/var/lib/opkg/status"
uninstall_command="opkg remove --force-depends"
fi

check_and_remove_package() {
if [ -d /usr/lib/enigma2/python/Plugins/Extensions/SubsSupport ]; then
echo "> removing package old version please wait..."
sleep 3
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/SubsSupport > /dev/null 2>&1

if grep -q "$package" "$status_file"; then
echo "> Removing existing $package package, please wait..."
$uninstall_command $package
fi
echo "*******************************************"
echo "*             Removed Finished            *"
echo "*            Uploaded By Eliesat          *"
echo "*******************************************"
sleep 3
exit 1
else
echo " " 
fi  }
check_and_remove_package

#check and install dependencies
echo "> checking dependencies please wait ..."
sleep 3
# Check python
pyVersion=$(python -c"from sys import version_info; print(version_info[0])")

deps=("unrar" "perl-module-io-zlib")

if [ "$pyVersion" = 3 ]; then
  deps+=( "python3-codecs" "python3-compression" "python3-core" "python3-difflib" "python3-json" "python3-requests" "python3-xmlrpc" )
else
deps+=( "python-codecs" "python-compression" "python-core" "python-difflib" "python-json" "python-requests" "python-xmlrpc" )
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

#download & install package
echo "> Downloading $plugin-$version package  please wait ..."
sleep 3
wget -O $temp_dir/$targz_file --no-check-certificate $url
tar -xzf $temp_dir/$targz_file -C /
extract=$?
rm -rf $temp_dir/$targz_file >/dev/null 2>&1

echo ''
if [ $extract -eq 0 ]; then
echo "> $plugin-$version package installed successfully"
sleep 3

echo "> Setup the plugin..."
# Configure ajpanel_settings
touch "$temp_dir/temp_file"
cat <<EOF > "$temp_dir/temp_file"
config.plugins.subtitlesSupport.encodingsGroup=Arabic
config.plugins.subtitlesSupport.external.font.size=52
config.plugins.subtitlesSupport.search.edna_cz.enabled=False
config.plugins.subtitlesSupport.search.itasa.enabled=False
config.plugins.subtitlesSupport.search.lang1=ar
config.plugins.subtitlesSupport.search.lang2=ar
config.plugins.subtitlesSupport.search.lang3=ar
config.plugins.subtitlesSupport.search.mysubs.enabled=False
config.plugins.subtitlesSupport.search.opensubtitles.enabled=False
config.plugins.subtitlesSupport.search.podnapisi.enabled=False
config.plugins.subtitlesSupport.search.prijevodionline.enabled=False
config.plugins.subtitlesSupport.search.serialzone_cz.enabled=False
config.plugins.subtitlesSupport.search.subscene.enabled=False
config.plugins.subtitlesSupport.search.subtitles_gr.enabled=False
config.plugins.subtitlesSupport.search.subtitlist.enabled=False
config.plugins.subtitlesSupport.search.titlovi.enabled=False
config.plugins.subtitlesSupport.search.titulky_com.enabled=False
EOF

# Update Enigma2 settings
sed -i "/subtitlesSupport/d" /etc/enigma2/settings
grep "config.plugins.subtitlesSupport.*" "$temp_dir/temp_file" >> /etc/enigma2/settings
rm -rf "$temp_dir/temp_file" >/dev/null 2>&1

sleep 2
echo "> Setup done..., Please wait enigma2 restarting..."
sleep 1
echo "> Uploaded By ElieSat"

# Restart Enigma2 service or kill enigma2 based on the system
if [ -f /etc/apt/apt.conf ]; then
    sleep 2
    systemctl restart enigma2
else
    sleep 2
    killall -9 enigma2
fi
else
echo "> $plugin-$version package installation failed"
sleep 3
fi
    