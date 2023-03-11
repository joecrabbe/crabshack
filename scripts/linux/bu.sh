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

# Ask the user if they would like to calculate the hashes of the backup folder.
echo "Would you like to calculate the hashes of everything in /root/bu/$ID?"
select yn in "Y" "N"; do
	case $yn in
		Y ) ./calculate_hashes.sh /root/bu/$ID; break;;
		N ) break;;
	esac
done
echo "Backup Complete!"


