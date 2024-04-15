#!/bin/sh

if [ -d /usr/lib/enigma2/python/Plugins/Extensions/IPAudio ]; then
echo "> removing package please wait..."
sleep 3s 
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/IPAudio > /dev/null 2>&1

status='/var/lib/opkg/status'
package='enigma2-plugin-extensions-ipaudio'

if grep -q $package $status; then
opkg remove $package > /dev/null 2>&1
fi

echo "*******************************************"
echo "*             Removed Finished            *"
echo "*            Uploaded By Eliesat          *"
echo "*******************************************"
sleep 3s

else

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
version=7.4
TEMPATH='/tmp'
PLUGINPATH='/usr/lib/enigma2/python/Plugins/Extensions/IPAudio'
CHECK='/tmp/check'
BINDIR='/usr/bin/'
ARMBIN='/tmp/ipaudio/bin/arm/gst1.0-ipaudio'
FFPPLAYERA='/tmp/ipaudio/bin/arm/ff4/ff-ipaudio'
MIPSBIN='/tmp/ipaudio/bin/mips/gst1.0-ipaudio'
FFPPLAYERM='/tmp/ipaudio/bin/mips/ff4/ff-ipaudio'
IPAUDIO='/tmp/ipaudio/usr/*'
PLAYLIST='/tmp/ipaudio/etc/ipaudio.json'
ASOUND='/tmp/ipaudio/etc/asound.conf'

uname -m >$CHECK

# kill player if in use
ps_out=$(ps -ef | grep gst1.0-ipaudio | grep -v 'grep' | grep -v $0)
result=$(echo $ps_out | grep "gst1.0-ipaudio")
if [[ "$result" != "" ]]; then
        killall -9 gst1.0-ipaudio
fi

ps_out=$(ps -ef | grep ff-ipaudio | grep -v 'grep' | grep -v $0)
result=$(echo $ps_out | grep "ff-ipaudio")
if [[ "$result" != "" ]]; then
        killall -9 ff-ipaudio
fi

# check depends packges
if [ -f /var/lib/dpkg/status ]; then
        STATUS='/var/lib/dpkg/status'
        OS='DreamOS'
else
        STATUS='/var/lib/opkg/status'
        OS='Opensource'
fi

if grep -q 'gstreamer1.0-plugins-base-volume' $STATUS; then
        gstVol='Installed'
fi

if grep -q 'gstreamer1.0-plugins-good-ossaudio' $STATUS; then
        gstOss='Installed'
fi

if grep -q 'gstreamer1.0-plugins-good-mpg123' $STATUS; then
        gstMp3='Installed'
fi

if grep -q 'gstreamer1.0-plugins-good-equalizer' $STATUS; then
        equalizer='Installed'
fi

if grep -q 'ffmpeg' $STATUS; then
        ffmpeg='Installed'
fi

if grep -q 'alsa-plugins' $STATUS; then
        alsaPlug='Installed'
fi

if [ "$gstVol" = "Installed" ] && [ "$gstOss" = "Installed" ] && [ "$gstMp3" = "Installed" ] && [ "$equalizer" = "Installed" ] && [ "$ffmpeg" = "Installed" ] && [ "$alsaPlug" = "Installed" ]; then
        echo ""
else
        if [ $OS = "DreamOS" ]; then
                echo "=========================================================================="
                echo "Some Depends Need to Be downloaded From Feeds ...."
                echo "=========================================================================="
                echo "apt update ..."
                echo "========================================================================"
                apt-get update
                echo " Downloading gstreamer1.0-plugins-base-volume ......"
                apt-get install gstreamer1.0-plugins-base-volume -y
                echo "========================================================================"
                echo " Downloading gstreamer1.0-plugins-good-ossaudio ......"
                apt-get install gstreamer1.0-plugins-good-ossaudio -y
                echo "========================================================================"
                echo " Downloading gstreamer1.0-plugins-good-mpg123 ......"
                apt-get install gstreamer1.0-plugins-good-mpg123 -y
                echo "========================================================================"
                echo " Downloading gstreamer1.0-plugins-good-equalizer ......"
                apt-get install gstreamer1.0-plugins-good-equalizer -y
                echo "========================================================================"
                echo " Downloading ffmpeg ......"
                apt-get install ffmpeg -y
                echo "========================================================================"
                echo " Downloading alsa-plugins ......"
                apt-get install alsa-plugins -y
                echo "========================================================================"
        else
                echo "=========================================================================="
                echo "Some Depends Need to Be downloaded From Feeds ...."
                echo "=========================================================================="
                echo "Opkg Update ..."
                echo "========================================================================"
                opkg update
                echo " Downloading gstreamer1.0-plugins-base-volume ......"
                opkg install gstreamer1.0-plugins-base-volume
                echo "========================================================================"
                echo " Downloading gstreamer1.0-plugins-good-ossaudio ......"
                opkg install gstreamer1.0-plugins-good-ossaudio
                echo "========================================================================"
                echo " Downloading gstreamer1.0-plugins-good-mpg123 ......"
                opkg install gstreamer1.0-plugins-good-mpg123
                echo "========================================================================"
                echo " Downloading gstreamer1.0-plugins-good-equalizer ......"
                opkg install gstreamer1.0-plugins-good-equalizer
                echo "========================================================================"
                echo " Downloading ffmpeg ......"
                opkg install ffmpeg
                echo "========================================================================"
                echo " Downloading alsa-plugins ......"
                opkg install alsa-plugins
                echo "========================================================================"
        fi
