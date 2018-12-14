#!/bin/bash
### Install/uninstall packages ###
sudo apt update -y && \
sudo apt purge -y wolfram-engine scratch minecraft-pi sonic-pi dillo gpicview libreoffice* && \
sudo apt install libcurl4-openssl-dev libx11-dev libxt-dev libimlib2-dev libxinerama-dev libjpeg-progs && \
sudo apt install vim -y && \
sudo apt install postfix -y && \
sudo apt install libmagickwand-dev -y && \
sudo apt install omxplayer -y && \
sudo apt install feh -y && \
sudo apt install xterm -y && \
sudo apt install xscreensaver -y && \
sudo apt install realvnc-vnc-server realvnc-vnc-viewer -y && \
sudo apt clean -y && \
sudo apt autoremove -y && \
sudo pip install -r requirements.txt

### Configure HDMI Output ###
# hdmi_force_hotplug=1 Forces to display through HDMI event if no HDMI screen is detected.
# hdmi_drive=2	Trying to use HDMI mode rather than DVI mode
# config_hdmi_boost=4 Increase the signal to HDMI
# disable overscan to remove black boundary around the screen
sudo sed -i 's/#hdmi_force_hotplug=1/hdmi_force_hotplug=1/g' /boot/config.txt
sudo sed -i 's/#hdmi_drive=2/hdmi_drive=2/g' /boot/config.txt
sudo sed -i 's/#config_hdmi_boost=4/config_hdmi_boost=4/g' /boot/config.txt
sudo sed -i 's/#disable_overscan=1/disable_overscan=1/g' /boot/config.txt

### Find best resolution of the monitor
RES=`tvservice -d edid >/dev/null; edidparser edid | egrep 'HDMI:EDID (DMT|CEA) mode' | awk '{ print $NF,$0 }' |sort -k1,1 -n -r | sed -e 's/.*HDMI:EDID \(.*\) mode (\(.*\)).*/\1 \2/' | sed -n 1p`
RES=`echo $RES | sed 's/CEA/1/g'`
RES=`echo $RES | sed 's/DMT/2/g'`
HDMI_GROUP=`echo $RES | cut -f1 -d ' '`
HDMI_MODE=`echo $RES | cut -f2 -d ' '`
sudo sed -i -E "s/#?hdmi_group.*/hdmi_group=$HDMI_GROUP/g" /boot/config.txt
sudo sed -i -E "s/#?hdmi_mode.*/hdmi_mode=$HDMI_MODE/g" /boot/config.txt

### Turn off HDMI signal when RPi sleeps
if ! grep -Fxq 'hdmi_blanking=1' /boot/config.txt; then
    sudo sed -i '$a# Stop HDMI when RPI is off' /boot/config.txt
    sudo sed -i '$ahdmi_blanking=1' /boot/config.txt
fi

### Turn off Console Screen Blanking ###
if ! grep -Fxq 'consoleblank=0' /boot/cmdline.txt; then
    sudo sed -i '$s/$/ consoleblank=0/' /boot/cmdline.txt
fi

### Disable Blank Screen ###
# 1) don't activate screensaver; disable DPMS (Energy Star) features; don't blank the video device
if ! grep -Fxq '@xset s off' /etc/xdg/lxsession/LXDE-pi/autostart; then
    sudo sed -i '$a@xset s off' /etc/xdg/lxsession/LXDE-pi/autostart
    sudo sed -i '$a@xset -dpms' /etc/xdg/lxsession/LXDE-pi/autostart
    sudo sed -i '$a@xset s noblank' /etc/xdg/lxsession/LXDE-pi/autostart
fi
# 2) Add following lines to 2nd last line
# setterm -blank 0 -powersave off -powerdown 0
SETTING='setterm -blank 0 -powersave off -powerdown 0'
if ! grep -Fxq "$SETTING" /etc/rc.local; then
	sudo sed -i '$i#Stop monitor from blank-off' /etc/rc.local
	sudo sed -i "\$i$SETTING\n" /etc/rc.local
fi

### Disable xscreensaver
# Done through crontab

### Setup public key authentication ###
if ! grep -q "raspberry pi" ~/.ssh/authorized_keys; then
    mkdir -p ~/.ssh
    # Download public key from GitHub
    wget -O ~/.ssh/key_pi.pub 'https://raw.githubusercontent.com/qinjie/raspberry-pi-public-key/master/key_pi.pub'
    # Transfer existing public key, e.g. ‘key_pi.pub’, to .ssh folder
    cat ~/.ssh/key_pi.pub >> ~/.ssh/authorized_keys
fi
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

### Import Cron jobs from file
sudo apt install tofrodos
fromdos crontab.txt
crontab crontab.txt
### Enable Cron logging
if ! grep -Fxq '#cron.' /etc/rsyslog.conf; then
	sudo sed -i 's/#cron./cron./g' /etc/rsyslog.conf
fi
sudo /etc/init.d/rsyslog restart
sudo service cron reload

### Change hostname to be RPI unique serial number
HOSTNAME=`cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2`
echo $HOSTNAME | sudo tee /etc/hostname
sudo sed -i "s/raspberrypi/$HOSTNAME/g" /etc/hosts


# Reboot for changes to take effect
sudo reboot
