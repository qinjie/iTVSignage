import logging
import os
from wand.image import Image
from wand.image import Color
import errno


def init_logger():
    logging.basicConfig(level=logging.WARN)
    logger = logging.getLogger(__name__)
    return logger


def pdf_to_png(input_file_path, output_dir_path, resolution=150):
    logger = init_logger()

    """ Convert a PDF into images.
        All the pages will give a single png file with format:
        {pdf_filename}-{page_number}.png
        The function removes the alpha channel from the image and
        replace it with a white background.
    """
    # Check input file
    if not os.path.isfile(input_file_path) or not input_file_path.endswith('.pdf'):
        logger.error("Invalid input file {}".format(input_file_path))
        return

    # Create output foldre if not exists
    if not os.path.exists(output_dir_path):
        try:
            os.makedirs(output_dir_path)
        except OSError as exc:  # Guard against race condition
            if exc.errno != errno.EEXIST:
                raise

    logger.info("Exporting PDF file to PNG images...")

    all_pages = Image(filename=input_file_path, resolution=resolution)
    logger.info(all_pages.size)
    for i, page in enumerate(all_pages.sequence):
        image_filename = os.path.splitext(os.path.basename(input_file_path))[0]
        image_filename = '{0}-{1:04}.png'.format(image_filename, i)
        image_filename = os.path.join(output_dir_path, image_filename)
        logger.info('page {} = {}'.format(i, image_filename))

        with Image(page, resolution=200) as img:
            img.compression_quality = 99
            img.format = 'png'
            img.background_color = Color('white')
            img.alpha_channel = 'remove'
            img.save(filename=image_filename)


if __name__ == "__main__":
    logger = init_logger()
    dn = os.path.dirname(os.path.realpath(__file__))
    filename = r'download\abcd1234.pdf'
    input_file = os.path.join(dn, filename)
    output_dir = os.path.join(dn, 'temp')
    pdf_to_png(input_file_path=input_file, output_dir_path=output_dir)
