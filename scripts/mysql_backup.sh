#!/bin/bash
set -e

DATE=$(date +"%d%m%Y")
PREV_DAY_BACKUP=$(date +"%d%m%Y" -d "- 1 day")
DIR_BACKUP=~/backups
USER=user
PASSWORD=password


if [[ ! -f $DIR_BACKUP/$DATE/full/xtrabackup_checkpoints ]]; then
   rm -rf $DIR_BACKUP/$DATE/full
   mkdir -p $DIR_BACKUP/$DATE/full

   mariabackup --backup --target-dir=$DIR_BACKUP/$DATE/full --user=$USER --password=$PASSWORD

else 
   mkdir -p $DIR_BACKUP/$DATE/$(date +"%H")
   mariabackup --backup --target-dir=$DIR_BACKUP/$DATE/$(date +"%H")/ \
      --incremental-basedir=$DIR_BACKUP/$DATE/full \
      --user=$USER --password=$PASSWORD
fi

if [[ -d $DIR_BACKUP/$PREV_DAY_BACKUP ]]; then
   cd $DIR_BACKUP && tar -czf $PREV_DAY_BACKUP.tar.gz $PREV_DAY_BACKUP
   rm -rf $DIR_BACKUP/$PREV_DAY_BACKUP
fi
