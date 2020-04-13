# freenas-iocage-jail-backup
Backup and Restore Iocage Jails
Backup and restore iocage jails in FreeNAS 11.3
Adapted from https://digimoot.wordpress.com/2020/01/11/freenas-backup-jails-automatically-using-iocage-import-and-export/

# Directions

My pool is /mnt/v1 and iocage is located at /mnt/v1/iocage

## To Backup

The script will backup all jails automatically if no other parameters are given

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

Edit these variables in the script and not the part in the ${}

POOL_NAME="/mnt/v1"

logs_loc="${POOL_NAME}/backup/Jails/logs"

FILE_NAME="Jail.log"

JAIL_DIR="${POOL_NAME}/iocage/jails"

BACKUP_LOC="${POOL_NAME}/backup/Jails"
