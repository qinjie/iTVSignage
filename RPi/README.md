# TODO
* Setup crontab
    - On off screen every 5 minutes
    - script_setup on reboot
    - script_sync on every 1 minute
    - script_play on 2 minutes after reboot
    - script_update_ip to dropbox every hour
* Configure RPi
    - disable power saving
    - disable screen saver
* Other RPi setup
    - using key pair for ssh
    - install vnc and disable it
* Allow user to add one background picture for each playlist
* Add account profile for user
    - free account: max 1 device, max 20 file per playlist, no limit on number of playlist  

# Server Setup
    AWS EC2 Server
    http://13.228.113.29/WiredNoticeboard/frontend/web/
    http://13.228.113.29/phpmyadmin
    
    * FTP into 13.228.113.29
    * Transfer web folder to /var/www/html
    * Run   
    
## Rasberry Pi Setup
e.g. Python packages, wifi setup, power saving config

### Install required softwares
1. Install software packages
    ```` 
    sudo apt-get update
    sudo pip install requests
    sudo pip install Wand
    sudo apt-get install feh
    sudo apt-get install omxplayer
    sudo pip install dropbox
    
    sudo apt-get install xterm
    
    sudo apt-get install libmagickwand-dev
    ````
        
2. Disable power saving mode of Raspberry Pi
    http://raspberrypi.stackexchange.com/questions/34794/how-to-disable-wi-fi-dongle-sleep-mode

3. Disable screen saver
    http://www.etcwiki.org/wiki/Disable_screensaver_and_screen_blanking_Raspberry_Pi
    http://www.geeks3d.com/hacklab/20160108/how-to-disable-the-blank-screen-on-raspberry-pi-raspbian/
    
4. Setup crontab. Refer to crontab.txt file for jobs
    http://www.adminschoice.com/crontab-quick-reference
   
   Must setup crontab to use DISPLAY=0.0
   ```
   DISPLAY=:0.0 python script_play.py
   ```
   
5. Install vnc for easy management of RPi
     http://raspberrypi.stackexchange.com/questions/34794/how-to-disable-wi-fi-dongle-sleep-mode

## Project Setup
, e.g. project folders, Crontab setup 

# Web Service in Use


# Script Workflow
1. Get file list in play order into file_list.txt
2. Download files into "download" folders
3. For each file in file_list with index i
	Get file from download folder
	If it's a image file, copy to "pictures" folder and rename it as "<i>_<filename>"
	If it's a pdf file, export it as images to "pictures" foder with name "<i>_<filename>_<page>"
	If it's video file, copy it to "videos" folder
4. Run Feh with slide show
5. Play video files


# Technical Knowledge

## How to programmatically turn on and off monitor
https://gist.github.com/simlun/1b27b14d707abbba8fc1

##Installation

#### note: imagemagick@7 doesn't work with python yet
brew install imagemagick@6
ls -l /usr/local/Cellar/imagemagick@6
ln -s /usr/local/Cellar/imagemagick@6/<your specific 6 version>/lib/libMagickWand-6.Q16.dylib /usr/local/lib/libMagickWand.dylib


Tool For Image Slide Show
    https://feh.finalrewind.org/


