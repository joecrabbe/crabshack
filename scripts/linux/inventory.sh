#!/bin/bash

# Ensure root
if [ "$EUID" -ne 0 ]
then echo "This script must be ran as root!"
	exit
fi

# Print System name
source /etc/os-release
echo "Inventory for $PRETTY_NAME" | boxes -d html-cmt
echo ""

# Print OS Type/Version
echo "Operating System Info"
echo "OS: $NAME"
echo "Version: $VERSION"
echo ""

# Get list of non-loopback interfaces
if [ "$ID" = "ubuntu" ]
then 
	interfaces=$(netstat -i | grep -v 'Kernel' | grep -v 'Iface' | grep -v 'lo*' | cut -d " " -f 1)
elif [ "$ID" = "fedora" ]
then 
	interfaces=$(nmcli -t --fields "Device" c)
fi

# Get ip info <ipv4/CIDR> brd <broadcast addr> scope <scope> <ifname>
# ip - 4 addr show <ifname> | grep inet

# Get ether address info
# ip a s <ifname> | grep "link/ether"

# For all interfaces except for loopback, print IP addresses and Ether addresses
echo "Interface Info"
for interface in $interfaces
do
	ip=$(ip -4 addr show $interface | grep inet | awk '{ print $2 }')
	mac=$(ip a s $interface | grep "link/ether" | awk '{ print $2 }')
	echo "Interface $interface:"
	echo "IP Address: $ip"
	echo "Ethernet Address: $mac"
	echo ""
done

# Get list of services that are running on the system
echo "Service Info"
echo "Services Running: $(netstat -luntp4 | grep -v "127\.0\.0" | grep "LISTEN" | wc -l)"
echo ""

# Print the services table
# Print the table header
printf "%-8s %-21s %s\n" "Protocol" "Port" "Process"
# Print the services listening on tcp ports
netstat -lntp4 | grep -v "127\.0\.0" | grep "LISTEN" | while read connections
do 
	printf "%-8s %-21s %s\n" "$(echo $connections | cut -d ' ' -f 1)" "$(echo $connections | cut -d ' ' -f 4)" "$(echo $connections | cut -d ' ' -f 7)"
done

# Print the services open on udp ports
netstat -lnup4 | grep -v "127\.0\.0" | grep "udp" | tr -s ' ' | while read connections
do 
	printf "%-8s %-21s %s\n" "$(echo $connections | cut -d ' ' -f 1)" "$(echo $connections | cut -d ' ' -f 4)" "$(echo $connections | cut -d ' ' -f 6)"
done
echo ""

# Instructions for how to find a credible list of known vulnerabilities.
echo "For a list of known vulnerabilities, visit https://www.cvedetails.com/vendor-search.php"
echo "After locating and clicking on the vendor, there will be a 'Products' link at the top. Go from there."
echo "Ubuntu Vendor: Canonical"
echo "Fedora Vendor: Redhat"
echo "CentOS Vendor: Redhat"
echo "Splunk Vendor: Splunk"

