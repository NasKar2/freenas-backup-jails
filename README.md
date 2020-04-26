# freenas-iocage-jail-backup
Backup and Restore Iocage Jails
Backup and restore iocage jails in FreeNAS 11.3
Adapted from https://digimoot.wordpress.com/2020/01/11/freenas-backup-jails-automatically-using-iocage-import-and-export/

# Directions

My pool is /mnt/v1 and iocage is located at /mnt/v1/iocage

## To Backup

he script will backup all jails automatically if no other parameters are given. The backups will be placed in a directory with the date in the name "IOCAGE__2020-04-25_1818".  You can specify in the script with the variable "maxNrOfBackups" how many backups to keep.

```
./jailbu.sh
```

## To Restore

The script will restore if the first parameter is an r or R and the second is the name of the jail

```
./jailbu.sh r plexpass
```

will restore the plexpass jail from the backup files plexpass.zip and plexpass.sha256 in the BACKUP_LOC in my example "/mnt/v1/backup/Jails"


### Prerequisites

Edit these variables in the script and do not edit the part between the ${}

POOL_NAME="/mnt/v1"

LOGS_LOC="${POOL_NAME}/backup/Jails/logs" # In my pool example /mnt/v1/backup/Jails/logs

FILE_NAME="JAIL.LOG"

JAIL_DIR="${POOL_NAME}/iocage/jails" # /mnt/v1/iocage/jails

JAIL_IMAGE="${POOL_NAME}/iocage/images" # /mnt/v1/iocage/images

BACKUP_LOC="${POOL_NAME}/backup/Jails" # /mnt/v1/backup/Jails

FINAL="IOCAGE_"$(date +'_%F_%H%M') # IOCAGE__2020-04-25_2029

BACKUP_DIR="${BACKUP_LOC}/${FINAL}" # The actual directory of the current backup - this is is subdirectory of the main directory above with a timestamp /mnt/v1/backup/Jails/IOCAGE__2020-04-25_2029

FULL_LOG_NAME=${BACKUP_DIR}/$FILE_NAME # /mnt/v1/backup/Jails/IOCAGE__2020-04-25_2029/JAIL.LOG

maxNrOfBackups=2 # The maximum number of backups to keep (when set to 0, all backups are kept)
