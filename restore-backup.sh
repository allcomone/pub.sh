#!/bin/sh

# Stop all services
echo "Stopping Services"
sudo /opt/bitnami/ctlscript.sh stop

# Moving the current stack to a different location
echo "Moving the current stack to a different location"
sudo mv /opt/bitnami /tmp/bitnami-backup

# Uncompress the backup file to the original directory
echo "Unpacking the backup file to the original directory"
sudo tar -pxzvf /home/bitnami/full-application-backup*.tgz -C /

# Starting Services
echo "Starting Services"
sudo /opt/bitnami/ctlscript.sh start