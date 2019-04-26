# mysql_dropbox_backup

A simple script to automatically back up MySQL databases to Dropbox.

## Installation

1. `sudo curl -L "https://raw.githubusercontent.com/mtmbutler/mysql-dropbox-backup/master/setup.sh" | bash`
2. Set up Dropbox Uploader by running their script and following instructions:
    * `bash ~/mysql_dropbox_backup/dropbox_uploader.sh`

## Notes

### Dependencies

Not installed during setup:

* Ubuntu
* MySQL and mysqldump

Installed during setup:

* Dropbox Uploader (see https://github.com/andreafabrizi/Dropbox-Uploader)
* 7-zip

### Setup

The setup script:

1. Creates a project directory in your home folder: `mysql_dropbox_backup/`
2. Downloads `dropbox_uploader.sh`
3. Downloads `mysql_dropbox_backup.sh`
4. Creates a `cron` job to back up all databases every Saturday at 11 pm

### Usage

`mysql_dropbox_backup.sh` has two flags:

* `-t` Test: If you run with this flag, it will only back up the database
       structure, without any data. This is just to test that everything
       is working properly.
* `-k` Keep: If you run with this flag, the backup archives will stay on
       your disk, in the `backups` subdirectory.

The backups will exclude databases with any of these names:

* `information_schema`
* `performance_schema`
* `sys`
* `mysql`

Each backup is a `.7z` archive with two `.sql` files for each database: one
for structure, and the other for data.

The backups will go into a subfolder in the Dropbox app folder, named with
your machine's `$HOSTNAME`.
