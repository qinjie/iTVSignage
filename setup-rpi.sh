#!/bin/bash

sudo apt update -y && \
sudo apt purge -y wolfram-engine scratch minecraft-pi sonic-pi dillo gpicview libreoffice* && \
sudo apt clean -y && \
sudo apt autoremove -y && \
sudo apt install vim -y && \
sudo apt install postfix -y && \
sudo apt install libmagickwand-dev -y && \
sudo apt install omxplayer -y && \
sudo apt install feh -y && \
sudo apt install xterm -y && \
sudo apt install xscreensaver -y && \
sudo apt install realvnc-vnc-server realvnc-vnc-viewer -y && \
sudo pip install -r requirements.txt

### Configure HDMI Output ###
# hdmi_force_hotplug=1 Forces to display through HDMI event if no HDMI screen is detected. 
# hdmi_drive=2	Trying to use HDMI mode rather than DVI mode
# config_hdmi_boost=4 Increase the signal to HDMI
sudo sed -i 's/#hdmi_force_hotplug=1/hdmi_force_hotplug=1/g' /boot/config.txt
sudo sed -i 's/#hdmi_drive=2/hdmi_drive=2/g' /boot/config.txt
sudo sed -i 's/#config_hdmi_boost=4/config_hdmi_boost=4/g' /boot/config.txt

# Modify following two value to change HDMI Resolution
# https://www.raspberrypi.org/documentation/configuration/config-txt/video.md 
	#hdmi_group=2
	#hdmi_mode=28

### Disable Blank Screen ###
# Add following lines to 2nd last line
	# #Stop monitor from blank-off
	# setterm -blank 0 -powersave off -powerdown 0
SETTING='setterm -blank 0 -powersave off -powerdown 0'
if ! grep -Fxq "$SETTING" /etc/rc.local; then
	sudo sed -i '$i#Stop monitor from blank-off' /etc/rc.local
	sudo sed -i "\$i$SETTING\n" /etc/rc.local
fi

### Change hostname to be RPI unique serial number
HOSTNAME=`cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2`
echo $HOSTNAME | sudo tee /etc/hostname
sudo sed -i "s/raspberrypi/$HOSTNAME/g" /etc/hosts
sudo reboot now

### Setup VNC server and viewer ###
sudo raspi-config
# Select Interfacing Options > VNC > Yes

### Setup public key authentication ###
mkdir -p ~/.ssh
# Transfer existing public key, e.g. ‘key_pi.pub’, to .ssh folder
#cat ~/.ssh/key_pi.pub >> ~/.ssh/authorized_keys
#sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config


