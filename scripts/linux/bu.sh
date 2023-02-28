#!/bin/bash

# Ensure root.
if [ "$EUID" -ne 0 ]
then echo "This script must be ran as root!"
	exit
fi

# Get the name of the OS
source /etc/os-release

# Create Backup Folder
mkdir -p /root/bu/$ID

## Backup everything except for /dev, /proc, /sys, /tmp, /run, /mnt, /media, /root/bu \(The backup folder\), and /lost+found
rsync -aAXHv --exclude-from=../../config_files/excludelist / /root/bu/$ID

echo "Rsync complete. Beginning compression..."
sleep 3

# Zip the directory with all of the backed up files
tar -cvzf /root/bu/$ID.tar.gz /root/bu/$ID

# Now that the backup is zipped up, remove the original backup
rm -rf /root/bu/$ID/*

# Compute the sha1sum of the zipped backup
sha1sum /root/bu/$ID.tar.gz > /root/bu/$ID.tar.gz.sha1sum

echo "Backup Complete!"


