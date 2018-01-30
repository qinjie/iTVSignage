import ConfigParser
import json
import os
import shutil

import requests
import time

import utils_other
import utils_wand


####
# This script is the main script to download slideshow files from server
# 1. Get file list in play order into file_list.txt
# 2. Download files into "download" folders
# 3. For each file in file_list with index i
# 	Get file from download folder
# 	If it's a image file, copy to "pictures" folder and rename it as "<i>_<filename>"
# 	If it's a pdf file, export it as images to "pictures" foder with name "<i>_<filename>_<page>"
# 4. Run Feh with slide show
# 5. Play video files
####


def read_config(filepath):
    if not os.path.exists(filepath):
        print 'Missing device configuration file.'
        return {}
    else:
        with open(filepath, 'rb') as f:
            str = f.read()
            return json.loads(str)


FOLDER_DOWNLOAD = "download"
FOLDER_IMAGES = "data/image"
FOLDER_VIDEO = "data/video"
CONFIG_FILE = 'device.json'
INI_FILE = 'device.ini'

_path_cur_dir = os.path.dirname(os.path.realpath(__file__))
_file_config = os.path.join(_path_cur_dir, CONFIG_FILE)
_file_ini = os.path.join(_path_cur_dir, INI_FILE)
_path_data_image = os.path.join(_path_cur_dir, FOLDER_IMAGES)
_path_data_video = os.path.join(_path_cur_dir, FOLDER_VIDEO)
_path_download = os.path.join(_path_cur_dir, FOLDER_DOWNLOAD)

# Set flag to indicate download completed or not
_download_completed_flag = os.path.join(_path_cur_dir, 'flag_1')
_download_inprogress_flag = os.path.join(_path_cur_dir, 'flag_0')
_download_failed_flag = os.path.join(_path_cur_dir, 'flag_2')


def set_download_inprogress_flag():
    if os.path.exists(_download_completed_flag):
        os.remove(_download_completed_flag)
    if os.path.exists(_download_failed_flag):
        os.remove(_download_failed_flag)
    if not os.path.exists(_download_inprogress_flag):
        open(_download_inprogress_flag, 'w').close()


def set_download_completed_flag():
    if os.path.exists(_download_inprogress_flag):
        os.remove(_download_inprogress_flag)
    if os.path.exists(_download_failed_flag):
        os.remove(_download_failed_flag)
    if not os.path.exists(_download_completed_flag):
        open(_download_completed_flag, 'w').close()


def set_download_failed_flag():
    if os.path.exists(_download_inprogress_flag):
        os.remove(_download_inprogress_flag)
    if os.path.exists(_download_completed_flag):
        os.remove(_download_completed_flag)
    if not os.path.exists(_download_failed_flag):
        open(_download_failed_flag, 'w').close()


def make_folders():
    if not os.path.exists(_path_download):
        os.makedirs(_path_download)
    if not os.path.exists(_path_data_image):
        os.makedirs(_path_data_image)
    if not os.path.exists(_path_data_video):
        os.makedirs(_path_data_video)


def read_ini_file(ini_file):
    parser = ConfigParser.SafeConfigParser()
    parser.read(ini_file)
    parser.defaults()
    settings = {}
    base_url = parser.get('server', 'url_base')
    settings['device_enroll'] = base_url + parser.get('server', 'device_enroll')
    settings['device_playlist'] = base_url + parser.get('server', 'device_playlist')
    settings['device_profile'] = base_url + parser.get('server', 'device_profile')
    settings['device_download'] = base_url + parser.get('server', 'device_download_file')
    # Get device values
    settings['device_mac'] = parser.get('device', 'device_mac')
    settings['device_label'] = parser.get('device', 'device_label')

    return settings


def download_file_with_token(url, headers, filename='temp'):
    r = requests.get(url, headers=headers, stream=True)
    if r.status_code == 200:
        with open(filename, 'wb') as f:
            for chunk in r.iter_content(chunk_size=1024):
                if chunk:  # filter out keep-alive new chunks
                    f.write(chunk)
        return filename
    else:
        return None


def clean_folder(folder):
    ## Clean output image folder
    if not os.path.exists(folder):
        os.makedirs(folder)
    else:
        flist = os.listdir(folder)
        for f in flist:
            os.remove(os.path.join(folder, f))