fi

if grep -q 'gstreamer1.0-plugins-base-volume' $STATUS; then
        echo ""
else
        echo "#########################################################"
        echo "#  gstreamer1.0-plugins-base-volume Not found in feed   #"
        echo "#         IPaudio has not been installed                #"
        echo "#########################################################"
        rm -r /tmp/ipaudio >/dev/null 2>&1
        rm -f $CHECK >/dev/null 2>&1
        exit 1
fi

if grep -q 'alsa-plugins' $STATUS; then
        echo ""
else
        echo "#########################################################"
        echo "#         alsa-plugins Not found in feed                #"
        echo "#         IPaudio has not been installed                #"
        echo "#########################################################"
        rm -r /tmp/ipaudio >/dev/null 2>&1
        rm -f $CHECK >/dev/null 2>&1
        exit 1
fi

if grep -q 'ffmpeg' $STATUS; then
        echo ""
else
        echo "#########################################################"
        echo "#            FFmpeg Not found in feed                   #"
        echo "#         IPaudio has not been installed                #"
        echo "#########################################################"
        rm -r /tmp/ipaudio >/dev/null 2>&1
        rm -f $CHECK >/dev/null 2>&1
        exit 1
fi

ffmpeg_version=$(ffmpeg -version 2>&1 | sed -n "s/.* version \([^ ]*\).*/\1/p;")
IFS='.' read -r -a version_array <<<"$ffmpeg_version"
if [[ ${version_array[0]} -ge 5 ]]; then
        echo "[ FFmpeg 5 detected ]"
        FFPPLAYERA="/tmp/ipaudio/bin/arm/ff-ipaudio"
        FFPPLAYERM="/tmp/ipaudio/bin/mips/ff-ipaudio"
elif [[ "$ffmpeg_version" =~ ^n[4-9] ]]; then
        echo "[ FFmpeg 4 detected ]"

else
        echo "#########################################################"
        echo "#          FFmpeg version is below 4.x.x                #"
        echo "#         IPaudio has not been installed                #"
        echo "#########################################################"
        rm -r /tmp/ipaudio >/dev/null 2>&1
        rm -f $CHECK >/dev/null 2>&1
        exit 1
fi

# remove old version
rm -rf $PLUGINPATH >/dev/null 2>&1
rm -f /usr/bin/gst1.0-ipaudio >/dev/null 2>&1
rm -f /usr/bin/ff-ipaudio >/dev/null 2>&1

echo "> Downloading ipaudio-$version package  please wait ..."
sleep 3s

cd $TEMPATH
set -e
wget "https://gitlab.com/eliesat/extensions/-/raw/main/ipaudio/ipaudio-7.4-ffmpeg.tar.gz"

tar -xzf ipaudio-"$version"-ffmpeg.tar.gz -C /tmp
set +e
extract=$?
rm -f ipaudio-"$version"-ffmpeg.tar.gz
cd ..

if grep -qs -i 'mips' cat $CHECK; then
        echo "[ Your device is MIPS ]"
        cp -a $MIPSBIN $BINDIR
        cp -a $FFPPLAYERM $BINDIR
        chmod 0775 /usr/bin/gst1.0-ipaudio
        chmod 0775 /usr/bin/ff-ipaudio
elif grep -qs -i 'armv7l' cat $CHECK; then
        echo "[ Your device is armv7l ]"
        cp -a $ARMBIN $BINDIR
        cp -a $FFPPLAYERA $BINDIR
        chmod 0775 /usr/bin/gst1.0-ipaudio
        chmod 0775 /usr/bin/ff-ipaudio
else
        
        echo "> Your stb is not supported "
        
        rm -r /tmp/ipaudio
        rm -f $CHECK
        exit 1
        echo ""
fi

mkdir -p $PLUGINPATH
cp -r $IPAUDIO $PLUGINPATH

if [ ! -f /etc/enigma2/ipaudio.json ]; then
        cp -a $PLAYLIST /etc/enigma2
fi

if [ ! -f /etc/asound.conf ]; then
        echo "Sending asound.conf to /etc"
        cp -a $ASOUND /etc
fi

rm -r /tmp/ipaudio
rm -f $CHECK

echo ''
if [ $extract -eq 0 ]; then
echo "> ipaudio-$version package installed successfully"
echo "> Uploaded By ElieSat"
sleep 3s

else

echo "> ipaudio-$version package installation failed"
sleep 3s
fi

fi
exit 0
