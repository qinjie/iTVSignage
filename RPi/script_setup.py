import json
import logging

import click
import os

import sys

import utils_rpi
import api
from utils_other import web_site_online


# Script
#   - setup device
#   - run upon reboot
# 1) skip if "setting_device_token" exists
# 2) the script requires user input to generate "setting_device_token" file


def init_logger():
    logging.basicConfig(level=logging.WARN)
    logger = logging.getLogger(__name__)
    return logger


if __name__ == '__main__':
    logger = init_logger()

    # Check internet connection
    if not web_site_online(api.URL_FRONTEND):
        logger.error("Not able to reach server.")
        sys.exit()

    # Check existing settings
    cur_dir = os.path.dirname(os.path.realpath(__file__))
    filename_client_info = 'setting_client_info'
    filename_client_token = 'setting_client_token'
    filepath_client_info = os.path.join(cur_dir, filename_client_info)
    filepath_client_token = os.path.join(cur_dir, filename_client_token)

    if os.path.isfile(filepath_client_info) and os.path.isfile(filepath_client_token):
        click.echo("This device is already setup.")
        with open(filepath_client_info, 'r') as f:
            j = json.loads(f.read())
            click.echo('\t{} ({}): {}'.format(j['name'], j['serial'], j['remark']))
        if not click.confirm('Delete current setup?'):
            sys.exit()
        else:
            try:
                os.remove(filepath_client_info)
                os.remove(filepath_client_token)
            except Exception as e:
                logger.error(e.message, exc_info=True)

    # Confirm to setup device
    if not click.confirm("Continue to setup this device?"):
        click.echo("Exit without setup.")
        sys.exit()

    # Get username and password to login
    username = click.prompt('Enter username', type=str)
    password = click.prompt('Enter password', type=str, hide_input=True)
    user_token = api.login(username, password)
    # retrieve list of devices
    device_list = api.list_devices(user_token)
    # Ask user to select a device
    click.echo("Your device list:")
    click.echo('---------------------------')
    for index, d in enumerate(device_list):
        click.echo('\t{}. {}'.format(index, d['name']))
    click.echo('---------------------------')
    id = click.prompt("Select a device from the list", type=int)
    device = device_list[id]
    # save device data to "setting_client_info" file
    with open(filepath_client_info, 'w') as f:
        f.write(json.dumps(device))

    # bind client to a device which is setup in server
    device_mac = utils_rpi.get_mac()
    result = api.bind_client(user_token, device_serial=device['serial'], rpi_mac=device_mac)
    # save token data to "setting_client_token" file
    with open(filepath_client_token, 'w') as f:
        f.write(json.dumps(result))

    click.echo('Setup is completed.')
