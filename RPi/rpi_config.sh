#!/bin/bash
# Import cron jobs from file
crontab crontab.txt && \
sudo service cron reload