# Set flag download in progress
set_download_inprogress_flag()

# Wait for internet connection
WAIT_ONLINE_SECONDS = 600  # Wait for 10 minutes
count = 0
while not utils_other.web_site_online():
    if count >= WAIT_ONLINE_SECONDS:
        set_download_failed_flag()
        exit(2)
    print "Wait for internet connection."
    time.sleep(30)  # Delay for 30 seconds
    count = count + 30

# Create folders
make_folders()

# Read device.ini file
settings = []
if not os.path.exists(INI_FILE):
    print 'Missing server ini file.'
    exit(1)
else:
    settings = read_ini_file(ini_file=_file_ini)
    print "Settings: {}".format(settings)

if not settings['device_mac']:
    print 'Missing device mac ID in file {}.'.format(INI_FILE)
    exit(1)

# Read device.json file
config_json = read_config(_file_config)

# Get token if not available
if 'token' not in config_json:
    if settings['device_mac']:
        print settings['device_mac']
        headers = {'Content-Type': 'application/json', 'Accept': 'application/json'}
        headers['Mac'] = settings['device_mac']
        r = requests.post(settings['device_enroll'], headers=headers)
        print "URL: {}".format(settings['device_enroll'])
        print "Header = {} {}".format(r.status_code, r.headers['content-type'])
        print "Content = {}".format(r.text)
        if r.status_code == 200:
            j = json.loads(r.text)
            config_json.update(j)
            print "New Config: {}".format(config_json)
            with open(_file_config, 'w') as f:
                f.write(json.dumps(config_json))
    else:
        print 'Missing device mac ID in file {}.'.format(INI_FILE)
        exit(1)

if 'token' not in config_json:
    print 'No device token available'
    exit(1)

# Download device settings
headers = {'Content-Type': 'application/json', 'Accept': 'application/json'}
headers['Token'] = config_json['token']
url = settings['device_profile']
r = requests.get(url, headers=headers, stream=True)
if r.status_code == 200:
    j = json.loads(r.text)
    config_json.update(j)
    print "New Config: {}".format(config_json)
    with open(_file_config, 'w') as f:
        f.write(json.dumps(config_json))

# Get media list
print 'Fetch media list'
file_list = []
headers = {'Content-Type': 'application/json', 'Accept': 'application/json'}
headers['Token'] = config_json['token']
r = requests.get(settings['device_playlist'], headers=headers)
js = r.json()
with open('file_list.txt', 'wb') as f:
    for j in js:
        f.write(j['file_path'] + '\n')
        file_list.append(j['file_path'])

# Download media files
print 'Download media files'
for j in js:
    file_path = os.path.join(_path_download, j['file_path'])
    print file_path
    if not os.path.exists(file_path):
        headers = {'Content-Type': 'application/json', 'Accept': 'application/json'}
        headers['Token'] = config_json['token']
        url = settings['device_download'].replace('{file}', j['file_path'])
        print url
        download_file_with_token(url, headers, file_path)

## Clean image & video folder
clean_folder(_path_data_image)
clean_folder(_path_data_video)

# Process input files into output folder
#   copy image and export pdf
for index, file_name in enumerate(file_list):
    new_file_name = "{0:04}_{1}".format(index, file_name)
    print new_file_name
    # Export PDF into images
    input_file = os.path.join(_path_cur_dir, FOLDER_DOWNLOAD, file_name)

    if input_file.endswith('.pdf'):
        # Export PDF to images
        input_file2 = os.path.join(_path_cur_dir, FOLDER_DOWNLOAD, new_file_name)
        print input_file2
        shutil.copy2(input_file, input_file2)
        utils_wand.pdf_to_png(input_file_path=input_file2, output_dir_path=_path_data_image)
        os.remove(input_file2)
    elif utils_other.get_image_type(input_file):
        # Copy image to data/image folder
        output_file = os.path.join(_path_data_image, new_file_name)
        print output_file
        shutil.copy2(input_file, output_file)
    elif utils_other.get_video_type(input_file):
        # Copy image to data/video folder
        output_file = os.path.join(_path_data_video, new_file_name)
        print output_file
        shutil.copy2(input_file, output_file)

# Set flag download in progress
set_download_completed_flag()
