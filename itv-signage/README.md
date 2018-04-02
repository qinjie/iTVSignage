# WiredNoticeboard-Web

##Installation Instruction

1. If you use remote server, SSH to server;
2. Go to ```/var/www/html``` (Root directory of Apache);
    * For a local server go to the document root of XAMPP/MAMP/LAMP (Named ```htdocs```);
3. Run ```git clone https://github.com/qinjie/WiredNoticeboard-Web.git```;
5. Go to WiredNoticeboard folder;
6. Database are configured in 
    * ```environments/dev/common/config/main-local.php```
    * ```environments/dev/common/config/params-local.php```
    * ```environments/prod/common/config/main-local.php```
    * ```environments/prod/common/config/params-local.php```    
7. Run ```php init``` to initialize environment
8. Run ```chmod -R 777 api/runtime api/web/assets``` to allow temporary folders be writable;
9. Run ```chmod -R 777 uploads``` to allow upload folders be writable;
10. Run ```composer install``` to install all the library;



### Increase Size for File Upload

1. Find php ini file from phpinfo()
2. Modify php.ini file with following settings
    * post_max_size = 512M
    * upload_max_filesize = 500M
    * memory_limit = 512M
    * max_file_uploads = 100

    Ref: https://www.drupal.org/docs/7/managing-site-performance-and-scalability/increase-upload-size-in-your-phpini


1. Unlink device from playlist/view (not to real delete device)
2. Add device token value in device/view
3. Make sure API return list of media files with hardcoded device token.
4. Make sure Python script can play media files (including GIF)
5. Add other API: 
     1) Command prompt to get username and password and login, return user token.
     2) Command prompt to get list of devices with user token.
     3) Command prompt to enroll a client for a device, if device doesnt have a client, enroll the client for the device (with mac), return device token; if device has a client, if mac address match, return device token directly, else prompt to overwrite existing client. Save device token in "setting_device_token" file.

6. Script Z ("script_setup", run upon reboot), check if "setting_device_token" exists, then exit, else bring up command prompt from 1)

7. Script X ("script_sync_settings", start at bootup, run at 1 minute interval) to get latest device setting and list of media files of its playlist.
            0) Check if "setting_device_token" not exists, skip
            0) Check if exists "flag_in_progress_sync_<timestamp>" file in main folder, if file older than 30 minutes, remove it; else exit to skip current iteration.
            0) Create a empty file "flag_in_progress_sync_<timestamp>" in main folder.
            0) Send in current IP, Mac and device token to server get latest device setting and list of media files of its playlist
            i) Generate existing file list in "backstage" folder. 
            ii) Iterate existing file list, if file is not in new list, delete it
            iii) Iterate new file list, download missing files to "backstage" folder
            iv) Create a flag "flag_file_list_changed" in main folder to indicate new file list available in <backstage> folder.
            v) Remove "flag_in_progress_sync_<timestamp>" file.
            v) Reboot device if "status" in setting is Yes. 

8. Script Y ("script_play_files" start at boot, run continuously)
            0) Check if "setting_device_token" not exists, skip
            0) check if not existing "flag_file_list_changed", skip to play files from "frontstage" folder.
            vi) Copy files from "backstage" folder to "frontstage" folder. Remove "flag_file_list_changed".
            vii) Play files from "frontstage" folder
      
9. Check can bring up another playing thread for flawless transition.


### Reference:
    http://plugins.krajee.com/file-input/plugin-options#previewSettings
    http://demos.krajee.com/widget-details/fileinput
    http://webtips.krajee.com/advanced-upload-using-yii2-fileinput-widget/
    http://webtips.krajee.com/viewing-updating-model-data-yii2-detail-view/


## URL and API

Frontend: http://localhost/WiredNoticeboard/frontend/web

Backend: http://localhost/WiredNoticeboard/backend/web

### User Login/Logout

http -v -a mark.qj:Mylife\!23 POST http://localhost/WiredNoticeboard/api/web/index.php/v1/user/login
    - Output: {
                  "result": "Login successfully",
                  "role": 10,
                  "token": "u3Ep6FTURGavLnHh7wescaOnmP0WnZ74",
                  "username": "mark.qj"
              }



http -v POST http://localhost/WiredNoticeboard/api/web/index.php/v1/user/logout 'Authorization:Bearer _qU-16BFum5A5rzKrmNt0EVp6TZnWO2k'

### Device List

http -v GET http://localhost/WiredNoticeboard/api/web/index.php/v1/device 'Authorization:Bearer Q7e3_Vh54exZXMbcQqWntsGdDuK5j2KA'

http -v GET http://localhost/WiredNoticeboard/api/web/index.php/v1/device/10?expand=user,mediaFiles,playlist,token 'Authorization:Bearer Q7e3_Vh54exZXMbcQqWntsGdDuK5j2KA'

http -v POST http://localhost/WiredNoticeboard/api/web/index.php/v1/device/bind-client 'Authorization:Bearer Q7e3_Vh54exZXMbcQqWntsGdDuK5j2KA' device_serial='S9JX4VrIKqnjYBEu6ACWbj' mac='mac-abcd' 'overwrite'='true'

http -v POST http://localhost/WiredNoticeboard/api/web/index.php/v1/device/client-ping device_token='PXbKe4ePiPJP2tR9UnjchsNBBtRxgWTR' mac='mac-abcd' 'ip_address'='127.0.3.1'

http -v POST http://localhost/WiredNoticeboard/api/web/index.php/v1/device/update-status device_token='PXbKe4ePiPJP2tR9UnjchsNBBtRxgWTR' mac='mac-abcd' 'status'=2

### Playlist

http -v  GET http://localhost/WiredNoticeboard/api/web/index.php/v1/playlist 'Authorization:Bearer Q7e3_Vh54exZXMbcQqWntsGdDuK5j2KA'

http -v  GET http://localhost/WiredNoticeboard/api/web/index.php/v1/playlist/3?expand=devices,user,mediaFiles 'Authorization:Bearer Q7e3_Vh54exZXMbcQqWntsGdDuK5j2KA'

