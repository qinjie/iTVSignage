import json
import logging

import click
import sys

import requests

import utils_rpi
import api
import os.path

# Script
#   - ping with server to get updated device setting and playlist files
#   - run every minute
# 1) skip if "setting_client_token" is missing
# 2) skip if "flag_sync_in_progress_<timestamp>" exists and not expired
# 3) clear existing expired "flag_sync_in_progress" file, create an empty "flag_sync_in_progress_<timestamp>"
# 4) call "client-ping" API to get latest device setting and playlist files, save to "setting_client_playlist"
# 5) compare file list with in
from utils_other import web_site_online


def init_logger():
    logging.basicConfig(level=logging.WARN)
    logger = logging.getLogger(__name__)
    return logger


# Read device token to ping server
def read_client_token():
    file_name = 'setting_client_token'
    cur_dir = os.path.dirname(os.path.realpath(__file__))
    setting_file = os.path.join(cur_dir, file_name)
    if not os.path.isfile(setting_file):
        logger.error("Missing client setting file - {}".format(file_name))
        return None
    try:
        with open(setting_file, 'r') as f:
            str = f.read()
            j = json.loads(str)
            return j['token']
    except Exception as e:
        logger.error(e.message, exc_info=True)
        return None


def update_device_info(device_token):
    # Check existing settings
    cur_dir = os.path.dirname(os.path.realpath(__file__))
    filename_client_info = 'setting_client_info'
    filepath_client_info = os.path.join(cur_dir, filename_client_info)

    # retrieve device info using device token
    device_mac = utils_rpi.get_mac()
    device_info = api.get_device_info(device_token, device_mac)
    # save device data to "setting_client_info" file
    with open(filepath_client_info, 'w') as f:
        f.write(json.dumps(device_info['device']))
    return


def fetch_device_playlist(device_token):
    device_mac = utils_rpi.get_mac()
    wlan_ip = utils_rpi.get_ip_address('wlan0')
    eth_ip = utils_rpi.get_ip_address('eth0')
    ip = '{}, {}'.format(wlan_ip if wlan_ip else '', eth_ip if eth_ip else '')
    result = api.client_ping(device_token, rpi_mac=device_mac, ip_address=ip)
    if not result:
        logger.error("Failed to fetch playlist from server")
        return None
    return result


def read_client_playlist():
    file_name = 'setting_client_playlist'
    cur_dir = os.path.dirname(os.path.realpath(__file__))
    file_path = os.path.join(cur_dir, file_name)

    if not os.path.isfile(file_path):
        return None

    try:
        with open(file_path, 'r') as f:
            str = f.read()
        return json.loads(str)
    except Exception as e:
        logger.warning("Exception while read setting_client_playlist")
        return None


def update_client_playlist(playlist):
    file_name = 'setting_client_playlist'
    cur_dir = os.path.dirname(os.path.realpath(__file__))
    file_path = os.path.join(cur_dir, file_name)

    try:
        with open(file_path, 'w') as f:
            f.write(json.dumps(playlist))
        return True
    except Exception as e:
        logger.warning("Exception while read setting_client_playlist")
        return False


# Check if playlist and files has changed
def is_playlist_changed(new_playlist, old_playlist):
    if not old_playlist:
        return True
    # Compare two json object
    if json.dumps(old_playlist) == json.dumps(new_playlist):
        return False
    else:
        return True


# Delete any removed files in backstage folder
def delete_removed_files(new_filenames, folder):
    current_filenames = set([filename for filename in os.listdir(folder)])
    logger.info('Current files: {}'.format(current_filenames))

    removed_files = [c for c in current_filenames if c not in new_filenames]
    logger.info("Removed files: {}".format(removed_files))
    for f in removed_files:
        f_path = os.path.join(folder, f)
        if os.path.isfile(f_path):
            try:
                os.remove(f_path)
            except Exception as e:
                logger.error(e.message, exc_info=True)


