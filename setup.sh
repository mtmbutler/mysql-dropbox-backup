#!/usr/bin/env bash

# Install 7-zip
sudo apt install p7zip-full || true

# Set up directories
BASE_DIR="${HOME}/mysql_dropbox_backup"
BACKUPS_DIR="${BASE_DIR}/backups"
LOG_PATH="${BASE_DIR}/log.txt"
mkdir ${BASE_DIR}
mkdir ${BACKUPS_DIR}
touch ${LOG_PATH}

# Set up Dropbox Uploader
DU_URL="https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh"
DU_PATH="${BASE_DIR}/dropbox_uploader.sh"
curl -L ${DU_URL} -o ${DU_PATH}

# Set up main script
NAME="mysql_dropbox_backup.sh"
SH_PATH="${BASE_DIR}/${NAME}"
MAIN_URL="https://raw.githubusercontent.com/mtmbutler/mysql-dropbox-backup/master/${NAME}"
curl -L ${MAIN_URL} -o ${SH_PATH}

# Add weekly Saturday 11 pm backup to cron
JOB="0 23 * * 6 bash ${SH_PATH} > ${LOG_PATH}"
(crontab -l ; echo "${JOB}") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
