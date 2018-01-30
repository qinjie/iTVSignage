import glob
import logging
import shutil

import sys

import utils_other
import os.path
import utils_wand


# Script
#   - Run at reboot
#   - Play files in frontstage
# 1) if "flag_file_changed" exists, delete files in frontstage, copy files from backstage, covert files into playable format
# 2) Delete "flag_file_changed" file
# 3) Play playable files in frontstage


def init_logger():
    logging.basicConfig(level=logging.WARN)
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

    DELAY = 5  # seconds
    RELOAD = 10  # seconds
    slide_timing_second = DELAY
    image_exts = ['.jpg', '.jpeg', '.png', '.gif']
    video_exts = ['*.avi', '*.mp4', '*.flv', '*.wmv', '*.mov']

    logger = init_logger()
    cur_dir = os.path.dirname(os.path.realpath(__file__))
    flag_dirty = os.path.join(cur_dir, 'flag_file_changed')
    backstage = os.path.join(cur_dir, 'backstage')
    frontstage = os.path.join(cur_dir, 'frontstage')

    while True:
        try:
            if os.path.exists(flag_dirty):
                clean_folder(frontstage)
                copy_files(backstage, frontstage)
                try:
                    os.remove(flag_dirty)
                except Exception as e:
                    logger.error(e.message, exc_info=True)

            # Get list of video files
            videos = []
            for files in video_exts:
                videos.extend(glob.glob(files))
            logger.info(videos)

            ## Play image files
            # cmd = 'DISPLAY=:0.0 feh -Y -q -F -Z -D {} -R {} -S filename -B black --cycle-once -r {}'.format(slide_timing_second, RELOAD, frontstage)
            ## test on Mac
            cmd = 'feh -Y -q -F -Z -D {} -R {} -S filename -B black --cycle-once -r {}'.format(slide_timing_second,
                                                                                               RELOAD, frontstage)
            os.system(cmd + ' > /dev/null')
            ## Play video files
            for v in videos:
                logger.info("Playing video {}".format(v))
                # cmd = 'DISPLAY=:0.0 omxplayer -o hdmi -b {}'.format(v)
                ## Test on Mac
                cmd = 'open -a vlc {}'.format(v)
                os.system(cmd + ' > /dev/null')

        except Exception as e:
            logger.error(e.message, exc_info=True)
            sys.exit()
