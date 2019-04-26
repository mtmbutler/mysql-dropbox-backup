#!/usr/bin/env bash

# Flags
TEST=false
KEEP_FILES=false
while getopts "tk" opt; do
    case ${opt} in
        t)
            TEST=true >&2
            ;;
        k)
            KEEP_FILES=true >&2
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            ;;
    esac
done

# File settings
DATE=`date +"%y%m%d"`
BASE_DIR="${HOME}/mysql_dropbox_backup/"
BACKUPS_DIR="${BASE_DIR}/backups"
TODAY_DIR="${BACKUPS_DIR}/${DATE}"
ARCHIVE_PATH="${TODAY_DIR}.7z"

# MySQL settings
MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump

# Dropbox settings
DB_UPLOADER="${BASE_DIR}/dropbox_uploader.sh"
DBU_CONFIG="${HOME}/.dropbox_uploader"

echo "Backing up databases on ${DATE}..."

# Make directory for .sql files and get database names
mkdir -p ${TODAY_DIR}
echo "Fetching databases..."
databases=`sudo ${MYSQL} -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|sys|mysql)"`

# Back up structure and data for each database
for db in ${databases}; do
    echo "Backing up ${db} structure..."
    sudo ${MYSQLDUMP} --force --opt --no-data ${db} > "${TODAY_DIR}/${db}_struct.sql"

    # Skip data backup if it's just a test
    if ${TEST} ; then
        :
    else
        echo "Backing up ${db} data..."
        sudo ${MYSQLDUMP} --force --opt --no-create-info ${db} > "${TODAY_DIR}/${db}_data.sql"
    fi

done

echo "Compressing..."
7za a ${ARCHIVE_PATH} "${TODAY_DIR}/"  # unzip with 7za x
rm -r ${TODAY_DIR}

echo "Uploading to Dropbox..."
bash ${DB_UPLOADER} -f ${DBU_CONFIG} upload ${ARCHIVE_PATH} "${HOSTNAME}/"

# Delete the archive file
if ${KEEP_FILES} ; then
    :
else
    echo "Deleting local copy..."
    rm ${ARCHIVE_PATH}
fi

echo "Done!"
echo ""
