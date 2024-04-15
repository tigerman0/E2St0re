#!/bin/sh

# Configuration
plugin="ipaudio"
version="1.1"
package="enigma2-plugin-extensions-ipaudiopro"
temp_dir="/tmp"

#determine plugin url based on image version and device arch
urlarm="https://gitlab.com/eliesat/extensions/-/raw/main/ipaudiopro/arm"
urlmips="https://gitlab.com/eliesat/extensions/-/raw/main/ipaudiopro/mips"

arch=$(uname -m)
python=$(python -c "import platform; print(platform.python_version())")

case $python in 
3.9.7|3.9.9)
if [ "$arch" == "mips" ]; then
url1="$urlmips"
targz_file="$plugin-py3.9-$version.tar.gz"
elif [ "$arch" == "armv7l" ]; then
url1="$urlarm"
targz_file="$plugin-py3.9-$version.tar.gz"
fi
;;

3.11.0|3.11.1|3.11.2|3.11.3|3.11.4|3.11.5|3.11.6)
if [ "$arch" == "mips" ]; then
url1="$urlmips"
targz_file="$plugin-py3.11-$version.tar.gz"
elif [ "$arch" == "armv7l" ]; then
url1="$urlarm"
targz_file="$plugin-py3.11-$version.tar.gz"
fi
;;

3.12.1|3.12.2|3.12.3)
if [ "$arch" == "mips" ]; then
url1="$urlmips"
targz_file="$plugin-py3.12-$version.tar.gz"
exit 1 
elif [ "$arch" == "armv7l" ]; then
url1="$urlarm"
targz_file="$plugin-py3.12-$version.tar.gz"
fi
;;

*)
echo "> your image python version: $python is not supported"
sleep 3
exit 1
;;
esac
url="$url1"/"$targz_file"

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
if [ -d /usr/lib/enigma2/python/Plugins/Extensions/IPaudioPro ]; then
echo "> removing package old version please wait..."
sleep 3
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/IPaudioPro > /dev/null 2>&1

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
deps=("wget")
if [ "$pyVersion" = 3 ]; then
  deps+=("alsa-plugins" "libasound2" "libavcodec60" "libavformat60" "libc6" "libgcc1" "libpython3.12-1.0" "libstdc++6" "python3-core" "python3-cryptography")
else
echo "> your device is not supported"
sleep 3
exit 1
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
echo "> Uploaded By ElieSat"
else
echo "> $plugin-$version package installation failed"
sleep 3
fi
    