def list_missing_files(new_filenames, folder):
    current_filenames = set([filename for filename in os.listdir(folder)])
    logger.info('Current files: {}'.format(current_filenames))
    missing_files = [n for n in new_filenames if n not in current_filenames]
    logger.info("Missing files: {}".format(missing_files))
    return missing_files


def is_downloadable(url):
    """
    Does the url contain a downloadable resource
    """
    h = requests.head(url, allow_redirects=True)
    header = h.headers
    content_type = header.get('content-type')
    if 'text' in content_type.lower():
        return False
    if 'html' in content_type.lower():
        return False
    return True


def download_added_files(base_url, missing_files, folder):
    file_paths = [os.path.join(folder, f) for f in missing_files]
    file_urls = [base_url + f for f in missing_files]
    for index, fp in enumerate(file_paths):
        url = file_urls[index]
        if not is_downloadable(url):
            logger.warn("File not downloadable: {}".format(url))
            continue

        # Download and save file
        r = requests.get(url)
        logger.info("Download URL {}".format(url))
        if r.status_code == 200:
            try:
                with open(fp, 'wb') as f:
                    f.write(r.content)
            except Exception as e:
                logger.error(e.message, exc_info=True)
                if os.path.isfile(fp):
                    os.remove(fp)
        else:
            logger.error("Failed to download. Status code = " + r.status_code)


if __name__ == '__main__':

    logger = init_logger()

    # Check internet connection
    if not web_site_online(api.URL_FRONTEND):
        logger.error("Not able to reach server.")
        sys.exit()

    cur_dir = os.path.dirname(os.path.realpath(__file__))
    flag_sync = os.path.join(cur_dir, 'flag_sync_in_progress')
    flag_dirty = os.path.join(cur_dir, 'flag_file_changed')
    try:
        # Skip if another sync is in progress
        if os.path.isfile(flag_sync):
            logger.error("Exit since another sync in progress.")
            sys.exit()
        else:
            # Setup flag to indicate sync in progress
            open(flag_sync, 'w').close()

        # Check if "setting_client_token" file exists
        device_token = read_client_token()
        if not device_token:
            logger.error("Failed to read device token")
            sys.exit()

        # Update device info
        update_device_info(device_token)

        # Fetch new playlist
        new_playlist = fetch_device_playlist(device_token)
        if not new_playlist:
            logger.error("Failed to fetch new playlist")
            sys.exit()

        # Read existing file
        old_playlist = read_client_playlist()
        # Check change in client playlist and files...
        changed = is_playlist_changed(new_playlist, old_playlist)

        if not changed:
            logger.info("No change in files")
            sys.exit()
        else:
            # Sync files with server
            folder = 'backstage'
            folder_backstage = os.path.join(cur_dir, folder)
            new_filenames = [i['real_filename'] for i in new_playlist['files']]
            logger.info('New file list: {}'.format(new_filenames))
            # Get files in the backstage folder
            delete_removed_files(new_filenames, folder_backstage)
            missing_files = list_missing_files(new_filenames, folder_backstage)
            base_url = '{}/{}/'.format(api.URL_UPLOAD, new_playlist['playlist']['ref'])
            download_added_files(base_url, missing_files, folder_backstage)

            # Update playlist to "setting_client_files"
            update_client_playlist(new_playlist)

            # Setup flag to indicate files changed
            if os.path.isfile(flag_dirty):
                os.utime(flag_dirty, None)
            else:
                # Setup flag to indicate change in files
                open(flag_dirty, 'w').close()
    except Exception as e:
        logger.error(e.message, exc_info=True)
        # Remove dirty flag
        if os.path.isfile(flag_dirty):
            try:
                os.remove(flag_dirty)
            except Exception as e:
                logger.error(e.message, exc_info=True)

    # Clean up if any exception happens
    finally:
        # Remove sync flag
        if os.path.isfile(flag_sync):
            try:
                os.remove(flag_sync)
            except Exception as e:
                logger.error(e.message, exc_info=True)
