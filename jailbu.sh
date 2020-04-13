#!/bin/bash
POOL_NAME="/mnt/v1"
logs_loc="${POOL_NAME}/backup/Jails/logs"
FILE_NAME="Jail.log"
JAIL_DIR="${POOL_NAME}/iocage/jails"
BACKUP_LOC="${POOL_NAME}/backup/Jails"
FULL_LOG_NAME=${logs_loc}/${FILE_NAME}
echo "FULL_LOG_NAME ="$FULL_LOG_NAME
echo "logs_loc ="$logs_loc
echo "JAIL_DIR ="$JAIL_DIR
echo "BACKUP_LOC ="$BACKUP_LOC
if  [ $1 == "R" ] || [ $1 == "r" ]; then
        iocage stop $2
        iocage destroy $2
        cp ${BACKUP_LOC}/${2}* ${POOL_NAME}/iocage/images/
        iocage import $2
        iocage start $2 
        echo "Restore of "${2}" complete"
else
if [ ! -d "${BACKUP_LOC}" ]; then
        mkdir -p "${BACKUP_LOC}"
        echo "create "${BACKUP_LOC}
else
        echo "The backup directory ${BACKUP_LOC} already exists!"
        rm ${BACKUP_LOC}*
        echo "Remove old Jail backups"
fi


if [ ! -d "${logs_loc}" ]; then
	mkdir -p "${logs_loc}"
        echo "create "${logs_loc}
else
	echo "The backup directory ${logs_loc} already exists!"
        rm ${FULL_LOG_NAME}
        echo "Old log file removed"
fi

cd $JAIL_DIR
shopt -s dotglob
shopt -s nullglob
array=(*)
for dir in "${array[@]}"
do
echo "********************${dir}******************************" >> ${FULL_LOG_NAME}

JAIL_NAME=$dir
echo "---Starting Backup of FreeNAS Jails---" >> ${FULL_LOG_NAME}
echo $(date) >> ${FULL_LOG_NAME}

#Jail #1 Backup
echo "Backing Up Jail" >> ${FULL_LOG_NAME}
echo $(date) >> ${FULL_LOG_NAME}
iocage stop ${JAIL_NAME} >> ${FULL_LOG_NAME}
iocage export ${JAIL_NAME} >> ${FULL_LOG_NAME}
iocage start ${JAIL_NAME} >> ${FULL_LOG_NAME}

if [ ! -d "${BACKUP_LOC}/${JAIL_NAME}*" ]; then
        echo "No old "${JAIL_NAME}" backups in "${BACKUP_LOC}
else
        echo "Old "${JAIL_NAME}" backups exist in "${BACKUP_LOC}
        echo "...Deleting old backups" >> ${FULL_LOG_NAME}
        echo $(date) >> ${FULL_LOG_NAME}
        rm ${BACKUP_LOC}/${JAIL_NAME}* >> ${FULL_LOG_NAME}
fi

echo "...Moving current backup to storage folders" >> ${FULL_LOG_NAME}
echo $(date) >> ${FULL_LOG_NAME}
mv -v ${POOL_NAME}/iocage/images/${JAIL_NAME}* ${BACKUP_LOC} >> ${FULL_LOG_NAME}

done

echo "There are ${#array[@]} jails backed up"
fi

