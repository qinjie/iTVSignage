from __future__ import print_function
import json
import requests
import logging
from utils_other import cur_func_name

# URL_ROOT = 'http://localhost/WiredNoticeboard'
URL_ROOT = 'http://13.250.218.226/WiredNoticeboard'
URL_API = URL_ROOT + '/api/web/index.php'
URL_FRONTEND = URL_ROOT + '/frontend/web'
URL_UPLOAD = URL_FRONTEND + '/uploads'


def init_logger():
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)
    return logger


## http -v -a mark.qj:Mylife\!23 POST http://localhost/WiredNoticeboard/api/web/index.php/v1/user/login
# {
#     "result": "Login successfully",
#     "role": 10,
#     "token": "fyZd9zepvxMzZYJY7RqMsVEbIOFHwuIo",
#     "username": "mark.qj"
# }

def login(username, password):
    logger = init_logger()
    logger.info(cur_func_name())
    logger.info('Username: {0}'.format(username))
    try:
        url = URL_API + '/v1/user/login'
        headers = {'Accept': 'application/json', 'content-type': 'application/json'}
        r = requests.post(url, auth=(username, password), headers=headers)
        logger.info(r.text)
        if r.status_code == 200:
            return r.json()['token']
        else:
            logger.warn("Failed to login.")
            return None
    except requests.exceptions.RequestException as e:
        logger.error(e.message, exc_info=True)
        return None


## http -v GET http://localhost/WiredNoticeboard/api/web/index.php/v1/device 'Authorization:Bearer Q7e3_Vh54exZXMbcQqWntsGdDuK5j2KA'
# [{
#     "created_at": "2018-01-25 06:41:24",
#     "id": 10,
#     "name": "My Device",
#     "playlist_ref": "FBAh1-c6LXsA-7SpWkiJoG",
#     "remark": "Testing only",
#     "serial": "S9JX4VrIKqnjYBEu6ACWbj",
#     "slide_timing": 3000,
#     "status": 2,
#     "turn_off_time": "19:00:00",
#     "turn_on_time": "07:00:00",
#     "updated_at": "2018-01-26 21:48:25",
#     "user_id": 7
# }]


def list_devices(user_token):
    logger = init_logger()
    logger.info(cur_func_name())
    try:
        url = URL_API + '/v1/device'
        header = {'Accept': 'application/json', 'content-type': 'application/json'}
        header['Authorization'] = 'Bearer {}'.format(user_token)
        r = requests.get(url, headers=header)
        logger.info(r.text)
        if r.status_code == 200:
            return r.json()
        else:
            logger.warn("Failed to get device list")
            return None
    except requests.exceptions.RequestException as e:
        logger.error(e.message, exc_info=True)
        return None


## http -v POST http://localhost/WiredNoticeboard/api/web/index.php/v1/device/bind-client 'Authorization:Bearer Q7e3_Vh54exZXMbcQqWntsGdDuK5j2KA' device_serial='S9JX4VrIKqnjYBEu6ACWbj' mac='mac-abcd' 'overwrite'='true'
# {
#     "created_at": "2018-01-26 16:38:52",
#     "device_id": 10,
#     "expire": "2019-01-26 16:38:52",
#     "id": 2,
#     "ip_address": "127.0.1.1",
#     "mac": "mac-abcd",
#     "token": "PXbKe4ePiPJP2tR9UnjchsNBBtRxgWTR",
#     "updated_at": "2018-01-26 20:16:51"
# }

def bind_client(user_token, device_serial, rpi_mac, overwrite=True):
    logger = init_logger()
    logger.info(cur_func_name())
    try:
        url = URL_API + '/v1/device/bind-client'
        header = {'Accept': 'application/json', 'content-type': 'application/json'}
        header['Authorization'] = 'Bearer {}'.format(user_token)
        data = {'mac': rpi_mac, 'device_serial': device_serial, 'overwrite': overwrite}
        r = requests.post(url, headers=header, data=json.dumps(data))
        logger.info(r.text)
        if r.status_code == 200:
            return r.json()
        else:
            logger.warn("Failed to get device list")
            return None
    except requests.exceptions.RequestException as e:
        logger.error(e.message, exc_info=True)
        return None


## http -v POST http://localhost/WiredNoticeboard/api/web/index.php/v1/device/client-ping device_token='7xrQ5J9gHEB5NMFh6r45D5QvMARDDY5G' mac='ERROR000000000' 'ip_address'='127.0.3.1'
# {
#     "files": [
#         {
#             "created_at": "2018-01-26 14:31:34",
#             "file_name": "1891829-060poliwag.png",
#             "file_type": "image/png",
#             "height": 240,
#             "id": 20,
#             "playlist_ref": "FBAh1-c6LXsA-7SpWkiJoG",
#             "real_filename": "38b1fb25ac1112ab3b8571e403319d61.png",
#             "sequence": null,
#             "size": 59058,
#             "type": "image",
#             "updated_at": null,
#             "width": 260
#         }
#     ],
#     "playlist": {
#         "created_at": "2018-01-26 14:31:57",
#         "detail": "Bad bad bad",
#         "id": 4,
#         "name": "Bad List",
#         "ref": "FBAh1-c6LXsA-7SpWkiJoG",
#         "updated_at": "2018-01-26 14:57:56",
#         "user_id": 6
#     }
# }

def client_ping(device_token, rpi_mac, ip_address):
    logger = init_logger()
    logger.info(cur_func_name())
    try:
        url = URL_API + '/v1/device/client-ping'
        header = {'Accept': 'application/json', 'content-type': 'application/json'}
        data = {'mac': rpi_mac, 'device_token': device_token, 'ip_address': ip_address}
        r = requests.post(url, headers=header, data=json.dumps(data))
        logger.info(r.text)
        if r.status_code == 200:
            return r.json()
        else:
            logger.warn("Failed to get device list")
            return None
    except requests.exceptions.RequestException as e:
        logger.error(e.message, exc_info=True)
        return None


def get_device_info(device_token, rpi_mac):
    logger = init_logger()
    logger.info(cur_func_name())
    try:
        url = URL_API + '/v1/device/get-device-info'
        header = {'Accept': 'application/json', 'content-type': 'application/json'}
        data = {'mac': rpi_mac, 'device_token': device_token}
        r = requests.post(url, headers=header, data=json.dumps(data))
        logger.info(r.text)
        if r.status_code == 200:
            return r.json()
        else:
            logger.warn("Failed to get device list")
            return None
    except requests.exceptions.RequestException as e:
        logger.error(e.message, exc_info=True)
        return None


if __name__ == '__main__':
    device_token = 'miJI8qpgn3Iz3V1ZYMWIWHMm3dunmtaq'
    rpi_mac = '00000000035b1b07'
    device_info = get_device_info(device_token, rpi_mac)
    print(device_info)
