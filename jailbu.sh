#!/bin/bash
# Variables
cron=""
POOL_NAME="/mnt/v1"
LOGS_LOC="${POOL_NAME}/backup/Jails/logs"
FILE_NAME="JAIL.LOG"
JAIL_DIR="${POOL_NAME}/iocage/jails"
JAIL_IMAGE="${POOL_NAME}/iocage/images"
BACKUP_LOC="${POOL_NAME}/backup/Jails"
FINAL="IOCAGE_"$(date +'_%F_%H%M')
BACKUP_DIR="${BACKUP_LOC}/${FINAL}" # The actual directory of the current backup - this is is subdirectory of the main directory above with a timestamp
FULL_LOG_NAME=${BACKUP_DIR}/$FILE_NAME
maxNrOfBackups=2 # The maximum number of backups to keep (when set to 0, all backups are kept)

echo "LOGS_LOC = "${LOGS_LOC}
echo "FULL_LOG_NAME = "$FULL_LOG_NAME
echo "JAIL_IMAGE ="$JAIL_IMAGE
echo "JAIL_DIR ="$JAIL_DIR
echo "BACKUP_LOC ="$BACKUP_LOC
echo "BACKUP_DIR = "$BACKUP_DIR

if  [ "$1" = "R" ] || [ "$1" = "r" ]; then
   #
   # Pick the restore directory *don't edit this section*
   #
   cd $BACKUP_LOC
   shopt -s dotglob
   shopt -s nullglob
   array=(*)
     for dir in "${array[@]}"; do echo; done
 
     for dir in */; do echo; done
 
     echo "There are ${#array[@]} backups available pick the one to restore"; \
     select dir in "${array[@]}"; do echo; break; done

     echo "You choose ${dir}"


     # More Variables
     restore=$dir
     currentRestoreDir="${BACKUP_LOC}/${restore}"
     echo $currentRestoreDir
     echo "$2 "$2

           iocage stop $2
           iocage destroy $2
           cp ${currentRestoreDir}/${2}* ${JAIL_IMAGE}
           iocage import $2
           iocage start $2
      echo "Restore of "${2}" from "${restore}" complete"


else

# echo "if BACKUP_LOC"
if [ ! -d "$BACKUP_LOC" ]; then
        echo "create "${BACKUP_LOC}
        mkdir -p "${BACKUP_LOC}"
fi

#ls -l $BACKUP_LOC/"ioc*"
echo "create logs"

#if [ ! -d "${BACKUP_DIR}/logs" ]; then
	mkdir -p "${BACKUP_DIR}"
        echo "create "${BACKUP_DIR}
#else
#	echo "The backup directory ${LOGS_LOC} already exists!"
#        rm ${FULL_LOG_NAME}
#        echo "Old log file removed"
#fi
touch ${FULL_LOG_NAME}
chmod 770 ${FULL_LOG_NAME}
#echo "---------------------------"
#echo "$(ls -l $BACKUP_DIR)"
#echo "---------------------------"
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
echo "Create file"${JAIL_DIR}"/images/"${JAIL_NAME}
# touch ${JAIL_IMAGE}/${JAIL_NAME}
iocage stop ${JAIL_NAME} >> ${FULL_LOG_NAME}
iocage export ${JAIL_NAME} >> ${FULL_LOG_NAME}
iocage start ${JAIL_NAME} >> ${FULL_LOG_NAME}

#if [ ! -d "${BACKUP_DIR}/${JAIL_NAME}*" ]; then
#        echo "No old "${JAIL_NAME}" backups in "${BACKUP_DIR}
#else
#        echo "Old "${JAIL_NAME}" backups exist in "${BACKUP_DIR}
#        echo "...Deleting old backups" >> ${FULL_LOG_NAME}
#        echo $(date) >> ${FULL_LOG_NAME}
#        rm ${BACKUP_DIR}/${JAIL_NAME}* >> ${FULL_LOG_NAME}
#fi

echo "...Moving current backup to storage folders" >> ${FULL_LOG_NAME}
echo $(date) >> ${FULL_LOG_NAME}
mv -v ${JAIL_IMAGE}/${JAIL_NAME}* ${BACKUP_DIR} >> ${FULL_LOG_NAME}

done

echo "There are ${#array[@]} jails backed up"
#fi

#
# Delete old backups
#
if [ ${maxNrOfBackups} -ne 0 ]
then
     echo "maxNrOfBackups is not 0"
        nrOfBackups="$(ls -l ${BACKUP_LOC} | grep -c ^d)"
     echo "nrOfBackups= "${nrOfBackups}
        nDirToRemove="$((nrOfBackups - maxNrOfBackups))"

     echo "nDirToRemove=" $nDirToRemove
echo "****************"
while [ $nDirToRemove -gt 0 ]
do
echo
echo "number dir to remove=" $nDirToRemove
dirToRemove="$(ls -t ${BACKUP_LOC} | tail -1)"
echo "Removing Directory ${dirToRemove}"
nDirToRemove="$((nDirToRemove - 1))"
rm -r ${BACKUP_LOC}/${dirToRemove}
done
fi

echo
echo "DONE!"
echo "Backup created: ${BACKUP_DIR}"
#exit 1
fi
