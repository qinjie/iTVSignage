import glob
import json
import logging
import shutil

import sys

import time

import subprocess

import utils_other
import os.path
import utils_wand


# Script
#   - Run at reboot
#   - Play files in frontstage
#   - Run this script on commandline or crontab >>>              DISPLAY=:0.0 python script_play.py
# 1) if "flag_file_changed" exists, delete files in frontstage, copy files from backstage, covert files into playable format
# 2) Delete "flag_file_changed" file
# 3) Play playable files in frontstage


def init_logger():
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)
    return logger


def clean_folder(folder):
    ## Clean output image folder
    if not os.path.exists(folder):
        os.makedirs(folder)
    else:
        flist = os.listdir(folder)
        for f in flist:
            os.remove(os.path.join(folder, f))


def copy_files(src_folder, dest_folder):
    logger.info(src_folder)
    src_filenames = os.listdir(src_folder)
    logger.info(src_filenames)

    # Process files one by one
    for index, file_name in enumerate(src_filenames):
        # Process only top level files
        if not os.path.isfile(os.path.join(src_folder, file_name)):
            continue

        new_file_name = "{0:04}_{1}".format(index, file_name)
        # Copy image and export pdf
        logger.info(new_file_name)
        input_file = os.path.join(src_folder, file_name)
        output_file = os.path.join(dest_folder, new_file_name)
        # Export PDF into images
        if input_file.endswith('.pdf'):
            # Export PDF to images
            # input_file2 = os.path.join(dest_folder, new_file_name)
            # print input_file2
            # shutil.copy2(input_file, input_file2)
            utils_wand.pdf_to_png(input_file_path=input_file, output_dir_path=dest_folder)
        # elif utils_other.get_image_type(input_file):
        #     # Copy image to data/image folder
        #     output_file = os.path.join(_path_data_image, new_file_name)
        #     print output_file
        #     shutil.copy2(input_file, output_file)
        elif utils_other.get_video_type(input_file) or utils_other.get_image_type(input_file):
            # Copy image to data/video folder
            # output_file = os.path.join(_path_data_video, new_file_name)
            # print output_file
            shutil.copy2(input_file, output_file)


if __name__ == '__main__':
    RELOAD = 10  # seconds
    SLIDE_TIMING = 5.0 #seconds

    logger = init_logger()
    cur_dir = os.path.dirname(os.path.realpath(__file__))
    flag_dirty = os.path.join(cur_dir, 'flag_file_changed')
    backstage = os.path.join(cur_dir, 'backstage')
    frontstage = os.path.join(cur_dir, 'frontstage')
    setting_client_info = os.path.join(cur_dir, 'setting_client_info')

    # Display background image
    cmd = ['feh', '-x', '-Y', '-q', '-F', os.path.join(cur_dir, 'background.png')]
    proc_bg = subprocess.Popen(cmd)
    time.sleep(4)

    try:
        while True:
            # Check new files
            if os.path.exists(flag_dirty):
                clean_folder(frontstage)
                copy_files(backstage, frontstage)
                try:
                    os.remove(flag_dirty)
                except Exception as e:
                    logger.error(e.message, exc_info=True)

            # Load devcie settings
            with open(setting_client_info) as f:
                setting = json.loads(f.read())
                SLIDE_TIMING = setting['slide_timing'] * 1.0 / 1000
                logger.info("Device Setting: {}".format(setting))

            # Get list of video files
            video_exts = ['*.avi', '*.mp4', '*.flv', '*.wmv', '*.mov']
            video_paths = [os.path.join(frontstage, e) for e in video_exts]
            videos = []
            for path in video_paths:
                videos.extend(glob.glob('{}'.format(path)))
            logger.info(videos)

            time.sleep(2)

            ## Slide show using FEH through subprocess
            opt_delay = '-D {}'.format(SLIDE_TIMING)
            opt_reload = '-R {}'.format(RELOAD)
            cmd = ['feh', '-x', '-Y', '-q', '-F', '-Z', '-S', '-r', opt_delay, opt_reload, '--cycle-once', frontstage]
            logger.info("Slide Command: {}".format(cmd))
            proc_image = subprocess.call(cmd)

            ## Video playing using using FEH through subprocess
            for v in videos:
                logger.info("Playing video {}".format(v))

                ### Run on RPi
                ## Option 1
                # cmd = 'DISPLAY=:0.0 omxplayer -o hdmi -b {}'.format(v)
                # os.system(cmd + ' > /dev/null')
                ## Option 2
                cmd = ['omxplayer', '-o', 'both', '-b', v]
                proc_video = subprocess.call(cmd)

                ## Test on Mac
                ## Option 1
                # cmd = 'open -a vlc {}'.format(v)
                # os.system(cmd + ' > /dev/null')
                ## Option 2
                # cmd = ['vlc', v]
                # subprocess.call(cmd)


    except Exception as e:
        logger.error(e.message, exc_info=True)
        sys.exit()

    proc_bg.terminate()
