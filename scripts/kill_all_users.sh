#!/bin/bash

if [ "$EUID" -ne 0 ]
then echo "This script must be ran as root!"
	exit
fi

userlist="$(cut -d : -f 1 /etc/passwd | grep -v root)"

echo "Currently connected users:"
w

for user in $userlist
do
	echo "Attempting to kill user $user..."
	pkill -KILL -u $user
done

echo "Waiting for processes to end..."
sleep 5
echo "Connected users after kick:"
w

exit 1
