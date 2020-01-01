#!/bin/sh

# Backup wordpress and all associated files and databases.
# Bitnami full backup instructions https://docs.bitnami.com/aws/apps/wordpress/#backup

#----------------------------------------
# OPTIONS
#----------------------------------------
NOW=$(date +"%F")
USER=bitnami
WORKING_DIR=/home/bitnami
BACKUP_PATH=/home/bitnami/backup
LOGS=$BACKUP_PATH/logs
LOG_FILE=$LOGS/wpbackup-$NOW.log
BUCKET=s3://allcomone.com.s3
#----------------------------------------

# Change to working directory
cd $WORKING_DIR

# Create the backup folder
if [ ! -d $BACKUP_PATH ]; then
  mkdir -p $BACKUP_PATH
fi


# Stop all services
echo "Stopping Services"
sudo /opt/bitnami/ctlscript.sh stop

# Compress entire directory
echo "Compressing directory /opt/bitnami"
sudo tar -pczvf $BACKUP_PATH/www-backup-$NOW.tgz /opt/bitnami

# Restart all services
echo "Starting Services"
sudo /opt/bitnami/ctlscript.sh start

echo "Backup complete at $BACKUP_PATH/www-backup-$NOW.tgz"

# Move to S3
echo "Moving backup file to S3 bucket at $BUCKET/$BACKUP_PATH/www-backup-$NOW.tgz"
aws s3 cp $BACKUP_PATH/www-backup-$NOW.tgz $BUCKET

echo "Removing local backup file at $BACKUP_PATH/www-backup-$NOW.tgz"
sudo rm $BACKUP_PATH/www-backup-$NOW.tgz


echo "Finished full backup and copied to S3"
echo "The backup file has been saved to $BUCKET/$BACKUP_PATH/www-backup-$NOW.tgz"

