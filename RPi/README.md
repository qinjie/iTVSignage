# TODO
* RPi Setup
    - using key pair for ssh
* Setup Crontab
    - On off screen every 5 minutes
    - script_setup on reboot
    - script_sync on every 1 minute
    - script_play on 2 minutes after reboot
    - script_update_ip to dropbox every hour
* Allow user to add one background picture for each playlist
* Add account profile for user
    - free account: max 1 device, max 20 file per playlist, no limit on number of playlist  

# Test Account
    Username: demo
    Password: Mylife!23


# Raspberry Pi Setup

## Prepare RPi
0. Setup headless connection
1. Setup Wifi
2. Setup key-pair authentication

3. Copy project files to RPi `/home/pi/project-wn` folder
    ```
    cd ~
    mkdir project-wn
    # copy files to project-wn folder
    cd project-wn
    chmod +x *.sh
    ```

## Install software
1. Run `setup_rpi.sh` to install software packages
    ```
    ./rpi_setup.sh
    ```

## Setup RPi
2. Configure <b>HDMI</b> output
    ```
    sudo vim /boot/config.txt
    ```
    * Uncomment `hdmi_force_hotplug=1` to force hot plugin of your screen
    * Uncomment `config_hdmi_boost=7` or higher value to boost output signal to HDMI
    * Append `hdmi_blanking=1` to turn off HDMI signal when RPi sleeps
    * ??? Uncomment `hdmi_drive=2` to make audio work in HDMI ??? make screen blank

3. Disable screen sleep and screen saver
    Ref http://www.raspberry-projects.com/pi/pi-operating-systems/raspbian/gui/disable-screen-sleep
    
    * With xscreensaver installed by `setup_rpi.sh`
    * Open Screensaver Preference GUI by `xscreensaver` temrinal command or from RPi Preferences
    * Select mode "Disable Screen Saver" on Display Modes tab

4. Configure VNC for easy remote management of RPi
    ```
    sudo raspi-config
    ```
    * Navigate to “Interface Options”
    * Select “VNC” and select “Yes”
    * Select “Finish” to exit raspi-config

5. Setup crontab by importing crontab.txt file
    ```
    crontab crontab.txt
    sudo service cron reload
    sudo vim /etc/rsyslog.conf
    # Uncommment the line "cron.*                          /var/log/cron.log"
    sudo /etc/init.d/rsyslog restart
    ```
    * To check log from cron
    `tail /var/log/cron.log`
    * If there is MTA error, install following to get error message.
    `sudo aptitude install postfix`     # Select local
    * Check error message in local mail
    `sudo tail -f /var/mail/pi`

6. Setup System Time
    * Add NTP Server
    ```
    sudo nano /etc/ntp.conf
    # Add "pool ntp.np.edu.sg iburst" below existing ntp server list.
    sudo /etc/init.d/ntp restart
    sudo dpkg-reconfigure tzdata        # Set timezone
    ```

7. Setup headless connection with public key
    * Import public key
    ```
    cd ~
    install -d -m 700 ~/.ssh        # create .ssh folder
    # copy public key "key_pi.pub" to .ssh folder
    cat key_pi.pub >> authorized_keys
    ```
    * Try to login using public key
    * If login is successful, disable password login
    ```
    sudo vim /etc/ssh/sshd_config
    # Update line "PasswordAuthentication no"
    sudo /etc/init.d/ssh restart
    ```
    
## Project Setup

### New device
1. 


# Web Server Setup
    AWS EC2 Server
    http://13.250.218.226/WiredNoticeboard/frontend/web/
    http://13.250.218.226/phpmyadmin

## API in Use





# Others

## Script Workflow
1. Get file list in play order into file_list.txt
2. Download files into "download" folders
3. For each file in file_list with index i
	Get file from download folder
	If it's a image file, copy to "pictures" folder and rename it as "<i>_<filename>"
	If it's a pdf file, export it as images to "pictures" foder with name "<i>_<filename>_<page>"
	If it's video file, copy it to "videos" folder
4. Run Feh with slide show
5. Play video files


## Tool For Image Slide Show
    https://feh.finalrewind.org/

## How to programmatically turn on and off monitor
https://gist.github.com/simlun/1b27b14d707abbba8fc1

## Installation on Mac
<bNote<b>: imagemagick@7 doesn't work with python yet
```
brew install imagemagick@6
ls -l /usr/local/Cellar/imagemagick@6
ln -s /usr/local/Cellar/imagemagick@6/<your specific 6 version>/lib/libMagickWand-6.Q16.dylib /usr/local/lib/libMagickWand.dylib
```

