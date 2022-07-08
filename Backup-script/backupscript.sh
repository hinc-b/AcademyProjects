#!/bin/bash
#Backup script for task 06

#Variables
DIRECTORY="/usr/local/gzbackup"
FILES=`find /var/log -name *.gz -print`

#Creating directory
echo "Testing if directory exist"
if [ ! -d $DIRECTORY ]; then 
	mkdir -p $DIRECTORY 
fi

#Compressing .gz files into tarball
COUNTFILES=$(tar -cvf $DIRECTORY/backup.tar $FILES | wc -l) 

#Entry in log file
echo "Timestamp: $(date +"%D %T"); NumerOfFiles: $COUNTFILES" >> $DIRECTORY/backup.log
