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

# Run integrity check on backup folder.
echo "Rsync complete. Beginning computation of sha1 digests..."
./integrity.sh /root/bu/$ID

echo "Backup Complete!"


